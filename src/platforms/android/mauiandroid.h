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

#pragma once

#include <QObject>
#include <QQmlEngine>

#include <QAndroidActivityResultReceiver>
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QtAndroid>

#include "abstractplatform.h"

/**
 * @brief The MAUIAndroid class
 */
class Q_DECL_EXPORT MAUIAndroid : public AbstractPlatform
{
    Q_OBJECT
     QML_NAMED_ELEMENT(Android)
    QML_SINGLETON
//    Q_DISABLE_COPY(MAUIAndroid)
    Q_DISABLE_MOVE(MAUIAndroid)

public:
    explicit MAUIAndroid(QObject *parent = nullptr);

//    static MAUIAndroid *instance()
//    {
//      if (m_instance)
//        return m_instance;

//      m_instance = new MAUIAndroid;
//      return m_instance;
//    }

    /**
     * @brief fileChooser
     */
    static void fileChooser();

    static QVariantList transform(const QAndroidJniObject &obj);
    static QVariantMap createVariantMap(jobject data);

private:
//    static MAUIAndroid *m_instance;
    void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data);


public Q_SLOTS:

    /**
     * @brief statusbarColor
     * @param bg
     * @param light
     */
    static void statusbarColor(const QString &bg, const bool &light);

    /**
     * @brief navBarColor
     * @param bg
     * @param light
     */
    static void navBarColor(const QString &bg, const bool &light);

    /**
     * @brief shareFiles
     * @param urls
     */
    void shareFiles(const QList<QUrl> &urls) override final;

    /**
     * @brief shareText
     * @param text
     */
    void shareText(const QString &text) override final;

    /**
     * @brief shareLink
     * @param link
     */
    static void shareLink(const QString &link);

    /**
     * @brief openUrl
     * @param url
     */
    static void openUrl(const QUrl &url);

    /**
     * @brief homePath
     * @return
     */
    static QString homePath();

    /**
     * @brief sdDirs
     * @return
     */
    static QStringList sdDirs();

    /**
     * @brief checkRunTimePermissions
     * @param permissions
     * @return
     */
    static bool checkRunTimePermissions(const QStringList &permissions);

    bool hasKeyboard() override final;
    bool hasMouse() override final;

Q_SIGNALS:
    /**
     * @brief folderPicked
     * @param path
     */
    void folderPicked(QString path);

    // AbstractPlatform interface
public Q_SLOTS:
    bool darkModeEnabled() override final;
};

//namespace PATHS
//{
//const QString HomePath = MAUIAndroid::homePath();
//const QString PicturesPath = HomePath + "/" + QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_PICTURES", "Ljava/lang/String;").toString();
//const QString DownloadsPath = HomePath + "/" + QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_DOWNLOADS", "Ljava/lang/String;").toString();
//const QString DocumentsPath = HomePath + "/" + QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_DOCUMENTS", "Ljava/lang/String;").toString();
//const QString MusicPath = HomePath + "/" + QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_MUSIC", "Ljava/lang/String;").toString();
//const QString VideosPath = HomePath + "/" + QAndroidJniObject::getStaticObjectField("android/os/Environment", "DIRECTORY_MOVIES", "Ljava/lang/String;").toString();
//}

