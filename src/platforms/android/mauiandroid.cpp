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

#include "mauiandroid.h"
#include <QColor>
#include <QCoreApplication>
#include <QDebug>
#include <QException>
#include <QFile>
#include <QFileInfo>
#include <QImage>
#include <QMimeData>
#include <QMimeDatabase>
#include <QProcess>
#include <QUrl>
#include <QOperatingSystemVersion>

#include <android/bitmap.h>

#include <QtCore/private/qandroidextras_p.h>
// WindowManager.LayoutParams
#define FLAG_TRANSLUCENT_STATUS 0x04000000
#define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS 0x80000000
// View
#define SYSTEM_UI_FLAG_LIGHT_STATUS_BAR 0x00002000
#define SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR 0x00000010

class InterfaceConnFailedException : public QException
{
public:
    void raise() const
    {
        throw *this;
    }
    InterfaceConnFailedException *clone() const
    {
        return new InterfaceConnFailedException(*this);
    }
};

static MAUIAndroid *m_instance = nullptr;

MAUIAndroid::MAUIAndroid(QObject *parent)
    : AbstractPlatform(parent)
{
    m_instance = this;
    //    connect(qApp, &QCoreApplication::aboutToQuit, []()
    //    {
    //        qDebug() << "Lets remove MauiApp singleton instance";
    //        delete m_instance;
    //        m_instance = nullptr;
    //    });

}

static QJniObject getAndroidWindow()
{
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    auto window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
    window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
    window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);
    return window;
}

void MAUIAndroid::statusbarColor(const QString &bg, const bool &light)
{
    if (QNativeInterface::QAndroidApplication::sdkVersion() <= 23)
        return;
    qDebug() << "Set the status bar color" << light;
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([=]() {
        QJniObject window = getAndroidWindow();
        QJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (light)
            visibility |= SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
        window.callMethod<void>("setStatusBarColor", "(I)V", QColor(bg).rgba());
    });
}

void MAUIAndroid::navBarColor(const QString &bg, const bool &light)
{
    if (QNativeInterface::QAndroidApplication::sdkVersion() <= 23)
        return;
    qDebug() << "Set the nav bar color" << light;

    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([=]() {
        QJniObject window = getAndroidWindow();
        QJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (light)
            visibility |= SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
        window.callMethod<void>("setNavigationBarColor", "(I)V", QColor(bg).rgba());
    });
}

void MAUIAndroid::shareFiles(const QList<QUrl> &urls)
{
    QJniEnvironment _env;
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative", "activity", "()Landroid/app/Activity;"); // activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }

    if(urls.isEmpty())
        return;

    if (activity.isValid())
    {
        qDebug() << "trying to share dialog << valid" << QString("%1.provider").arg(qApp->organizationDomain()) ;

        QMimeDatabase mimedb;
        QString mimeType = mimedb.mimeTypeForFile(urls.first().toLocalFile()).name();

        jobjectArray stringArray = _env->NewObjectArray(urls.count(), _env->FindClass("java/lang/String"), NULL);

        int index = -1;
        for(auto url : urls)
        {
            _env->SetObjectArrayElement(stringArray, ++index, QJniObject::fromString(url.toLocalFile()).object<jstring>());
        }

        QJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                           "share",
                                           "(Landroid/app/Activity;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                           activity.object<jobject>(),
                                           QJniObject::fromLocalRef(stringArray).object<jobjectArray>(),
                                           QJniObject::fromString(mimeType).object<jstring>(),
                                           QJniObject::fromString(QString("%1.provider").arg(qApp->organizationDomain())).object<jstring>());

        if (_env->ExceptionCheck())
        {
            qDebug() << "trying to share dialog << exception";

            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    } else
        throw InterfaceConnFailedException();
}


void MAUIAndroid::shareText(const QString &text)
{
    qDebug() << "trying to share text";
    QJniEnvironment _env;
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative", "activity", "()Landroid/app/Activity;"); // activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if (activity.isValid()) {
        QJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent", "sendText", "(Landroid/app/Activity;Ljava/lang/String;)V", activity.object<jobject>(), QJniObject::fromString(text).object<jstring>());

        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    } else
        throw InterfaceConnFailedException();
}

void MAUIAndroid::shareLink(const QString &link)
{
    qDebug() << "trying to share link";
    QJniEnvironment _env;
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative", "activity", "()Landroid/app/Activity;"); // activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if (activity.isValid()) {
        QJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent", "sendUrl", "(Landroid/app/Activity;Ljava/lang/String;)V", activity.object<jobject>(), QJniObject::fromString(link).object<jstring>());

        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    } else
        throw InterfaceConnFailedException();
}

