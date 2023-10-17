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

import QtQuick.Window 
import QtQuick.Controls
import QtQuick.Layouts

import Qt5Compat.GraphicalEffects

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/**
 * @inherit QtQuick.Window
 * @brief A window that provides some basic features needed for most applications.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-window.html">This controls inherits from QQC2 Window, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * The ApplicationWindow is the best component to start creating a new MauiKit application. It's usually used as the root QML component for the application.
 * It is different from the QQC2 alternative, as this one does not include a header or footer section, and does not have either a menu-bar.
 * For a header and footer section use a MauiKit Page, and for the menu-bar alternative, use a MauiKit ToolButtonMenu.
 * 
 * @warning By default the window is completely empty (and transparent since it doesn't have any container's background) - and if used with CSD (Client Side Decorations) enabled, not window controls are visible. See the example below to set the ApplicationWindow to a basic functional state.
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
 *    id: root
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
 * The application window can make use of client side decorations (CSD) by setting the attached property `Maui.App.controls.enabledCSD: true` in the root element just once,
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
 *    id: root
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
 *    id: root
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
 *    id: root
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

Window
{
    id: root
    
    visible: true
    
    minimumHeight: Maui.Handy.isMobile ? 0 : Math.min(300, Screen.desktopAvailableHeight)
    minimumWidth: Maui.Handy.isMobile ? 0 : Math.min(200, Screen.desktopAvailableWidth)
    
    color: "transparent"
    flags: Maui.App.controls.enableCSD ? (Qt.FramelessWindowHint | Qt.Window ): (Qt.Window & ~Qt.FramelessWindowHint)
    
    Settings
    {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }
    
    // Window shadows for CSD
    Loader
    {
        active: Maui.App.controls.enableCSD && !Maui.Handy.isMobile && Maui.Handy.isLinux
        asynchronous: true
        sourceComponent: Maui.WindowShadow
        {
            view: root
            radius: Maui.Style.radiusV
            strength: 7.8
        }
    }
    
    /***************************************************/
    /********************* COLORS *********************/
    /*************************************************/
    Maui.Theme.colorSet: Maui.Theme.View
    
    /**
     * @brief Items to be placed inside the ApplicationWindow.
     * This is used as the default container, and it helps to correctly mask the contents when using CSD with rounded border corners.
     * @property list<QtObject> content
     **/
    default property alias content : _content.data
        
        /***************************************************/
        /******************** ALIASES *********************/
        /*************************************************/
        
        /**
         * @brief  Determines when the application window size is wide enough.
         * This property can be changed to any arbitrary condition. This will affect how some controls are positioned and displayed - as for a true wide value, it will assume there is more space to place contents, or for a `false` value it will work in the opposite way.
         * Keep in mind this property is widely used in other MauiKit components to determined if items should be hidden,  collapsed, or expanded, etc.
         **/
        property bool isWide : root.width >= Maui.Style.units.gridUnit * 30
        
        /***************************************************/
        /**************** READONLY PROPS ******************/
        /*************************************************/
        
        /**
         * @brief Convenient property to check if the application window surface is maximized.
         **/
        readonly property bool isMaximized: root.visibility === Window.Maximized
        
        /**
         * @brief Convenient property to check if the application window is in a full screen mode.
         **/
        readonly property bool isFullScreen: root.visibility === Window.FullScreen
        
        /**
         * @brief Convenient property to check if the application window is in portrait mode, otherwise it means it is in landscape mode.
         **/
        readonly property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation || Screen.primaryOrientation === Qt.InvertedPortraitOrientation
        
        Item
        {
            id: _container
            anchors.fill: parent
            readonly property bool showBorders: Maui.App.controls.enableCSD && root.visibility !== Window.FullScreen && !Maui.Handy.isMobile && root.visibility !== Window.Maximized
            
            Item
            {
                id: _content
                anchors.fill: parent
            }
            
            Private.ToastArea
            {
                id: _toastArea
                anchors.fill: parent
            }
            
            layer.enabled: _container.showBorders
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: _content.width
                    height: _content.height
                    radius: Maui.Style.radiusV
                }
            }
        }
        
        Loader
        {
            active: _container.showBorders
            visible: active
            z: Overlay.overlay.z
            anchors.fill: parent
            asynchronous: true
            
            sourceComponent: Rectangle
            {
                radius: Maui.Style.radiusV
                color: "transparent"
                border.color: Qt.darker(Maui.Theme.backgroundColor, 2.3)
                opacity: 0.5
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }
                
                Rectangle
                {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    radius: parent.radius
                    border.color: Qt.lighter(Maui.Theme.backgroundColor, 2)
                    opacity: 0.7
                    
                    Behavior on color
                    {
                        Maui.ColorTransition{}
                    }
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            active: Maui.App.controls.enableCSD
            visible: active
            height: 16
            width: height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            
            sourceComponent: Item
            {
                MouseArea
                {
                    anchors.fill: parent
                    cursorShape: Qt.SizeBDiagCursor
                    acceptedButtons: Qt.NoButton // don't handle actual events
                }
                
                DragHandler
                {
                    grabPermissions: TapHandler.TakeOverForbidden
                    target: null
                    onActiveChanged: (active) => 
                    {
                        if (active)
                        {
                            root.startSystemResize(Qt.LeftEdge | Qt.BottomEdge);
                        }
                    }
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            active: Maui.App.controls.enableCSD
            visible: active
            height: 16
            width: height
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            
            sourceComponent: Item
            {
                MouseArea
                {
                    anchors.fill: parent
                    cursorShape: Qt.SizeFDiagCursor
                    acceptedButtons: Qt.NoButton // don't handle actual events
                }
                
                DragHandler
                {
                    grabPermissions: TapHandler.TakeOverForbidden
                    target: null
                    onActiveChanged: if (active)
                    {
                        root.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                    }
                }
            }
        }
        
        Overlay.overlay.modal: Item
        {
            Rectangle
            {
                color: Maui.Theme.backgroundColor
                anchors.fill: parent
                opacity : 0.8
                radius:  Maui.Style.radiusV
            }
        }
        
        Overlay.overlay.modeless: Rectangle
        {
            radius:  Maui.Style.radiusV
            
            color: Qt.rgba( root.Maui.Theme.backgroundColor.r,  root.Maui.Theme.backgroundColor.g,  root.Maui.Theme.backgroundColor.b, 0.7)
            Behavior on opacity { NumberAnimation { duration: 150 } }
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }
        
        Loader
        {
            id: dialogLoader
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
                dialogLoader.source = "private/ShareDialog.qml"
                dialogLoader.item.urls = urls
                dialogLoader.item.open()
            }
        }
        
        /**
         * @brief Send an inline notification
         * @param icon icon name to be used
         * @param title the notification title
         * @param body the message body of the notification
         * @param callback a callback function to be triggered when the action button is pressed, this is represented as a button
         * @param buttonText the text associated to the previous callback function, to be used in the button
         **/
        function notify(icon, title, body, callback, buttonText)
        {
            _toastArea.add(icon, title, body, callback, buttonText)
        }
        
        /**
         * @brief Switch between maximized and normal state
         **/
        function toggleMaximized()
        {
            if (root.isMaximized)
            {
                root.showNormal();
            } else
            {
                root.showMaximized();
            }
        }
        
        /**
         * @brief Switch between full-screen mode and normal mode
         **/
        function toggleFullscreen()
        {
            if (root.isFullScreen)
            {
                root.showNormal();
            } else
            {
                root.showFullScreen()();
            }
        }
        
        /**
         * @brief Invokes the about dialog with information of the application.
         * This information is taken from `KAboutData` and `MauiApp` singleton instance.
         */
        function about()
        {
            var about = _aboutDialogComponent.createObject(root)
            about.open()
        }
}
