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
#include <QException>
#include <QColor>
#include <QDebug>
#include <QMimeData>
#include <QMimeDatabase>
#include <QDomDocument>
#include <QFile>
#include "utils.h"

class InterfaceConnFailedException : public QException
{
public:
    void raise() const { throw *this; }
    InterfaceConnFailedException *clone() const { return new InterfaceConnFailedException(*this); }
};

MAUIAndroid::MAUIAndroid(QObject *parent) : QObject(parent)
{

}

MAUIAndroid::~MAUIAndroid()
{
    
}

QString MAUIAndroid::getAccounts()
{
    QAndroidJniObject str = QAndroidJniObject::callStaticObjectMethod("com/kde/maui/tools/Union", "getAccounts", "(Landroid/content/Context;)Ljava/lang/String;", QtAndroid::androidActivity().object<jobject>());

    return str.toString();
}


QVariantList MAUIAndroid::getContacts()
{
    QVariantList res;
    QAndroidJniEnvironment env;
    QAndroidJniObject contactsArrayJniObject = QAndroidJniObject::callStaticObjectMethod("com/kde/maui/tools/Union", "getContacts", "(Landroid/content/Context;)[[Ljava/lang/String;",  QtAndroid::androidActivity().object<jobject>());
    jobjectArray contactsJniArray = contactsArrayJniObject.object<jobjectArray>();
    int len = env->GetArrayLength(contactsJniArray);

    for (int i = 0; i < len; i++)
    {
        jobjectArray stringArr = static_cast<jobjectArray>(env->GetObjectArrayElement(contactsJniArray, i));

        jstring id_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 0));
        jstring n_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 1));
        jstring tel_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 2));
        jstring email_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 3));
        jstring org_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 4));
        jstring title_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 5));
        jstring fav_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 6));
        jstring photo_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 7));
        jstring accountName_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 8));
        jstring accountType_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 9));
        jstring count_js = static_cast<jstring>(env->GetObjectArrayElement(stringArr, 10));

        const char *id = env->GetStringUTFChars(id_js, 0);
        const char *n = env->GetStringUTFChars(n_js, 0);
        const char *tel = env->GetStringUTFChars(tel_js, 0);
        const char *email = env->GetStringUTFChars(email_js, 0);
        const char *org = env->GetStringUTFChars(org_js, 0);
        const char *title = env->GetStringUTFChars(title_js, 0);
        const char *fav = env->GetStringUTFChars(fav_js, 0);
        const char *photo = env->GetStringUTFChars(photo_js, 0);
        const char *accountName = env->GetStringUTFChars(accountName_js, 0);
        const char *accountType = env->GetStringUTFChars(accountType_js, 0);
        const char *count = env->GetStringUTFChars(count_js, 0);

        if(QString(n).isEmpty() && QString(tel).isEmpty() && QString(email).isEmpty())
            continue;

        res << QVariantMap {
        {"id", QString(id)},
        {"fav", QString(fav)},
        {"n", QString(n)},
        {"tel", QString(tel)},
        {"email", QString(email)},
        {"org", QString(org)},
        {"photo", QString(photo)},
        {"account", QString(accountName)},
        {"type", QString(accountType)},
        {"title", QString(title)},
        {"count", QString(count)}
    };
    }

    return res;
}

void MAUIAndroid::addContact(const QString &name,
                             const QString &tel,
                             const QString &tel2,
                             const QString &tel3,
                             const QString &email,
                             const QString &title,
                             const QString &org,
                             const QString &photo,
                             const QString &account,
                             const QString &accountType)
{
    qDebug()<< "Adding new contact to android";
    QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/Union",
                                              "addContact",
                                              "(Landroid/content/Context;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;)V",
                                              QtAndroid::androidActivity().object<jobject>(),
                                              QAndroidJniObject::fromString(name).object<jstring>(),
                                              QAndroidJniObject::fromString(tel).object<jstring>(),
                                              QAndroidJniObject::fromString(tel2).object<jstring>(),
                                              QAndroidJniObject::fromString(tel3).object<jstring>(),
                                              QAndroidJniObject::fromString(email).object<jstring>(),
                                              QAndroidJniObject::fromString(title).object<jstring>(),
                                              QAndroidJniObject::fromString(org).object<jstring>(),
                                              QAndroidJniObject::fromString(photo).object<jstring>(),
                                              QAndroidJniObject::fromString(account).object<jstring>(),
                                              QAndroidJniObject::fromString(accountType).object<jstring>() );
}

