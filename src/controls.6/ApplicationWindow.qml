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

import QtQuick 
import QtCore

import QtQuick.Controls

import org.mauikit.controls as Maui

import "private" as Private

/**
 * @inherit org::mauikit::controls::Private::BaseWindow
 * @brief A window that provides some basic features needed for most applications.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-window.html">This controls inherits from QQC2 Window, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * The ApplicationWindow is the best component to start creating a new MauiKit application. It's usually used as the control QML component for the application.
 * It is different from the QQC2 alternative, as this one does not include a header or footer section, and does not have either a menu-bar.
 * For a header and footer section use a MauiKit Page, and for the menu-bar alternative, use a MauiKit ToolButtonMenu.
 *
 * @warning By default the window is completely empty (and transparent since it doesn't have any container's background) - and if used with CSD (Client Side Decorations) enabled, not window controls are visible. See the example below on how to fill the application window.
 *
 * Commonly, this is paired with another child container control, such as a Page, an AppViews or a SideBarView, to name a few MauiKit controls; or with any other QQC2 element, such as a StackView, SwipeView, etc..
 * @see Page
 * @see AppViews
 * @see SideBarView
 * @see TabView
 * @see PageLayout
 *
 * @code
 * ApplicationWindow
 * {
 *    id: control
 *
 *    Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *    }
 * }
 * @endcode
 *
 * @image html ApplicationWindow/empty_dark.png "ApplicationWindow filled with a Page and the CSD controls enabled"
 *
 * @section csd Client Side Decorations
 *
 * @note Client-side decorations refers to an application window that takes care of drawing its own window borders, shadows, and the window control buttons - and also provides the resizing and moving/dragging functionality.
 *
 * The application window can make use of client side decorations (CSD) by setting the attached property `Maui.CSD.enabled: true` in the control element just once,
 * or globally by making use of MauiMan configuration options - that said, even if the system is configured to use CSD globally, you can override this property in your application, to force to use CSD  (or not).
 * @see MauiMan
 *
 * @note The alternative is to use the server side decorations (SSD).
 *
 * When using CSD, the ApplicationWindow will take care of drawing the window borders, the shadow and masking its content to support the border rounded corners.
 *
 * The radius of the corners is configured via MauiMan. To know more about how to configure it from a user level take a look at MauiMan documentation. This property can not be overridden by the application itself.
 *
 * If used with a Page, you can easily enable the CSD window buttons using the attached property `Maui.Controls.showCSD`, this will make the window-control-buttons visible. A few other MauiKit controls support this property, such as the TabView, ToolBar, AppViews, AltBrowser and TabView, and any other control that inherits from Page.
 * @see Controls
 *
 * If a custom control is to be used instead, and CSD is still enabled, you can place the window control buttons manually, by using the WindowControls component.
 * @see WindowControlsLinux
 *
 * @code
 * ApplicationWindow
 * {
 *    id: control
 *
 *    QQC2.Page
 *    {
 *        anchors.fill: parent
 *
 *        WindowControls
 *        {
 *            anchors.top: parent.top
 *            anchors.right: parent.right
 *        }
 *    }
 * }
 * @endcode
 *
 * @section functionality Built-in Functionality
 *
 * @subsection aboutdialog About Dialog
 * The Application window has some components already built-in, such as an about dialog, which can be invoked using the function `about()`.
 * @see about
 *
 * The information presented in the dialog is taken from the data set with KAboutData at the application entry point. There is an example on how to set the information in the code snippet below.
 *
 * Some extra information can be added via the MauiApp singleton instance, such as more links.
 *
 * @image html ApplicationWindow/aboutdialog.png "About dialog with information provided by the app"
 *
 * @subsection toastarea Toast Area - Notifications
 * The ApplicationWindow also includes an overlay layer for displaying inline notifications, which can be dispatched by using the function `notify()`. The notifications sent can be interactive.
 * @see notify
 *
 * @note If you want to use the system notifications instead, take a look at the Notify object class, and the docs on how to configure the needed steps to set it up.
 * @see Notify
 *
 * @image html ApplicationWindow/toastarea.png "Inline notifications in the toast area"
 *
 * @section notes Notes
 * By default the window geometry is saved and restored automatically.
 *
 * In order for the style and other functionality to work correctly the `MauiApp` singleton instance must have been initialize before the ApplicationWindow is created. This is usually done on the main entry point of the application.
 * @see MauiApp
 *
 * It is important to notice that some of the application information needs to be provided beforehand as well, using the `KAboutData` methods, this way the built-in about dialog can pick up all the relevant information.
 * @see KAboutData
 *
 * @code
 * #include <MauiKit4/Core/mauiapp.h>
 * #include <KAboutData>
 *
 * int main(int argc, char *argv[])
 * {
 *    QGuiApplication app(argc, argv);
 *
 *    app.setOrganizationName(QStringLiteral("Maui"));
 *    app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));
 *
 *    KAboutData about(QStringLiteral("mauidemo"),
 *                        i18n("Maui Demo"),
 *                        "3.0.0",
 *                        i18n("MauiKit Qt6 Demo."),
 *                        KAboutLicense::LGPL_V3); //here you can set information about the application, which will be fetched by the about dialog.
 *
 *    about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
 *    about.setHomepage("https://mauikit.org");
 *    about.setProductName("maui/index");
 *    about.setBugAddress("https://invent.kde.org/maui/index-fm/-/issues");
 *    about.setOrganizationDomain("org.qt6.tst");
 *    about.setProgramLogo(app.windowIcon());
 *    about.addComponent("KIO");
 *
 *    KAboutData::setApplicationData(about);
 *    MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg"); // this not only sets the path to the icon file asset, but also takes care of initializing the MauiApp singleton instance.
 *
 *    QQmlApplicationEngine engine;
 *    const QUrl url(u"qrc:/qt/qml/MauiDemo4/main.qml"_qs);
 *    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
 *                        &app, [url](QObject *obj, const QUrl &objUrl) {
 *        if (!obj && url == objUrl)
 *            QCoreApplication::exit(-1);
 *    }, Qt::QueuedConnection);
 *
 *    engine.load(url);
 *
 *    return app.exec();
 * }
 * @endcode
 *
 * @section styling Styling
 * The ApplicationWindow style - as other MauiKit controls - can be tweaked, for example its color scheme: from dark to light variant, but also true-black, high-contrast, and an adaptive style which picks colors from an image source, such as a wallpaper.
 * The available options are:
 * - Style.Light
 * - Style.Dark
 * - Style.Adaptive
 * - Style.Auto
 * - Style.TrueBlack
 * - Style.Inverted
 * @see Style::StyleType
 *
 * All these can be individually changed by the application or set to `undefined` to rest it back to follow the global system preference from MauiMan.
 *
 * The accent color can also be changed easily to distinguish the app own branding, by using the `Style.accentColor` property once.
 * @see Style::accentColor
 *
 * @warning When mixing Kirigami components with MauiKit controls, it is best to set the style type to the `Maui.Style.Auto` option  (which value is 3), for it to correctly pick up the same color-scheme Kirigami uses - since Kirigami uses another methods for setting the color palette. The option can be set using `Maui.Style.styleType: Maui.Style.Auto`. With this set Maui will pickup the colors from the Plasma color scheme.
 * @see Style
 *
 * @code
 * ApplicationWindow
 * {
 *    id: control
 *    Maui.Style.styleType: 1 // 0-light, 1-dark, 2-adaptive, 3-auto etc
 *    Maui.Style.accentColor: "pink"
 *
 *    Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *    }
 * }
 * @endcode
 *
 * @image html ApplicationWindow/color_styles.png "All the different color styles available"
 *
 * You can check out our quick tutorial on creating a simple Maui application here:
 *
 * <a href="QuickApp.dox">External file</a>
 *
 * @section example Example
 *
 * The most basic use case is to use a Page inside of the ApplicationWindow as shown below.
 * @code
 * ApplicationWindow
 * {
 *    id: control
 *
 *    Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ApplicationWindow.qml">You can find a more complete example at this link.</a>
 */

