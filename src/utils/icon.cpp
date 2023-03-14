/*
 *  SPDX-FileCopyrightText: 2011 Marco Martin <mart@kde.org>
 *  SPDX-FileCopyrightText: 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "icon.h"
#include "platformtheme.h"
#include "managedtexturenode.h"

#include <QBitmap>
#include <QDebug>
#include <QGuiApplication>
#include <QIcon>
#include <QPainter>
#include <QQuickImageProvider>
#include <QQuickWindow>
#include <QSGSimpleTextureNode>
#include <QSGTexture>
#include <QScreen>
#include <QtQml>

Q_GLOBAL_STATIC(ImageTexturesCache, s_iconImageCache)

#include <MauiMan/thememanager.h>

Icon::Icon(QQuickItem *parent)
    : QQuickItem(parent)
    , m_changed(false)
    , m_active(false)
    , m_selected(false)
    , m_isMask(false)
{
    setFlag(ItemHasContents, true);
    // Using 32 because Icon used to redefine implicitWidth and implicitHeight and hardcode them to 32
    setImplicitSize(32, 32);
    // FIXME: not necessary anymore
    connect(qApp, &QGuiApplication::paletteChanged, this, &QQuickItem::polish);
    connect(this, &QQuickItem::enabledChanged, this, &QQuickItem::polish);
    connect(this, &QQuickItem::smoothChanged, this, &QQuickItem::polish);
    
}

Icon::~Icon()
{
}

void Icon::setSource(const QVariant &icon)
{
    if (m_source == icon) {
        return;
    }
    m_source = icon;
    m_monochromeHeuristics.clear();

    if (!m_theme) {
        m_theme = static_cast<Maui::PlatformTheme *>(qmlAttachedPropertiesObject<Maui::PlatformTheme>(this, true));
        Q_ASSERT(m_theme);

        connect(m_theme, &Maui::PlatformTheme::PlatformTheme::colorsChanged, this, &QQuickItem::polish);
    }

    if (icon.type() == QVariant::String) {
        const QString iconSource = icon.toString();
        m_isMaskHeuristic = (iconSource.endsWith(QLatin1String("-symbolic")) //
                             || iconSource.endsWith(QLatin1String("-symbolic-rtl")) //
                             || iconSource.endsWith(QLatin1String("-symbolic-ltr")));
        Q_EMIT isMaskChanged();
    }

    if (m_networkReply) {
        // if there was a network query going on, interrupt it
        m_networkReply->close();
    }
    m_loadedImage = QImage();
    setStatus(Loading);

    polish();
    Q_EMIT sourceChanged();
    Q_EMIT validChanged();
}

QVariant Icon::source() const
{
    return m_source;
}

void Icon::setActive(const bool active)
{
    if (active == m_active) {
        return;
    }
    m_active = active;
    polish();
    Q_EMIT activeChanged();
}

bool Icon::active() const
{
    return m_active;
}

bool Icon::valid() const
{
    // TODO: should this be return m_status == Ready?
    // Consider an empty URL invalid, even though isNull() will say false
    if (m_source.canConvert<QUrl>() && m_source.toUrl().isEmpty()) {
        return false;
    }

    return !m_source.isNull();
}

void Icon::setSelected(const bool selected)
{
    if (selected == m_selected) {
        return;
    }
    m_selected = selected;
    polish();
    Q_EMIT selectedChanged();
}

bool Icon::selected() const
{
    return m_selected;
}

void Icon::setIsMask(bool mask)
{
    if (m_isMask == mask) {
        return;
    }

    m_isMask = mask;
    m_isMaskHeuristic = mask;
    polish();
    Q_EMIT isMaskChanged();
}

bool Icon::isMask() const
{
    return m_isMask || m_isMaskHeuristic;
}

void Icon::setColor(const QColor &color)
{
    if (m_color == color) {
        return;
    }

    m_color = color;
    polish();
    Q_EMIT colorChanged();
}

QColor Icon::color() const
{
    return m_color;
}

QSGNode *Icon::updatePaintNode(QSGNode *node, QQuickItem::UpdatePaintNodeData * /*data*/)
{
    if (m_source.isNull() || qFuzzyIsNull(width()) || qFuzzyIsNull(height())) {
        delete node;
        return Q_NULLPTR;
    }

    if (m_changed || node == nullptr) {
        const QSize itemSize(width(), height());
        QRect nodeRect(QPoint(0, 0), itemSize);

        ManagedTextureNode *mNode = dynamic_cast<ManagedTextureNode *>(node);
        if (!mNode) {
            delete node;
            mNode = new ManagedTextureNode;
        }
        if (itemSize.width() != 0 && itemSize.height() != 0) {
            mNode->setTexture(s_iconImageCache->loadTexture(window(), m_icon, QQuickWindow::TextureCanUseAtlas));
            if (m_icon.size() != itemSize) {
                // At this point, the image will already be scaled, but we need to output it in
                // the correct aspect ratio, painted centered in the viewport. So:
                QRect destination(QPoint(0, 0), m_icon.size().scaled(itemSize, Qt::KeepAspectRatio));
                destination.moveCenter(nodeRect.center());
                nodeRect = destination;
            }
        }
        mNode->setRect(nodeRect);
        node = mNode;
        if (smooth()) {
            mNode->setFiltering(QSGTexture::Linear);
        }
        m_changed = false;
    }

    return node;
}

