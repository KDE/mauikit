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

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/*!
\since org.mauikit.controls 1.0
\inqmlmodule org.mauikit.controls
\brief A window that provides some basic features needed for all apps

It's usually used as a root QML component for the application.
By default it makes usage of the Maui Page control, so it packs a header and footer bar.
The header can be moved to the bottom for better reachability in hand held devices.
The Application window has some components already built in like an AboutDialog, a main application menu,
and an optional property to add a global sidebar.

The application can have client side decorations CSD by setting the attached property Maui.App.enabledCSD  to true,
or globally by editing the configuration file located at /.config/Maui/mauiproject.conf.

For more details you can refer to the Maui Page documentation for fine tweaking the application window main content.
\code
ApplicationWindow {
    id: root

    AppViews {
        anchors.fill: parent
    }
}
\endcode
*/
Window
{
    id: root

    visible: true

    width: Screen.desktopAvailableWidth * (Maui.Handy.isMobile ? 1 : 0.4)
    height: Screen.desktopAvailableHeight * (Maui.Handy.isMobile ? 1 : 0.4)

    color: "transparent"
    flags: Maui.App.controls.enableCSD ? Qt.FramelessWindowHint : Qt.Window
    
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
            radius: _pageBackground.radius
        }
    }       

    /***************************************************/
    /********************* COLORS *********************/
    /*************************************************/
    Maui.Theme.colorSet: Maui.Theme.View

    /*!
      \qmlproperty Item ApplicationWindow::content

      Items to be placed inside the ApplicationWindow Page.
    */
    default property alias content : _content.data

    /*!
      A global sidebar that is reponsive and can be collapsable.
    */
    property Maui.AbstractSideBar sideBar

    /***************************************************/
    /******************** ALIASES *********************/
    /*************************************************/

    /*!
      \qmlproperty Page ApplicationWindow::page

      The page used as the main content of the application window.
      Via this property more fine tuning can be done to the behavior and look of the application window.
    */
    readonly property alias page : _page

    /*!
      \qmlproperty Flickable ApplicationWindow::flickable
      The apps page flickable. This is exposed to setting any flickable so the main header can
      react to floating header or footer properties, or to different header or footer bars positioning.
    */
    property alias flickable : _page.flickable

    /*!
      \qmlproperty ToolBar ApplicationWindow::headBar
      The main header bar. This is controlled by a ToolBar and a list of amny number of components can be added to it.
      For better understaning of its properties check the ToolBar documentation.
    */
    property alias headBar : _page.headBar

    /*!
      \qmlproperty ToolBar ApplicationWindow::footBar

      The main footer bar. This is controlled by a ToolBar and a list of amny number of components can be added to it.
      For better understaning of its properties check the ToolBar documentation.
    */
    property alias footBar : _page.footBar

    /*!
      \qmlproperty Item ApplicationWindow::footer

      * The Item containing the page footBar.
      * This property allows to change the default ToolBar footer to any other item.
    */
    property alias footer : _page.footer

    /*!
      \qmlproperty Item ApplicationWindow::header

      The Item containing the page headBar.
      This property allows to change the default ToolBar header to any other item.
    */
    property alias header :_page.header

    /*!
      \qmlproperty bool ApplicationWindow::floatingHeader
      If the main header should float above the page contents.
    */
    property alias floatingHeader: _page.floatingHeader

    /*!
      \qmlproperty bool ApplicationWindow::floatingFooter

      If the main footer should float above the page contents.
    */
    property alias floatingFooter: _page.floatingFooter

    /*!
      \qmlproperty bool ApplicationWindow::autoHideHeader

      If the main header should auto hide after the autoHideHeaderDelay timeouts of the content loses focus.
    */
    property alias autoHideHeader: _page.autoHideHeader

    /*!
      \qmlproperty bool ApplicationWindow::autoHideFooter

      If the main footer should auto hide after the autoHideHeaderDelay timeouts of the content loses focus.
    */
    property alias autoHideFooter: _page.autoHideFooter

    /*!
      \qmlproperty int ApplicationWindow::autoHideHeaderDelay

      Time in milliseconds to wait before the header autohides if it is enabled.
    */
    property alias autoHideHeaderDelay: _page.autoHideHeaderDelay

    /*!
      \qmlproperty int ApplicationWindow::autoHideFooterDelay
      Time in milliseconds to wait before the footer autohides if it is enabled.
    */
    property alias autoHideFooterDelay: _page.autoHideFooterDelay

    /*!
      autoHideHeaderMargins : int

      Threshold out of where the header autohides if enabled.
    */
    property alias autoHideHeaderMargins: _page.autoHideHeaderMargins

    /*!
      \qmlproperty bool ApplicationWindow::autoHideFooterMargins

      Threshold out of where the footer autohides if enabled.
    */
    property alias autoHideFooterMargins: _page.autoHideFooterMargins

    /*!
      \qmlproperty bool ApplicationWindow::altHeader

      If the main header should be moved to the bottom of the page contents under the footer.
      This property can be dynamically changed on mobile devices for better reachability.
    */
    property alias altHeader: _page.altHeader

    /*!
      \qmlproperty int ApplicationWindow::margins
      The app page content margins.
    */
    property alias margins : _page.margins

    /*!
      \qmlproperty int ApplicationWindow::leftMargin

      The app page content margins.
    */
    property alias leftMargin : _page.leftMargin

    /*!
      \qmlproperty int ApplicationWindow::rightMargin

      The app page content margins.
    */
    property alias rightMargin: _page.rightMargin

    /*!
      \qmlproperty int ApplicationWindow::topMargin

      The app page content margins.
    */
    property alias topMargin: _page.topMargin

    /*!
      \qmlproperty int ApplicationWindow::bottomMargin

      The app page content margins.
    */
    property alias bottomMargin: _page.bottomMargin

    /*!
      The page footer bar positioning. It can be sticked or can be scrolled with the page content if a flickable is provided.
    */
    property alias footerPositioning : _page.footerPositioning

    /*!
      The page header bar positioning. It can be sticked or can be scrolled with the page content if a flickable is provided.
    */
    property alias headerPositioning : _page.headerPositioning

    /*!
      \qmlproperty Dialog ApplicationWindow::dialog

      The internal dialogs used in the ApplicationWindow are loaded dynamically, so the current loaded dialog can be accessed
      via this property.
    */
    property alias dialog: dialogLoader.item

    /*!
      \qmlproperty Component ApplicationWindow::background

      The application main page background.
    */
    property alias background : _page.background

    /*!
      If the application window size is wide enough.
      This property can be changed to any random condition.
      Keep in mind this property is widely used in other MauiKit components to determined if items shoudl be hidden or collapsed, etc.
    */
    property bool isWide : root.width >= Maui.Style.units.gridUnit * 30

    /***************************************************/
    /**************** READONLY PROPS ******************/
    /*************************************************/
    /*!
      If the screen where the application is drawn is in portrait mode or not,
      other wise it is in landscape mode.
    */
    readonly property bool isMaximized: root.visibility === Window.Maximized
    readonly property bool isFullScreen: root.visibility === Window.FullScreen
    readonly property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation || Screen.primaryOrientation === Qt.InvertedPortraitOrientation

    Maui.Page
    {
        id: _page
        anchors.fill: parent
        Maui.Theme.colorSet: root.Maui.Theme.colorSet
        showCSDControls: true

        Item
        {
            id: _content
            anchors.fill: parent
            clip: true
            transform: Translate
            {
                x: root.sideBar && root.sideBar.collapsible && root.sideBar.collapsed ? root.sideBar.position * (root.sideBar.implicitWidth) : 0
            }

            anchors.leftMargin: root.sideBar ? ((root.sideBar.collapsible && root.sideBar.collapsed) ? 0 : (root.sideBar.implicitWidth ) * root.sideBar.position) : 0
        }

        background: Rectangle
        {
            id: _pageBackground
            opacity: Maui.App.translucencyAvailable ? 0.7 : 1
            color: Maui.Theme.backgroundColor
            radius: root.isMaximized || root.isFullScreen || !Maui.App.controls.enableCSD ? 0 : Maui.App.controls.borderRadius
            
            Behavior on color
        {
            Maui.ColorTransition{}
        }
        }

        layer.enabled: Maui.App.controls.enableCSD
        layer.effect: OpacityMask
        {
            maskSource: Rectangle
            {
                width: _page.width
                height: _page.height
                radius: _pageBackground.radius
            }            
        }
    }

    Loader
    {
        active: Maui.App.controls.enableCSD
        visible: active
        z: ApplicationWindow.overlay.z + 9999
        anchors.fill: parent
        asynchronous: true

        sourceComponent: Rectangle
        {
            radius: _pageBackground.radius - 0.5
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
                radius: parent.radius - 0.5
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

        sourceComponent: MouseArea
        {
            cursorShape: Qt.SizeBDiagCursor
            propagateComposedEvents: true
            preventStealing: false

            onPressed: mouse.accepted = false

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

        sourceComponent: MouseArea
        {

            cursorShape: Qt.SizeFDiagCursor
            propagateComposedEvents: true
            preventStealing: false

            onPressed: mouse.accepted = false

            DragHandler
            {
                grabPermissions: TapHandler.TakeOverForbidden
                target: null
                onActiveChanged: if (active)
                                 {
                                     root.startSystemResize(Qt.RightEdge | Qt.BottomEdge);
                                 }
            }
        }
    }

    Overlay.overlay.modal: Rectangle
    {
        color: Qt.rgba( root.Maui.Theme.backgroundColor.r,  root.Maui.Theme.backgroundColor.g,  root.Maui.Theme.backgroundColor.b, 0.7)

        Behavior on opacity { NumberAnimation { duration: 150 } }

        radius: _pageBackground.radius
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    Overlay.overlay.modeless: Rectangle
    {
        radius: _pageBackground.radius

        color: Qt.rgba( root.Maui.Theme.backgroundColor.r,  root.Maui.Theme.backgroundColor.g,  root.Maui.Theme.backgroundColor.b, 0.7)
        Behavior on opacity { NumberAnimation { duration: 150 } }
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    Component
    {
        id: _notifyDialogComponent

        Maui.Dialog
        {
            id: _notify
            property var cb : ({})

            property alias iconName : _notifyTemplate.iconSource
            property alias title : _notifyTemplate.label1
            property alias body: _notifyTemplate.label2
            property alias timeInterval : _notifyTimer.interval

            persistent: false
            verticalAlignment: Qt.AlignTop
            defaultButtons: _notify.cb !== null
            rejectButton.visible: false

            onAccepted:
            {
                if(_notify.cb)
                {
                    _notify.cb()
                    _notify.close()
                }
            }

            page.margins: Maui.Style.space.big
            footBar.background: null
            widthHint: 0.8
            maxWidth: 400

            Timer
            {
                id: _notifyTimer
                onTriggered:
                {
                    if(_mouseArea.containsPress || _mouseArea.containsMouse)
                    {
                        _notifyTimer.restart();
                        return
                    }

                    _notify.close()
                }
            }

            onClosed: _notifyTimer.stop()

            stack: MouseArea
            {
                id: _mouseArea
                Layout.fillWidth: true
                hoverEnabled: true
                implicitHeight: _notifyTemplate.implicitHeight + Maui.Style.space.huge

                Maui.ListItemTemplate
                {
                    id: _notifyTemplate
                    spacing: Maui.Style.space.big
                    width: parent.width
                    anchors.centerIn: parent

                    iconSizeHint: Maui.Style.iconSizes.big
                    headerSizeHint: iconSizeHint + Maui.Style.space.big
                    label2.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    label1.font.bold: true
                    label1.font.weight: Font.Bold
                    label1.font.pointSize: Maui.Style.fontSizes.big
                    iconSource: "dialog-warning"
                }
            }

            function show(callback)
            {
                _notify.cb = callback || null
                _notifyTimer.start()
                _notify.open()
            }
        }
    }

    Loader
    {
        id: dialogLoader
    }

    Component.onCompleted:
    {
        if(Maui.Handy.isAndroid)
        {
            if(headBar.position === ToolBar.Footer)
            {
                Maui.Android.statusbarColor(Maui.Theme.backgroundColor, true)
                Maui.Android.navBarColor(headBar.visible ? headBar.Maui.Theme.backgroundColor : Maui.Theme.backgroundColor, true)

            } else
            {
                Maui.Android.statusbarColor(headBar.Maui.Theme.backgroundColor, true)
                Maui.Android.navBarColor(footBar.visible ? footBar.Maui.Theme.backgroundColor : Maui.Theme.backgroundColor, true)
            }
        }
    }

    Connections
    {
        target: Maui.Platform
        ignoreUnknownSignals: true
        function onShareFilesRequest(urls)
        {
            dialogLoader.source = "labs/ShareDialog.qml"
            dialog.urls = urls
            dialog.open()
        }
    }

    /**
      * Send an inline notification.
      * icon = icon to be used
      * title = the title
      * body = message of the notification
      * callback = function to be triggered if the notification dialog is accepted
      * timeout = time in milliseconds before the notification dialog is dismissed
      * buttonText = text in the accepted button
      */
    function notify(icon, title, body, callback, timeout, buttonText)
    {
        dialogLoader.sourceComponent = _notifyDialogComponent
        dialog.iconName = icon || "emblem-warning"
        dialog.title.text = title
        dialog.body.text = body
        dialog.timeInterval = timeout ? timeout : 2500
        dialog.acceptButton.text = buttonText || qsTr ("Accept")
        dialog.show(callback)
    }

    /**
      * Switch from full screen to normal size.
      */
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
      * Reference to the application main page
      */
    function window()
    {
        return _page;
    }

    function about()
    {
        dialogLoader.source = "qrc:/maui/kit/private/AboutDialog.qml"
        dialog.open()
    }
}