Private.BaseWindow
{
    id: control

    isDialog: false

    Settings
    {
        property alias x: control.x
        property alias y: control.y
        property alias width: control.width
        property alias height: control.height
    }

    Component
    {
        id: _aboutDialogComponent

        Private.AboutDialog
        {
            onClosed: destroy()
        }
    }

    Connections
    {
        target: Maui.Platform
        ignoreUnknownSignals: true
        function onShareFilesRequest(urls)
        {
            var component =  Qt.createComponent("private/ShareDialog.qml", control)
            if (component.status == Component.Ready)
            {
                var dialog = component.createObject(control, {'urls': urls})
                dialog.open()
            }else if (component.status == Component.Error) {
                // Error Handling
                console.log("Error loading component:", component.errorString());
            }
        }
    }

    Connections
    {
        target: Maui.Style
        ignoreUnknownSignals: true
        function onStyleTypeChanged()
        {
            console.log("THE COLOR STYLE CHANGED FROM ANDROID")
            if(Maui.Handy.isAndroid)
            {
                setAndroidStatusBarColor()
            }
        }
    }

    Component.onCompleted:
    {
        if(!Maui.App.rootComponent)
            Maui.App.rootComponent = control

        if(Maui.Handy.isAndroid)
        {
            setAndroidStatusBarColor()
        }
    }

    /**
         * @brief Invokes the about dialog with information of the application.
         * This information is taken from `KAboutData` and `MauiApp` singleton instance.
         * @note This method can be invoked for the main control ApplicationWindow using the `Maui.App.aboutDialog()` attached property method.
         */
    function about()
    {
        var about = _aboutDialogComponent.createObject(control)
        about.open()
    }

    function setAndroidStatusBarColor()
    {
        if(Maui.Handy.isAndroid)
        {
            const dark = Maui.Style.styleType === Maui.Style.Dark
            console.log("SET THE ANDROID STSTUS BAR COLOR", dark)

            Maui.Android.statusbarColor(Maui.Theme.backgroundColor, !dark)
            Maui.Android.navBarColor( Maui.Theme.backgroundColor, !dark)
        }
    }
}