void Icon::refresh()
{
    this->polish();
}

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
void Icon::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickItem::geometryChanged(newGeometry, oldGeometry);
#else
void Icon::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickItem::geometryChange(newGeometry, oldGeometry);
#endif
    if (newGeometry.size() != oldGeometry.size()) {
        polish();
    }
}

void Icon::handleRedirect(QNetworkReply *reply)
{
    QNetworkAccessManager *qnam = reply->manager();
    if (reply->error() != QNetworkReply::NoError) {
        return;
    }
    const QUrl possibleRedirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (!possibleRedirectUrl.isEmpty()) {
        const QUrl redirectUrl = reply->url().resolved(possibleRedirectUrl);
        if (redirectUrl == reply->url()) {
            // no infinite redirections thank you very much
            reply->deleteLater();
            return;
        }
        reply->deleteLater();
        QNetworkRequest request(possibleRedirectUrl);
        request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
        m_networkReply = qnam->get(request);
        connect(m_networkReply.data(), &QNetworkReply::finished, this, [this]() {
            handleFinished(m_networkReply);
        });
    }
}

void Icon::handleFinished(QNetworkReply *reply)
{
    if (!reply) {
        return;
    }

    reply->deleteLater();
    if (!reply->attribute(QNetworkRequest::RedirectionTargetAttribute).isNull()) {
        handleRedirect(reply);
        return;
    }

    m_loadedImage = QImage();

    const QString filename = reply->url().fileName();
    if (!m_loadedImage.load(reply, filename.mid(filename.indexOf(QLatin1Char('.'))).toLatin1().constData())) {
        qWarning() << "received broken image" << reply->url();

        // broken image from data, inform the user of this with some useful broken-image thing...
        const QIcon icon = QIcon::fromTheme(m_fallback);
        m_loadedImage = icon.pixmap(window(), icon.actualSize(size().toSize()), iconMode(), QIcon::On).toImage();
    }

    polish();
}