void MAUIAndroid::updateContact(const QString &id, const QString &field, const QString &value)
{
    QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/Union",
                                              "updateContact",
                                              "(Landroid/content/Context;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;"
                                              "Ljava/lang/String;)V",
                                              QtAndroid::androidActivity().object<jobject>(),
                                              QAndroidJniObject::fromString(id).object<jstring>(),
                                              QAndroidJniObject::fromString(field).object<jstring>(),
                                              QAndroidJniObject::fromString(value).object<jstring>() );
}

void MAUIAndroid::call(const QString &tel)
{

    QAndroidJniEnvironment _env;
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");   //activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if ( activity.isValid() )
    {
        qDebug()<< "trying to call from senitents" << tel;

        QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                                  "call",
                                                  "(Landroid/app/Activity;Ljava/lang/String;)V",
                                                  activity.object<jobject>(),
                                                  QAndroidJniObject::fromString(tel).object<jstring>());


        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    }else
        throw InterfaceConnFailedException();

}

void MAUIAndroid::statusbarColor(const QString &bg, const bool &light)
{
    QtAndroid::runOnAndroidThread([=]()
    {
        QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
        window.callMethod<void>("addFlags", "(I)V", 0x80000000);
        window.callMethod<void>("clearFlags", "(I)V", 0x04000000);
        window.callMethod<void>("setStatusBarColor", "(I)V", QColor(bg).rgba());
        
        QAndroidJniObject decorView = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        decorView.callMethod<void>("setSystemUiVisibility", "(I)V", light ? 0x00002000 :  0x00000001);
    });
}

void MAUIAndroid::shareDialog(const QString &url)
{
    qDebug()<< "trying to share dialog";
    QAndroidJniEnvironment _env;
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");   //activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if (activity.isValid())
    {
        QMimeDatabase mimedb;
        QString mimeType = mimedb.mimeTypeForFile(url).name();
        
        QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                                  "share",
                                                  "(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;)V",
                                                  activity.object<jobject>(),
                                                  QAndroidJniObject::fromString(url).object<jstring>(),
                                                  QAndroidJniObject::fromString(mimeType).object<jstring>());
        
        
        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    }else
        throw InterfaceConnFailedException();
}

void MAUIAndroid::shareText(const QString &text)
{
    qDebug()<< "trying to share text";
    QAndroidJniEnvironment _env;
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");   //activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if ( activity.isValid() )
    {
        QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                                  "sendText",
                                                  "(Landroid/app/Activity;Ljava/lang/String;)V",
                                                  activity.object<jobject>(),
                                                  QAndroidJniObject::fromString(text).object<jstring>());
        
        
        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    }else
        throw InterfaceConnFailedException();
}

void MAUIAndroid::shareLink(const QString &link)
{
    qDebug()<< "trying to share link";
    QAndroidJniEnvironment _env;
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");   //activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if ( activity.isValid() )
    {
        QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                                  "sendUrl",
                                                  "(Landroid/app/Activity;Ljava/lang/String;)V",
                                                  activity.object<jobject>(),
                                                  QAndroidJniObject::fromString(link).object<jstring>());
        
        
        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    }else
        throw InterfaceConnFailedException();
}

void MAUIAndroid::shareContact(const QString &id)
{
    QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/Union",
                                              "shareContact",
                                              "(Landroid/content/Context;"
                                              "Ljava/lang/String;)V",
                                              QtAndroid::androidActivity().object<jobject>(),
                                              QAndroidJniObject::fromString(id).object<jstring>());

}

void MAUIAndroid::sendSMS(const QString &tel,const QString &subject, const QString &message )
{
    qDebug()<< "trying to send sms text";
    QAndroidJniEnvironment _env;
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");   //activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if ( activity.isValid() )
    {
        QAndroidJniObject::callStaticMethod<void>("com/kde/maui/tools/SendIntent",
                                                  "sendSMS",
                                                  "(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                                                  activity.object<jobject>(),
                                                  QAndroidJniObject::fromString(tel).object<jstring>(),
                                                  QAndroidJniObject::fromString(subject).object<jstring>(),
                                                  QAndroidJniObject::fromString(message).object<jstring>());


        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    }else
        throw InterfaceConnFailedException();
}

void MAUIAndroid::openWithApp(const QString &url)
{
    
}

QString MAUIAndroid::homePath()
{
    QAndroidJniObject mediaDir = QAndroidJniObject::callStaticObjectMethod("android/os/Environment", "getExternalStorageDirectory", "()Ljava/io/File;");
    QAndroidJniObject mediaPath = mediaDir.callObjectMethod( "getAbsolutePath", "()Ljava/lang/String;" );
    
    return mediaPath.toString();
}

