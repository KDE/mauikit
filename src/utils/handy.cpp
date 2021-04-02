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
#include "utils.h"
#include <QClipboard>
#include <QDebug>
#include <QIcon>
#include <QMimeData>
#include <QOperatingSystemVersion>
#include <QTouchDevice>

#include "platforms/platform.h"

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include "fmh.h"

#if defined Q_OS_LINUX && !defined Q_OS_ANDROID
#include <KSharedConfig>
#include <QFileSystemWatcher>
#endif

static const QUrl CONF_FILE = FMH::ConfigPath + "/kdeglobals";

#ifdef KSHAREDCONFIG_H
static const auto confCheck = [](QString key, QVariant defaultValue) -> QVariant {
    auto kconf = KSharedConfig::openConfig("kdeglobals");
    const auto group = kconf->group("KDE");
    if (group.hasKey(key))
        return group.readEntry(key, defaultValue);

    return defaultValue;
};
#endif

Handy::Handy(QObject *parent)
    : QObject(parent)
    , m_isTouch(Handy::isTouch())
{
#if defined Q_OS_LINUX && !defined Q_OS_ANDROID

    auto configWatcher = new QFileSystemWatcher({CONF_FILE.toLocalFile()}, this);

    m_singleClick = confCheck("SingleClick", m_singleClick).toBool();
    emit singleClickChanged();

    connect(configWatcher, &QFileSystemWatcher::fileChanged, [&](QString) {
        m_singleClick = confCheck("SingleClick", m_singleClick).toBool();
        emit singleClickChanged();
    });
#elif defined Q_OS_MAC || defined Q_OS_WIN32

    m_singleClick = false;
    emit singleClickChanged();

#endif
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
    auto clipbopard = QGuiApplication::clipboard();
#else
    auto clipbopard = QApplication::clipboard();
#endif

    auto mime = clipbopard->mimeData();
    if (mime->hasText())
        return clipbopard->text();

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
    if (mime->hasUrls())
        res.insert("urls", QUrl::toStringList(mime->urls()));

    if (mime->hasText())
        res.insert("text", mime->text());

    const QByteArray a = mime->data(QStringLiteral("application/x-kde-cutselection"));

    res.insert("cut", (!a.isEmpty() && a.at(0) == '1'));
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

bool Handy::isTouch()
{
    const auto devices = QTouchDevice::devices();
    for (const auto &device : devices) {
        if (device->type() == QTouchDevice::TouchScreen)
            return true;
        qDebug() << "DEVICE CAPABILITIES" << device->capabilities() << device->name();
    }

    return false;
}

bool Handy::hasKeyboard()
{
    return Platform::instance()->hasKeyboard();
}

bool Handy::hasMouse()
{
    return Platform::instance()->hasMouse();
}

bool Handy::isWindows()
{
    return FMH::isWindows();
}

bool Handy::isMac()
{
    return FMH::isMac();
}


QString Handy::formatSize(const int &size)
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
            format = "hh:mm:ss";
            tStr = time.toString(format);
    }
    
    return tStr.isEmpty() ? "00:00" : tStr;
}


void Handy::saveSettings(const QString &key, const QVariant &value, const QString &group)
{
    UTIL::saveSettings(key, value, group);
}

QVariant Handy::loadSettings(const QString &key, const QString &group, const QVariant &defaultValue)
{
    return UTIL::loadSettings(key, group, defaultValue);
}

