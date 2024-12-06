/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2019  camilo <chiguitar@unal.edu.co>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once

#include <QObject>
#include <QQmlEngine>

#include "mauikit_export.h"

#include <KAboutData>

class QQuickWindow;
class QWindow;

class Notify;
class KAboutComponent;

/**
 * @brief The MauiApp class
 * The MauiApp is a global singleton instance, can be accessed from QML as an attached property, so it can be used by importing `org.mauikit.controls`
 *
 * @warning It is needed that the first instance creation is made on the application main entry point before the QML engine creates the window surface, so the style and other parts are correctly loaded.
 * 
 * Example:
 * @code
 * import org.mauikit.controls as Maui
 *
 * Maui.ApplicationWindow
 * {
 *      title: Maui.App.about.name
 *      Maui.CSD.enabled: true
 * }
 * @endcode
 *
 * @section style Style
 * By default MauiApp will set the style to "org.mauikit.style" after it has been instanciated, which is the most optimal and feature-rich style to be used with Maui applications. However this can be overriden by a custom one, by either setting the env variable `QT_QUICK_CONTROLS_STYLE` or by code:
 * 
 * @code
 *  qputenv("QML_DISABLE_DISK_CACHE", "1"); // This is to workaround a bug causing the new style to not be picked up due to the cache of the default or previous one
    QQuickStyle::setStyle("Imagine");
 * @endcode
 */
class MAUIKIT_EXPORT MauiApp : public QObject
{
    Q_OBJECT
    // QML_SINGLETON
    QML_NAMED_ELEMENT(App)
    QML_ATTACHED(MauiApp)
    QML_UNCREATABLE("Cannot be created MauiApp")
    Q_DISABLE_COPY(MauiApp)
    
    /**
     * The information metadata about the application.
     * See the KAboutData documentation for more details.
     * @note This is the information parsed for feeding the ApplicationWindow's about dialog.
     */
    Q_PROPERTY(KAboutData about READ getAbout CONSTANT FINAL)
    
    /**
     * The URL to the image asset for the application icon.
     */
    Q_PROPERTY(QString iconName READ getIconName WRITE setIconName NOTIFY iconNameChanged)
    
    /**
     * An URL link to the application donation page.
     */
    Q_PROPERTY(QString donationPage READ getDonationPage WRITE setDonationPage NOTIFY donationPageChanged)
        
    /**
     * The formatted MauiKit string version.
     */
    Q_PROPERTY(QString mauikitVersion READ getMauikitVersion CONSTANT FINAL)
    
    /**
     * The main and first Maui.ApplicationWindow to be instanciated.
     */
    Q_PROPERTY(QObject *rootComponent READ rootComponent WRITE setRootComponent NOTIFY rootComponentChanged)
    
public:
    /**
      * @private
      */
     MauiApp(QObject *parent = nullptr);
    /**
     * @brief Retrieves information of the MauiKit framework wrapped into a KAboutComponent object.
     */
    static KAboutComponent aboutMauiKit();
    
    /**
     * @private
     */
    static MauiApp *qmlAttachedProperties(QObject *object);
    
    /**
     * @brief Retrieves the single instance of MauiApp. 
     */
    static MauiApp *instance();
    
    /**
     * @private
     */
    static QObject * qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(scriptEngine);
    
    auto instance = MauiApp::instance();
    // if(engine)
    //     instance->setRootComponent(engine->rootContext().contextObject());
    // C++ and QML instance they are the same instance
    return instance;
    }
    
    /**
     * @brief The formatted MauiKit version string
     */
    static QString getMauikitVersion();
    
    /**
     * @brief The file URL to the application icon
     */
    QString getIconName() const;
    
    /**
     * @brief Set the file URL to the application icon.
     * Usually it is a self contained URL
     */
    void setIconName(const QString &value);
    
    /**
     * @brief Donation web page link
     * @return URL link
     */
    QString getDonationPage() const;
    
    /**
     * @brief Set the donation web page link
     * @param value the URL link
     */
    void setDonationPage(const QString &value);

    /**
     * @brief Gather information about this module.
     * @return
     */
    KAboutData getAbout() const;
    
    /**
     * @brief Define the root element of the Maui Application.
     * Usually the root element is expected to be a QWindow derived element.
     * @see ApplicationWindow
     */
    Q_INVOKABLE void setRootComponent(QObject *item);
    QObject * rootComponent();    
        
    /**
     * @brief Requests to display the about dialog.
     * @note This will only work if the root component is a Maui ApplicationWindow
     */
    Q_INVOKABLE void aboutDialog();
  
    
private:
    QObject *m_rootComponent = nullptr;
    
    QString m_iconName;
    QString m_donationPage;
    
    static void setDefaultMauiStyle();    
    
Q_SIGNALS:
    void iconNameChanged();
    void donationPageChanged();
    void currentIconThemeChanged(QString currentIconTheme);
    void rootComponentChanged();
};

QML_DECLARE_TYPEINFO(MauiApp, QML_HAS_ATTACHED_PROPERTIES)