void MAUIAndroid::openUrl(const QUrl &url)
{
    qDebug() << "trying to open file with";
    QJniEnvironment _env;
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative", "activity", "()Landroid/app/Activity;"); // activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if (activity.isValid())
    {
        QMimeDatabase mimedb;
        QString mimeType = mimedb.mimeTypeForFile(url.toLocalFile()).name();

        QJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                           "openUrl",
                                           "(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                           activity.object<jobject>(),
                                           QJniObject::fromString(url.toLocalFile()).object<jstring>(),
                                           QJniObject::fromString(mimeType).object<jstring>(),
                                           QJniObject::fromString(QString("%1.provider").arg(qApp->organizationDomain())).object<jstring>());

        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    } else
        throw InterfaceConnFailedException();
}

QString MAUIAndroid::homePath()
{
    QJniObject mediaDir = QJniObject::callStaticObjectMethod("android/os/Environment", "getExternalStorageDirectory", "()Ljava/io/File;");
    QJniObject mediaPath = mediaDir.callObjectMethod("getAbsolutePath", "()Ljava/lang/String;");

    return mediaPath.toString();
}

QString MAUIAndroid::getStandardPath(QStandardPaths::StandardLocation path)
{
    QString type;
    switch(path)
    {
    case QStandardPaths::PicturesLocation: type = "Pictures"; break;
    case QStandardPaths::MusicLocation: type = "Music"; break;
    case QStandardPaths::DocumentsLocation: type = "Documents"; break;
    case QStandardPaths::DownloadLocation: type = "Download"; break;
    case QStandardPaths::MoviesLocation: type = "Movies"; break;
    default: type = "";
    }

    if(type.isEmpty())
        return "";

    QJniObject mediaDir = QJniObject::callStaticObjectMethod("android/os/Environment",
                                                             "getExternalStoragePublicDirectory",
                                                             "(Ljava/lang/String;)Ljava/io/File;",
                                                             QJniObject::fromString(type).object<jstring>());
    QJniObject mediaPath = mediaDir.callObjectMethod("getAbsolutePath", "()Ljava/lang/String;");

    return mediaPath.toString();
}

QStringList MAUIAndroid::sdDirs()
{
    QStringList res;

    //    QJniObject mediaDir = QJniObject::callStaticObjectMethod("com/kde/maui/tools/SDCard", "findSdCardPath", "(Landroid/content/Context;)Ljava/io/File;", QtAndroid::androidActivity().object<jobject>());

    //    if (mediaDir == NULL)
    //        return res;

    //    QJniObject mediaPath = mediaDir.callObjectMethod("getAbsolutePath", "()Ljava/lang/String;");
    //    QString dataAbsPath = mediaPath.toString();

    //    res << QUrl::fromLocalFile(dataAbsPath).toString();
    return res;
}

// void MAUIAndroid::handleActivityResult(int receiverRequestCode, int resultCode, const QJniObject &data)
//{
//    qDebug() << "ACTIVITY RESULTS";
//    jint RESULT_OK = QJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");

//    if (receiverRequestCode == 42 && resultCode == RESULT_OK) {
//        QString url = data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;").toString();
//        emit folderPicked(url);
//    }
//}

void MAUIAndroid::fileChooser()
{
    QJniEnvironment _env;
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative", "activity", "()Landroid/app/Activity;"); // activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if (activity.isValid()) {
        QJniObject::callStaticMethod<void>("com/example/android/tools/SendIntent", "fileChooser", "(Landroid/app/Activity;)V", activity.object<jobject>());
        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    } else
        throw InterfaceConnFailedException();
}

QVariantList MAUIAndroid::transform(const QJniObject &obj)
{
    QVariantList res;
    const auto size = obj.callMethod<jint>("size", "()I");

    for (auto i = 0; i < size; i++) {
        QJniObject hashObj = obj.callObjectMethod("get", "(I)Ljava/lang/Object;", i);
        res << createVariantMap(hashObj.object<jobject>());
    }

    return res;
}

QVariantMap MAUIAndroid::createVariantMap(jobject data)
{
    QVariantMap res;

    QJniEnvironment env;
    /* Reference : https://community.oracle.com/thread/1549999 */

           // Get the HashMap Class
    jclass jclass_of_hashmap = (env)->GetObjectClass(data);

           // Get link to Method "entrySet"
    jmethodID entrySetMethod = (env)->GetMethodID(jclass_of_hashmap, "entrySet", "()Ljava/util/Set;");

           // Invoke the "entrySet" method on the HashMap object
    jobject jobject_of_entryset = env->CallObjectMethod(data, entrySetMethod);

           // Get the Set Class
    jclass jclass_of_set = (env)->FindClass("java/util/Set"); // Problem during compilation !!!!!

    if (jclass_of_set == 0) {
        qWarning() << "java/util/Set lookup failed\n";
        return res;
    }

           // Get link to Method "iterator"
    jmethodID iteratorMethod = env->GetMethodID(jclass_of_set, "iterator", "()Ljava/util/Iterator;");

           // Invoke the "iterator" method on the jobject_of_entryset variable of type Set
    jobject jobject_of_iterator = env->CallObjectMethod(jobject_of_entryset, iteratorMethod);

           // Get the "Iterator" class
    jclass jclass_of_iterator = (env)->FindClass("java/util/Iterator");

           // Get link to Method "hasNext"
    jmethodID hasNextMethod = env->GetMethodID(jclass_of_iterator, "hasNext", "()Z");

    jmethodID nextMethod = env->GetMethodID(jclass_of_iterator, "next", "()Ljava/lang/Object;");

    while (env->CallBooleanMethod(jobject_of_iterator, hasNextMethod)) {
        jobject jEntry = env->CallObjectMethod(jobject_of_iterator, nextMethod);
        QJniObject entry = QJniObject(jEntry);
        QJniObject key = entry.callObjectMethod("getKey", "()Ljava/lang/Object;");
        QJniObject value = entry.callObjectMethod("getValue", "()Ljava/lang/Object;");
        QString k = key.toString();

        QVariant v = value.toString();

        env->DeleteLocalRef(jEntry);

        if (v.isNull()) {
            continue;
        }

        res[k] = v;
    }

    if (env->ExceptionOccurred()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }

    env->DeleteLocalRef(jclass_of_hashmap);
    env->DeleteLocalRef(jobject_of_entryset);
    env->DeleteLocalRef(jclass_of_set);
    env->DeleteLocalRef(jobject_of_iterator);
    env->DeleteLocalRef(jclass_of_iterator);

    return res;
}

