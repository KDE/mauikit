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

#ifndef MAUIKIT_H
#define MAUIKIT_H

#include "mauikit_export.h"
#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class MauiAccounts;
class MAUIKIT_EXPORT MauiKit : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) Q_DECL_OVERRIDE;
    static void initResources();

private:
    QUrl componentUrl(const QString &fileName) const;

    QString resolveFileUrl(const QString &filePath) const
    {
#if defined(Q_OS_ANDROID) && QT_VERSION >= QT_VERSION_CHECK(5, 14, 0)
        return QStringLiteral("qrc:/android_rcc_bundle/qml/org/mauikit/controls/") + filePath;
#else
#ifdef QUICK_COMPILER
        return QStringLiteral("qrc:/maui/kit/") + filePath;
#else
        return baseUrl().toString() + QLatin1Char('/') + filePath;
#endif
#endif
    }

    void initializeEngine(QQmlEngine *engine, const char *uri) override;
};

#endif // MAUIKIT_H
