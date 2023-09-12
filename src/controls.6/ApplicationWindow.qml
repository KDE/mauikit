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

 It's usually used as a root QML component for the application.
 By default the window is empty - and if used with CSD (Client Side Decorations) enabled, not window controls are visible. 
 
 Commonly it is paired with another container control, such as a Page, an AppView or a SidebarView.
 @see Page
 @see AppView
 
 The application windo can make use of client side decorations - CSD - by setting the attached property Maui.App.enabledCSD to true,
 or globally by editing the configuration file located at /.config/Maui/mauiproject.conf.
 
 @image html ApplicationWindow/empty_dark.webp
 @note This is an ApplicationWindow filled with a Page and with the CSD controls enabled.
 
 If used with a Page, you can enable the CSD buttons with the property showCSDControls, this will make the window control buttons visible.
 If a custom control is used instead, and CSD is still enabled, you can place the window controls manually by using the WindowControls component.
 @see WindowControls
 
 The Application window has some components already built in like an AboutDialog, which can be invoked using the functions about()
 @see about
 
 It also includes an overlay space for displaying inline notifications, which can be triggered by sending notifications using the function notify()
 @see notify
 
 By default the window geometry is saved and restored.
 
 The ApplicationWindow and MauiKit controls style can be tweaked, from dark and light variant, but also true black, high contrast, and an adaptive style which picks colors from an image source, such as the wallpaper.
 All these can be tweaked by each application individually or follow the global system preferences.
 @see Style
  
  You can check out our quick tutorial on creating a simple Maui application here 

 <a href="QuickApp.dox">External file</a>

  The most basic use case is to use a Page inside of the ApplicationWIndow as shown below.
@code
ApplicationWindow
{
    id: root    
    
    Page
    {
        anchors.fill: parent
        showCSDControls: true
    }    
}
@endcode

A more complete example file can be found in the examples directory
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
     * This is used as the default container, and it helps to correctly mask the contents when using CSD with rounder border corners.
     * @note This is a `default` property
     * @property list<QtObject> content
     **/
    default property alias content : _content.data

    /***************************************************/
    /******************** ALIASES *********************/
    /*************************************************/

    /**
     * @brief  If the application window size is wide enought.
     * This property can be changed to any random condition. This will affect how some controls are layout and displayed - as for a true wide value, it will assume there is more space to place contents, or for a false value it will assume the opposite.
     * Keep in mind this property is widely used in other MauiKit components to determined if items should be hidden or collapsed, etc.
     **/
    property bool isWide : root.width >= Maui.Style.units.gridUnit * 30

    /***************************************************/
    /**************** READONLY PROPS ******************/
    /*************************************************/
    /**
     * @brief Convinient property to check if the application window is maximized.
     **/
    readonly property bool isMaximized: root.visibility === Window.Maximized
    
    /**
     * @brief Convinient property to check if the application window is in full screen mode.
     **/
    readonly property bool isFullScreen: root.visibility === Window.FullScreen
    
    /**
     * @brief Convinient property to check if the application window is in portrait mode, other wise it is in landscape mode.
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
        z:  Overlay.overlay.z
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

        sourceComponent:Item
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
                onActiveChanged: if (active)
                                 {
                                     root.startSystemResize(Qt.LeftEdge | Qt.BottomEdge);
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
       * @brief Switch between maximized to a normal size.
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
     * @brief Switch between full screen mode and normal mode.
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
     * @brief Invokes the AboutDialog with information about the application.
     */
    function about()
    {
        var about = _aboutDialogComponent.createObject(root)
        about.open()
    }
}
