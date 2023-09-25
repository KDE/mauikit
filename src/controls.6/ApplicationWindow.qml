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

/*!
 @brief A window that provides some basic features needed for most applications.
  
  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-window.html">This controls inherits from QQC2 Window, to checkout its inherited properties refer to the Qt Docs.</a>

 The ApplicationWinow is the best component to start creating a new MauiKit application, it's usually used as the root QML component for the application.
 By default the window is completely empty (and transparent since it doesn't have any container) - and if used with CSD (Client Side Decorations) enabled, not window controls are visible.
 
 Commonly it is paired with another container control, such as a Page, an AppViews or a SideBarView, to name a few MauiKit controls, or with other QQC2 elements, such as a StackView, SwipeView, etc..
 @see Page
 @see AppViews
 @see SideBarView
 
 @image html ApplicationWindow/empty_dark.webp
 @note This is an ApplicationWindow filled with a Page and with the CSD controls enabled.
 
 @section csd Client Side Decorations 
 @note Client-side decorations concept is refer to when the application window takes care of drawing the surface window borders, shadows, and the window control buttons - and to provides the resizing and moving functionality.
  
 The application window can make use of client side decorations - CSD - by setting the attached property Maui.App.controls.enabledCSD to true,
 or globally by making use of MauiMan configuration options - that said, even if the system is configured to use CSD, you can override this in your application.
 
 When using CSD - the ApplicationWindow will take care of drawing the window borders, the shadow and the clipping for the rounded corners.
 
 The radius of the corners is configured via MauiMan. To know more about how to configure at a user level take a look at MauiMan documentation. This property can not be overriden by the application itself.
  
 If used with a Page, you can easily enable the CSD buttons using the attached property @qmlattachedproperty Maui.Controls.showCSD, this will make the window-control buttons visible. A few other MauiKit controls support this property, such as the TabView.
@code
ApplicationWindow
{
    id: root
    
    Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
    }
}
@endcode
 
 If a custom control is used instead, and CSD is still enabled, you can place the window controls manually by using the WindowControls component.
 @see WindowControls
 
 @code
ApplicationWindow
{
    id: root
    
    QQC2.Page
    {
        anchors.fill: parent
        
        WindowControls
        {
            anchors.top: parent.top
            anchors.right: parent.right
        }        
    }
}
@endcode
 
 @section functionality Built-in Functionality
 
 @subsection aboutdialog About Dialog
 The Application window has some components already built-in, such as an about dialog, which can be invoked using the function about()
 @see about
 
   @image html ApplicationWindow/aboutdialog.png
 @note About dialog witn information provided by the application.
 
  @subsection toastarea Toast Area - Notifications

 It also includes an overlay layer for displaying inline notifications, which can be triggered and sent by using the function notify()
 @see notify
 
   @image html ApplicationWindow/toastarea.png
 @note Inline notifications in the toast area.
 
 @section notes Notes
 By default the window geometry is saved and restored.
 
 In order for the style and other functionality to work correctly the MauiApp singleton instance must have been initialize before the ApplicationWindow is created. This is usually done on the main entry point of the application.
 
 Is also important to notice that some of the application information needs to be provided beforehand as well, using the KAboutData methods, this way the built-in about dialog can pick up all the relevant information.
 
 @code 
 #include <MauiKit4/Core/mauiapp.h>
#include <KAboutData>

 int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));

    KAboutData about(QStringLiteral("mauidemo"),
                     i18n("Maui Demo"),
                     "3.0.0",
                     i18n("MauiKit Qt6 Demo."),
                     KAboutLicense::LGPL_V3); //here you can set information about the application , which will be fetched by the about dialog.

    about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/index");
    about.setBugAddress("https://invent.kde.org/maui/index-fm/-/issues");
    about.setOrganizationDomain("org.qt6.tst");
    about.setProgramLogo(app.windowIcon());
    about.addComponent("KIO");

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg"); // this not only sets the path to the icon file asset, but also takes care of initializing the MauiApp singleton instance.

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qt/qml/MauiDemo4/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}
@endcode
 
 @section styling  Styling
 The ApplicationWindow as other MauiKit controls style can be tweaked, for example the color scheme: from dark and light variant, but also true-black, high-contrast, and an adaptive style which picks colors from an image source, such as a wallpaper.
 All these can be tweaked by each application individually or follow the global system preferences set by MauiMan.
 
 @note When mixing Kirigami components with MauiKit controls, it is best to set the style type to the System option, for it to correctly pick up the same color-scheme Kirigami uses, since Kirigami uses another methods for setting the color palette. The option can be set using Maui.Style.styleType: 3
 @see Style

 @code
ApplicationWindow
{
    id: root
    Maui.Style.styleType: 1 // 0-light, 1-dark, 2-adaptive, 3-system etc
    Maui.Style.accentColor: "pink"
    
    Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
    }
}
@endcode
 
  @image html ApplicationWindow/color_styles.png
 @note All the different color styles available.
 
 You can check out our quick tutorial on creating a simple Maui application here

 <a href="QuickApp.dox">External file</a>

 The most basic use case is to use a Page inside of the ApplicationWindow as shown below.
@code
ApplicationWindow
{
    id: root
    
    Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
    }
}
@endcode

 <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ApplicationWindow.qml">You can find a more complete example at this link.</a>
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
     * @note This is a `default` property.
     * @property list<QtObject> content
     **/
    default property alias content : _content.data

    /***************************************************/
    /******************** ALIASES *********************/
    /*************************************************/

    /**
     * @brief  Determines when the application window size is wide enough.
     * This property can be changed to any arbitrary condition. This will affect how some controls are positioned and displayed - as for a true wide value, it will assume there is more space to place contents, or for a false value it will work in the opposite way.
     * Keep in mind this property is widely used in other MauiKit components to determined if items should be hidden,  collapsed, or exapanded, etc.
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
       * @brief Send an inline notification.
       * @param {String} icon = icon name to be used
       * @param {String} title = the title
       * @param {String} body = message of the notification
       * @param {Function} callback = function to be triggered if the notification dialog is accepted
       * @param {int} timeout = time in milliseconds before the notification dialog is dismissed
       * @param {String} buttonText = text in the accepted button
       **/
    function notify(icon, title, body, callback, buttonText)
    {
        _toastArea.add(icon, title, body, callback, buttonText)
    }

    /**
       * @brief Switch between maximized and normal state.
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
     * @brief Switch between full-screen mode and normal mode.
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
     * This information is taken from KAboutInfo and MauiApp singleton instance.
     */
    function about()
    {
        var about = _aboutDialogComponent.createObject(root)
        about.open()
    }
}