void Icon::updatePolish()
{
    QQuickItem::updatePolish();

    if (m_source.isNull()) {
        setStatus(Ready);
        updatePaintedGeometry();
        update();
        return;
    }

    const QSize itemSize(width(), height());
    if (itemSize.width() != 0 && itemSize.height() != 0) {
        const auto multiplier = QCoreApplication::instance()->testAttribute(Qt::AA_UseHighDpiPixmaps)
            ? 1
            : (window() ? window()->effectiveDevicePixelRatio() : qGuiApp->devicePixelRatio());
        const QSize size = itemSize * multiplier;

        switch (m_source.type()) {
        case QVariant::Pixmap:
            m_icon = m_source.value<QPixmap>().toImage();
            break;
        case QVariant::Image:
            m_icon = m_source.value<QImage>();
            break;
        case QVariant::Bitmap:
            m_icon = m_source.value<QBitmap>().toImage();
            break;
        case QVariant::Icon: {
            const QIcon icon = m_source.value<QIcon>();
            m_icon = icon.pixmap(window(), icon.actualSize(itemSize), iconMode(), QIcon::On).toImage();
            break;
        }
        case QVariant::Url:
        case QVariant::String:
            m_icon = findIcon(size);
            break;
        case QVariant::Brush:
            // todo: fill here too?
        case QVariant::Color:
            m_icon = QImage(size, QImage::Format_Alpha8);
            m_icon.fill(m_source.value<QColor>());
            break;
        default:
            break;
        }

        if (m_icon.isNull()) {
            m_icon = QImage(size, QImage::Format_Alpha8);
            m_icon.fill(Qt::transparent);
        }

        const QColor tintColor = //
            !m_color.isValid() || m_color == Qt::transparent //
            ? (m_selected ? m_theme->highlightedTextColor() : m_theme->textColor())
            : m_color;

        // TODO: initialize m_isMask with icon.isMask()
        if (tintColor.alpha() > 0 && (isMask() || guessMonochrome(m_icon))) {
            QPainter p(&m_icon);
            p.setCompositionMode(QPainter::CompositionMode_SourceIn);
            p.fillRect(m_icon.rect(), tintColor);
            p.end();
        }
    }
    m_changed = true;
    updatePaintedGeometry();
    update();
}