QString MAUIAndroid::sdDir()
{
    //    QAndroidJniObject mediaDir = QAndroidJniObject::callStaticObjectMethod("android/os/Environment", "getExternalStorageDirectory", "()Ljava/io/File;");
    //    QAndroidJniObject mediaPath = mediaDir.callObjectMethod( "getAbsolutePath", "()Ljava/lang/String;" );
    //    QString dataAbsPath = mediaPath.toString()+"/Download/";
    //    QAndroidJniEnvironment env;
    //    if (env->ExceptionCheck()) {
    //            // Handle exception here.
    //            env->ExceptionClear();
    //    }
    
    //    qbDebug::Instance()->msg()<<"TESTED SDPATH"<<QProcessEnvironment::systemEnvironment().value("EXTERNAL_SDCARD_STORAGE",dataAbsPath);
    if(UTIL::fileExists("/mnt/extSdCard"))
        return "/mnt/extSdCard";
    else if(UTIL::fileExists("/mnt/ext_sdcard"))
        return "/mnt/ext_sdcard";
    else
        return "/mnt/";
}

void MAUIAndroid::setAppIcons(const QString &lowDPI, const QString &mediumDPI, const QString &highDPI)
{
    
    
}

void MAUIAndroid::setAppInfo(const QString &appName, const QString &version, const QString &uri)
{
    
    QDomDocument doc("mydocument");
    QFile file(":/assets/AndroidManifest.xml");
    
    if (!file.open(QIODevice::ReadOnly))
    {
        qDebug("Cannot open the file");
        return;
    }
    
    // Parse file
    if (!doc.setContent(&file)) {
        qDebug("Cannot parse the content");
        file.close();
        return;
    }
    file.close();
    
    // Modify content
    QDomNodeList manifest = doc.elementsByTagName("manifest");
    if (manifest.size() < 1)
    {
        qDebug("Cannot find manifest");
        return;
    }
    
    //Manifest//
    QDomElement root = manifest.at(0).toElement();
    root.setAttribute("package", uri);
    root.setAttribute("android:versionName", version);
    
    //Application//
    auto applicationNode = root.toElement().elementsByTagName("application");
    if (applicationNode.size() < 1)
    {
        qDebug("Cannot find application node in manifest");
        return;
    }
    
    auto application = applicationNode.at(0).toElement();
    application.setAttribute("android:label", appName);
    
    // Activity //
    auto activityNode = application.toElement().elementsByTagName("activity");
    if (activityNode.size() < 1)
    {
        qDebug("Cannot find activity node in manifest");
        return;
    }
    
    auto activity = activityNode.at(0).toElement();
    activity.setAttribute("android:label", appName);
    
    // Service //
    auto serviceNode = application.toElement().elementsByTagName("service");
    if (serviceNode.size() < 1)
    {
        qDebug("Cannot find service node in manifest");
        return;
    }
    
    auto service = activityNode.at(0).toElement();
    auto serviceMetadataNode = service.elementsByTagName("meta-data");
    if (serviceMetadataNode.size() < 1)
    {
        qDebug("Cannot find service metadata node in manifest");
        return;
    }
    
    auto serviceMetadata = serviceMetadataNode.at(1).toElement();
    serviceMetadata.setAttribute("android:value", appName);
    
    if(!file.open(QIODevice::Truncate | QIODevice::WriteOnly))
    {
        qDebug("Basically, now we lost content of a file");
        return;
    }
    
    QByteArray xml = doc.toByteArray();
    file.write(xml);
    file.close();
}


void MAUIAndroid::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
{
    qDebug()<< "ACTIVITY RESULTS";
    jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");

    if (receiverRequestCode == 42 && resultCode == RESULT_OK)
    {
        QString url = data.callObjectMethod("getData", "()Landroid/net/Uri;").callObjectMethod("getPath", "()Ljava/lang/String;").toString();
        emit folderPicked(url);
    }
}

void MAUIAndroid::fileChooser()
{
    QAndroidJniEnvironment _env;
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");   //activity is valid
    if (_env->ExceptionCheck()) {
        _env->ExceptionClear();
        throw InterfaceConnFailedException();
    }
    if ( activity.isValid() )
    {
        QAndroidJniObject::callStaticMethod<void>("com/example/android/tools/SendIntent",
                                                  "fileChooser",
                                                  "(Landroid/app/Activity;)V",
                                                  activity.object<jobject>());
        if (_env->ExceptionCheck()) {
            _env->ExceptionClear();
            throw InterfaceConnFailedException();
        }
    }else
        throw InterfaceConnFailedException();
}

QStringList MAUIAndroid::defaultPaths()
{
    QStringList paths;
    
    paths.append(PATHS::HomePath);
    paths.append(PATHS::DocumentsPath);
    paths.append(PATHS::MusicPath);
    paths.append(PATHS::VideosPath);
    paths.append(PATHS::PicturesPath);
    paths.append(PATHS::DownloadsPath);
    
    return paths;
}


