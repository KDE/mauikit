/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "handy.h"
#include "fmh.h"

#include <QDateTime>
#include <QClipboard>
#include <QDebug>
#include <QIcon>
#include <QMimeData>
#include <QOperatingSystemVersion>
#include <QStandardPaths>
#include <QWindow>
#include <QMouseEvent>

#include "platforms/platform.h"

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
#include <QTouchDevice>
#else
#include <QInputDevice>
#endif

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
#include <MauiMan3/formfactormanager.h>
#include <MauiMan3/accessibilitymanager.h>
#else
#include <MauiMan4/formfactormanager.h>
#include <MauiMan4/accessibilitymanager.h>
#endif

Q_GLOBAL_STATIC(Handy, handyInstance)

Handy::Handy(QObject *parent)
    : QObject(parent)
    ,m_formFactor(new MauiMan::FormFactorManager(this))
    ,m_accessibility(new MauiMan::AccessibilityManager(this))
    ,m_hasTransientTouchInput(false)
{
    qDebug() << "CREATING INSTANCE OF MAUI HANDY";

    connect(m_accessibility, &MauiMan::AccessibilityManager::singleClickChanged, [&](bool value)
    {
        m_singleClick = value;
        Q_EMIT singleClickChanged();
    });

    m_singleClick = m_accessibility->singleClick();

// #ifdef FORMFACTOR_FOUND //TODO check here for Cask desktop enviroment

connect(m_formFactor, &MauiMan::FormFactorManager::preferredModeChanged, [this](uint value)
{
   m_ffactor = static_cast<FFactor>(value);
   m_mobile = m_ffactor == FFactor::Phone || m_ffactor == FFactor::Tablet;
   Q_EMIT formFactorChanged();
   Q_EMIT isMobileChanged();
});

connect(m_formFactor, &MauiMan::FormFactorManager::hasTouchscreenChanged, [this](bool value)
{
    m_isTouch = value || m_formFactor->forceTouchScreen();
    Q_EMIT isTouchChanged();
});

m_ffactor = static_cast<FFactor>(m_formFactor->preferredMode());
m_mobile = m_ffactor == FFactor::Phone || m_ffactor == FFactor::Tablet;
m_isTouch = m_formFactor->hasTouchscreen() || m_formFactor->forceTouchScreen();

    connect(qApp, &QGuiApplication::focusWindowChanged, this, [this](QWindow *win)
    {
        if (win)
        {
            win->installEventFilter(this);
        }
    });
}

Handy *Handy::instance()
{
    return handyInstance();
}

bool Handy::isTouch()
{
    return m_isTouch;
}

Handy::FFactor Handy::formFactor()
{
    return m_ffactor;
}

bool Handy::hasTransientTouchInput() const
{
    return m_hasTransientTouchInput;
}

void Handy::setTransientTouchInput(bool touch)
{
    if (touch == m_hasTransientTouchInput) {
        return;
    }

    m_hasTransientTouchInput = touch;
     Q_EMIT hasTransientTouchInputChanged();
}

bool Handy::eventFilter(QObject *watched, QEvent *event)
{
    Q_UNUSED(watched)
    switch (event->type())
    {
        case QEvent::TouchBegin:
            setTransientTouchInput(true);
            break;
        case QEvent::MouseButtonPress:
        case QEvent::MouseMove: {
            QMouseEvent *me = static_cast<QMouseEvent *>(event);
            if (me->source() == Qt::MouseEventNotSynthesized)
            {
                setTransientTouchInput(false);
            }
            break;
        }
        case QEvent::Wheel:
            setTransientTouchInput(false);
        default:
            break;
    }

    return false;
}

#ifdef Q_OS_ANDROID
static inline struct {
    QList<QUrl> urls;
    QString text;
    bool cut = false;

    bool hasUrls()
    {
        return !urls.isEmpty();
    }
    bool hasText()
    {
        return !text.isEmpty();
    }

} _clipboard;
#endif