QImage Icon::findIcon(const QSize &size)
{
    QImage img;
    QString iconSource = m_source.toString();

    if (iconSource.startsWith(QLatin1String("image://"))) {
        const auto multiplier = QCoreApplication::instance()->testAttribute(Qt::AA_UseHighDpiPixmaps)
            ? (window() ? window()->effectiveDevicePixelRatio() : qGuiApp->devicePixelRatio())
            : 1;
        QUrl iconUrl(iconSource);
        QString iconProviderId = iconUrl.host();
        // QUrl path has the  "/" prefix while iconId does not
        QString iconId = iconUrl.path().remove(0, 1);

        QSize actualSize;
        QQuickImageProvider *imageProvider = dynamic_cast<QQuickImageProvider *>(qmlEngine(this)->imageProvider(iconProviderId));
        if (!imageProvider) {
            return img;
        }
        switch (imageProvider->imageType()) {
        case QQmlImageProviderBase::Image:
            img = imageProvider->requestImage(iconId, &actualSize, size * multiplier);
            if (!img.isNull()) {
                setStatus(Ready);
            }
            break;
        case QQmlImageProviderBase::Pixmap:
            img = imageProvider->requestPixmap(iconId, &actualSize, size * multiplier).toImage();
            if (!img.isNull()) {
                setStatus(Ready);
            }
            break;
        case QQmlImageProviderBase::ImageResponse: {
            if (!m_loadedImage.isNull()) {
                setStatus(Ready);
                return m_loadedImage.scaled(size, Qt::KeepAspectRatio, smooth() ? Qt::SmoothTransformation : Qt::FastTransformation);
            }
            QQuickAsyncImageProvider *provider = dynamic_cast<QQuickAsyncImageProvider *>(imageProvider);
            auto response = provider->requestImageResponse(iconId, size * multiplier);
            connect(response, &QQuickImageResponse::finished, this, [iconId, response, this]() {
                if (response->errorString().isEmpty()) {
                    QQuickTextureFactory *textureFactory = response->textureFactory();
                    if (textureFactory) {
                        m_loadedImage = textureFactory->image();
                        delete textureFactory;
                    }
                    if (m_loadedImage.isNull()) {
                        // broken image from data, inform the user of this with some useful broken-image thing...
                        const QIcon icon = QIcon::fromTheme(m_fallback);
                        m_loadedImage = icon.pixmap(window(), icon.actualSize(QSize(width(), height())), iconMode(), QIcon::On).toImage();
                        setStatus(Error);
                    } else {
                        setStatus(Ready);
                    }
                    polish();
                }
                response->deleteLater();
            });
            // Temporary icon while we wait for the real image to load...
            const QIcon icon = QIcon::fromTheme(m_placeholder);
            img = icon.pixmap(window(), icon.actualSize(size), iconMode(), QIcon::On).toImage();
            break;
        }
        case QQmlImageProviderBase::Texture: {
            QQuickTextureFactory *textureFactory = imageProvider->requestTexture(iconId, &actualSize, size * multiplier);
            if (textureFactory) {
                img = textureFactory->image();
            }
            if (img.isNull()) {
                // broken image from data, or the texture factory wasn't healthy, inform the user of this with some useful broken-image thing...
                const QIcon icon = QIcon::fromTheme(m_fallback);
                img = icon.pixmap(window(), icon.actualSize(QSize(width(), height())), iconMode(), QIcon::On).toImage();
                setStatus(Error);
            } else {
                setStatus(Ready);
            }
            break;
        }
        case QQmlImageProviderBase::Invalid:
            // will have to investigate this more
            setStatus(Error);
            break;
        }
    } else if (iconSource.startsWith(QLatin1String("http://")) || iconSource.startsWith(QLatin1String("https://"))) {
        if (!m_loadedImage.isNull()) {
            setStatus(Ready);
            return m_loadedImage.scaled(size, Qt::KeepAspectRatio, smooth() ? Qt::SmoothTransformation : Qt::FastTransformation);
        }
        const auto url = m_source.toUrl();
        QQmlEngine *engine = qmlEngine(this);
        QNetworkAccessManager *qnam;
        if (engine && (qnam = engine->networkAccessManager()) && (!m_networkReply || m_networkReply->url() != url)) {
            QNetworkRequest request(url);
            request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
            m_networkReply = qnam->get(request);
            connect(m_networkReply.data(), &QNetworkReply::finished, this, [this]() {
                handleFinished(m_networkReply);
            });
        }
        // Temporary icon while we wait for the real image to load...
        const QIcon icon = QIcon::fromTheme(m_placeholder);
        img = icon.pixmap(window(), icon.actualSize(size), iconMode(), QIcon::On).toImage();
    } else {
        if (iconSource.startsWith(QLatin1String("qrc:/"))) {
            iconSource = iconSource.mid(3);
        } else if (iconSource.startsWith(QLatin1String("file:/"))) {
            iconSource = QUrl(iconSource).path();
        }

        QIcon icon;
        const bool isPath = iconSource.contains(QLatin1String("/"));
        if (isPath) {
            icon = QIcon(iconSource);
        } else {
            if (icon.isNull()) {
                icon = m_theme->iconFromTheme(iconSource, m_color);
            }
        }
        if (!icon.isNull()) {
            img = icon.pixmap(window(), icon.actualSize(window(), size), iconMode(), QIcon::On).toImage();

            setStatus(Ready);
            /*const QColor tintColor = !m_color.isValid() || m_color == Qt::transparent ? (m_selected ? m_theme->highlightedTextColor() : m_theme->textColor())
            : m_color;

            if (m_isMask || icon.isMask() || iconSource.endsWith(QLatin1String("-symbolic")) || iconSource.endsWith(QLatin1String("-symbolic-rtl")) ||
            iconSource.endsWith(QLatin1String("-symbolic-ltr")) || guessMonochrome(img)) { //
                QPainter p(&img);
                p.setCompositionMode(QPainter::CompositionMode_SourceIn);
                p.fillRect(img.rect(), tintColor);
                p.end();
            }*/
        }
    }

    if (!iconSource.isEmpty() && img.isNull()) {
        setStatus(Error);
        const QIcon icon = QIcon::fromTheme(m_fallback);
        img = icon.pixmap(window(), icon.actualSize(size), iconMode(), QIcon::On).toImage();
    }
    return img;
}

QIcon::Mode Icon::iconMode() const
{
    if (!isEnabled()) {
        return QIcon::Disabled;
    } else if (m_selected) {
        return QIcon::Selected;
    } else if (m_active) {
        return QIcon::Active;
    }
    return QIcon::Normal;
}