bool MAUIAndroid::hasKeyboard()
{
    QJniObject context = QNativeInterface::QAndroidApplication::context().object<jobject>();

    if (context.isValid()) {
        QJniObject resources = context.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
        QJniObject config = resources.callObjectMethod("getConfiguration", "()Landroid/content/res/Configuration;");
        int value = config.getField<jint>("keyboard");
        //        QVariant v = value.toString();
        qDebug() << "KEYBOARD" << value;

        return value == 2 || value == 3; // KEYBOARD_12KEY || KEYBOARD_QWERTY

    } else
        throw InterfaceConnFailedException();
}

bool MAUIAndroid::hasMouse()
{
    return false;
}

static void accessAllFiles()
{
    if(QOperatingSystemVersion::current() < QOperatingSystemVersion(QOperatingSystemVersion::Android, 11)) {
        qDebug() << "it is less then Android 11 - ALL FILES permission isn't possible!";
        return;
    }
    qDebug() << "requesting ACCESS TO ALL FILES" << qApp->organizationDomain();

    jboolean value = QJniObject::callStaticMethod<jboolean>("android/os/Environment", "isExternalStorageManager");
    if(value == false)
    {
        qDebug() << "requesting ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION";
        QJniObject ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION = QJniObject::getStaticObjectField( "android/provider/Settings", "ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION","Ljava/lang/String;" );
        QJniObject intent("android/content/Intent", "(Ljava/lang/String;)V", ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION.object());
        QJniObject jniPath = QJniObject::fromString("package:"+qApp->organizationDomain());
        QJniObject jniUri = QJniObject::callStaticObjectMethod("android/net/Uri", "parse", "(Ljava/lang/String;)Landroid/net/Uri;", jniPath.object<jstring>());
        QJniObject jniResult = intent.callObjectMethod("setData", "(Landroid/net/Uri;)Landroid/content/Intent;", jniUri.object<jobject>() );
        QtAndroidPrivate::startActivity(intent, 0);
    } else {
        qDebug() << "SUCCESS ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION";
    }
}

bool MAUIAndroid::checkRunTimePermissions(const QStringList &permissions)
{
    for (const auto &permission : permissions)
    {
        if(permission == "android.permission.MANAGE_EXTERNAL_STORAGE")
        {
            accessAllFiles();
            continue;
        }

        auto r = QtAndroidPrivate::checkPermission(permission).result();
        if (r == QtAndroidPrivate::Denied)
        {
            r = QtAndroidPrivate::requestPermission(permission).result();
            if (r == QtAndroidPrivate::Denied)
                return false;
        }
    }
    return true;
}

void MAUIAndroid::handleActivityResult(int receiverRequestCode, int resultCode, const QJniObject &data)
{
    qDebug() << "ACTIVITY RESULTS" << receiverRequestCode;
    Q_EMIT this->hasKeyboardChanged();
    jint RESULT_OK = QJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");

    if (receiverRequestCode == 42 && resultCode == RESULT_OK) {
        QString url = data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;").toString();
        emit folderPicked(url);
    }
}


bool MAUIAndroid::darkModeEnabled()
{
    jint res = QJniObject::callStaticMethod<jint>(
        "com/kde/maui/tools/ConfigActivity",
        "systemStyle",
        "(Landroid/content/Context;)I",
        QNativeInterface::QAndroidApplication::context().object());

    return res == 1;
}

//JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/)
//{
//    JNIEnv* env;
//    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
//        return JNI_ERR;
//    }

//    jclass javaClass = env->FindClass("com/kde/maui/tools/ConfigActivity");
//    if (!javaClass)
//        return JNI_ERR;

//    if (env->RegisterNatives(javaClass, methods, sizeof(methods) / sizeof(methods[0])) < 0) {
//        return JNI_ERR;
//    }
//    return JNI_VERSION_1_6;
//}