QVariantMap Handy::userInfo()
{
    QString name = qgetenv("USER");
    if (name.isEmpty())
        name = qgetenv("USERNAME");

    return QVariantMap({{FMH::MODEL_NAME[FMH::MODEL_KEY::NAME], name}});
}

QString Handy::getClipboardText()
{
#ifdef Q_OS_ANDROID
    auto clipboard = QGuiApplication::clipboard();
#else
    auto clipboard = QApplication::clipboard();
#endif

    auto mime = clipboard->mimeData();
    if (mime->hasText())
        return clipboard->text();

    return QString();
}

QVariantMap Handy::getClipboard()
{
    QVariantMap res;
#ifdef Q_OS_ANDROID
    if (_clipboard.hasUrls())
        res.insert("urls", QUrl::toStringList(_clipboard.urls));

    if (_clipboard.hasText())
        res.insert("text", _clipboard.text);

    res.insert("cut", _clipboard.cut);
#else
    auto clipboard = QApplication::clipboard();

    auto mime = clipboard->mimeData();

    if(!mime)
        return res;

    if (mime->hasUrls())
        res.insert("urls", QUrl::toStringList(mime->urls()));

    if (mime->hasText())
        res.insert("text", mime->text());

    if(mime->hasImage())
        res.insert("image", mime->imageData());

    const QByteArray a = mime->data(QStringLiteral("application/x-kde-cutselection"));

    res.insert("cut", !a.isEmpty() && a.at(0) == '1');
#endif
    return res;
}

bool Handy::copyToClipboard(const QVariantMap &value, const bool &cut)
{
#ifdef Q_OS_ANDROID
    if (value.contains("urls"))
        _clipboard.urls = QUrl::fromStringList(value["urls"].toStringList());

    if (value.contains("text"))
        _clipboard.text = value["text"].toString();

    _clipboard.cut = cut;

    return true;
#else
    auto clipboard = QApplication::clipboard();
    QMimeData *mimeData = new QMimeData();

    if (value.contains("urls"))
        mimeData->setUrls(QUrl::fromStringList(value["urls"].toStringList()));

    if (value.contains("text"))
        mimeData->setText(value["text"].toString());

    mimeData->setData(QStringLiteral("application/x-kde-cutselection"), cut ? "1" : "0");
    clipboard->setMimeData(mimeData);

    return true;
#endif

    return false;
}

bool Handy::copyTextToClipboard(const QString &text)
{
#ifdef Q_OS_ANDROID
    Handy::copyToClipboard({{"text", text}});
#else
    QApplication::clipboard()->setText(text);
#endif
    return true;
}

int Handy::version()
{
    return QOperatingSystemVersion::current().majorVersion();
}

bool Handy::isAndroid()
{
    return FMH::isAndroid();
}

bool Handy::isLinux()
{
    return FMH::isLinux();
}

bool Handy::isIOS()
{
    return FMH::isIOS();
}

bool Handy::hasKeyboard()
{
    return m_formFactor->hasKeyboard();
}

bool Handy::hasMouse()
{
    return m_formFactor->hasMouse();
}

bool Handy::isWindows()
{
    return FMH::isWindows();
}

bool Handy::isMac()
{
    return FMH::isMac();
}


QString Handy::formatSize(quint64 size)
{
    const QLocale locale;
    return locale.formattedDataSize(size);
}

QString Handy::formatDate(const QString &dateStr, const QString &format, const QString &initFormat)
{
    if (initFormat.isEmpty())
        return QDateTime::fromString(dateStr, Qt::TextDate).toString(format);
    else
        return QDateTime::fromString(dateStr, initFormat).toString(format);
}

QString Handy::formatTime(const qint64 &value)
{
    QString tStr;
    if (value) {
        QTime time((value / 3600) % 60, (value / 60) % 60, value % 60, (value * 1000) % 1000);
        QString format = "mm:ss";
        if (value > 3600)
        {
            format = "hh:mm:ss";
        }
        tStr = time.toString(format);
    }

    return tStr.isEmpty() ? "00:00" : tStr;
}

bool Handy::isMobile() const
{
    return m_mobile;
}