bool Icon::guessMonochrome(const QImage &img)
{
    // don't try for too big images
    if (img.width() >= 256 || m_theme->supportsIconColoring()) {
        return false;
    }
    // round size to a standard size. hardcode as we can't use KIconLoader
    int stdSize;
    if (img.width() <= 16) {
        stdSize = 16;
    } else if (img.width() <= 22) {
        stdSize = 22;
    } else if (img.width() <= 24) {
        stdSize = 24;
    } else if (img.width() <= 32) {
        stdSize = 32;
    } else if (img.width() <= 48) {
        stdSize = 48;
    } else if (img.width() <= 64) {
        stdSize = 64;
    } else {
        stdSize = 128;
    }

    auto findIt = m_monochromeHeuristics.constFind(stdSize);
    if (findIt != m_monochromeHeuristics.constEnd()) {
        return findIt.value();
    }

    QHash<int, int> dist;
    int transparentPixels = 0;
    int saturatedPixels = 0;
    for (int x = 0; x < img.width(); x++) {
        for (int y = 0; y < img.height(); y++) {
            QColor color = QColor::fromRgba(qUnpremultiply(img.pixel(x, y)));
            if (color.alpha() < 100) {
                ++transparentPixels;
                continue;
            } else if (color.saturation() > 84) {
                ++saturatedPixels;
            }
            dist[qGray(color.rgb())]++;
        }
    }

    QMultiMap<int, int> reverseDist;
    auto it = dist.constBegin();
    qreal entropy = 0;
    while (it != dist.constEnd()) {
        reverseDist.insert(it.value(), it.key());
        qreal probability = qreal(it.value()) / qreal(img.size().width() * img.size().height() - transparentPixels);
        entropy -= probability * log(probability) / log(255);
        ++it;
    }

    // Arbitrarily low values of entropy and colored pixels
    m_monochromeHeuristics[stdSize] = saturatedPixels <= (img.size().width() * img.size().height() - transparentPixels) * 0.3 && entropy <= 0.3;
    return m_monochromeHeuristics[stdSize];
}

QString Icon::fallback() const
{
    return m_fallback;
}

void Icon::setFallback(const QString &fallback)
{
    if (m_fallback != fallback) {
        m_fallback = fallback;
        Q_EMIT fallbackChanged(fallback);
    }
}

QString Icon::placeholder() const
{
    return m_placeholder;
}

void Icon::setPlaceholder(const QString &placeholder)
{
    if (m_placeholder != placeholder) {
        m_placeholder = placeholder;
        Q_EMIT placeholderChanged(placeholder);
    }
}

void Icon::setStatus(Status status)
{
    if (status == m_status) {
        return;
    }

    m_status = status;
    Q_EMIT statusChanged();
}

Icon::Status Icon::status() const
{
    return m_status;
}

qreal Icon::paintedWidth() const
{
    return m_paintedWidth;
}

qreal Icon::paintedHeight() const
{
    return m_paintedHeight;
}

void Icon::updatePaintedGeometry()
{
    qreal newWidth = 0.0;
    qreal newHeight = 0.0;
    if (!m_icon.width() || !m_icon.height()) {
        newWidth = newHeight = 0.0;
    } else {
        const qreal w = widthValid() ? width() : m_icon.size().width();
        const qreal widthScale = w / m_icon.size().width();
        const qreal h = heightValid() ? height() : m_icon.size().height();
        const qreal heightScale = h / m_icon.size().height();
        if (widthScale <= heightScale) {
            newWidth = w;
            newHeight = widthScale * m_icon.size().height();
        } else if (heightScale < widthScale) {
            newWidth = heightScale * m_icon.size().width();
            newHeight = h;
        }
    }
    if (newWidth != m_paintedWidth || newHeight != m_paintedHeight) {
        m_paintedWidth = newWidth;
        m_paintedHeight = newHeight;
        Q_EMIT paintedAreaChanged();
    }
}

void Icon::itemChange(QQuickItem::ItemChange change, const QQuickItem::ItemChangeData &value)
{
    if (change == QQuickItem::ItemDevicePixelRatioHasChanged) {
        polish();
    }
    QQuickItem::itemChange(change, value);
}

#include "moc_icon.cpp"
