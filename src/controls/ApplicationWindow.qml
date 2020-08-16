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

import QtQuick 2.12
import QtQuick.Controls 2.3

import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import org.kde.mauikit 1.1 as MauiLab

import "private" as Private

Window
{
    id: root
    default property alias content : _page.content

    visible: true
    width: Screen.desktopAvailableWidth * (Kirigami.Settings.isMobile ? 1 : 0.4)
    height: Screen.desktopAvailableHeight * (Kirigami.Settings.isMobile ? 1 : 0.4)
    color: "transparent"
    flags: Maui.App.enableCSD ? Qt.FramelessWindowHint : Qt.Window

    property alias sideBar : _sideBar

    /***************************************************/
    /******************** ALIASES *********************/
    /*************************************************/

    property alias flickable : _page.flickable

    property alias headBar : _page.headBar
    property alias footBar: _page.footBar

    property alias footer: _page.footer
    property alias header :_page.header
    property alias floatingHeader: _page.floatingHeader
    property alias floatingFooter: _page.floatingFooter
    property alias autoHideHeader: _page.autoHideHeader
    property alias autoHideFooter: _page.autoHideFooter
    
    property alias autoHideHeaderDelay: _page.autoHideHeaderDelay
    property alias autoHideFooterDelay: _page.autoHideFooterDelay
    
    property alias autoHideHeaderMargins: _page.autoHideHeaderMargins
    property alias autoHideFooterMargins: _page.autoHideFooterMargins
    
    property alias altHeader: _page.altHeader
    property alias margins : _page.margins
    property alias leftMargin : _page.leftMargin
    property alias rightMargin: _page.rightMargin
    property alias topMargin: _page.topMargin
    property alias bottomMargin: _page.bottomMargin
    
    property alias footerPositioning : _page.footerPositioning
    property alias headerPositioning : _page.headerPositioning

    property alias dialog: dialogLoader.item

    property alias menuButton : menuBtn
    property alias mainMenu : mainMenu.contentData

    property alias accounts: _accountsDialogLoader.item
    property var currentAccount: Maui.App.handleAccounts ? Maui.App.accounts.currentAccount : ({})

    property alias notifyDialog: _notify
    
    property alias background : _page.background

    property bool isWide : root.width >= Kirigami.Units.gridUnit * 30

    /***************************************************/
    /********************* COLORS *********************/
    /*************************************************/
    Kirigami.Theme.colorSet: Kirigami.Theme.View

    /***************************************************/
    /**************** READONLY PROPS ******************/
    /*************************************************/
    readonly property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation || Screen.primaryOrientation === Qt.InvertedPortraitOrientation

    /***************************************************/
    /******************** SIGNALS *********************/
    /*************************************************/
    signal menuButtonClicked();

    onClosing:
    {
        if(!Kirigami.Settings.isMobile)
        {
            const height = root.height
            const width = root.width
            const x = root.x
            const y = root.y
            Maui.FM.saveSettings("GEOMETRY", Qt.rect(x, y, width, height), "WINDOW")
        }
    }

    background: Rectangle
    {
        id: _pageBackground
        color: Kirigami.Theme.backgroundColor
        radius: root.visibility === Window.Maximized || !Maui.App.enableCSD ? 0 : Maui.App.theme.borderRadius
    }

//    Item
//    {
//        anchors.fill: parent
//        DragHandler
//        {
//                id: resizeHandler
//                grabPermissions: TapHandler.TakeOverForbidden
//                target: null
//                onActiveChanged: if (active) {
//                    const p = resizeHandler.centroid.position;
//                    let e = 0;
//                    if (p.x / width < 0.10) { e |= Qt.LeftEdge }
//                    if (p.x / width > 0.90) { e |= Qt.RightEdge }
//                    if (p.y / height < 0.10) { e |= Qt.TopEdge }
//                    if (p.y / height > 0.90) { e |= Qt.BottomEdge }
//                    console.log("RESIZING", e);
//                    root.startSystemResize(e);
//                }
//            }
//    }

    Item
    {
        id: _layout
        anchors.fill: parent
//        anchors.margins: Maui.App.enableCSD ?  Maui.Style.space.small : 0

        Item
        {
            anchors.fill: parent

            AbstractSideBar
            {
                id: _sideBar
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                headBar.farLeftContent: Loader
                {
                    visible: active
                    active: Maui.App.enableCSD && Maui.App.leftWindowControls.length && visible
                    Layout.preferredWidth: active ? implicitWidth : 0
                    Layout.fillHeight: true
                    sourceComponent: MauiLab.WindowControls
                    {
                        order: Maui.App.leftWindowControls
                    }
                }
            }

            Kirigami.Separator
            {
                z: parent.z + 999
                anchors.right: _sideBar.right
                height: parent.height
            }


            MauiLab.Page
            {
                id: _page
                anchors.fill: parent
                transform: Translate
                {
                    x: sideBar.visible && root.sideBar.collapsible && root.sideBar.collapsed ? _sideBar.position * (root.sideBar.width - root.sideBar.collapsedSize) : 0
                }

                anchors.leftMargin: _sideBar.visible ? ((_sideBar.collapsible && _sideBar.collapsed) ? _sideBar.collapsedSize : (_sideBar.width ) * _sideBar.position) : 0

//                Rectangle
//                {
//                    z: ApplicationWindow.overlay.z + 9999
//                    anchors.top: parent.top
//                    anchors.bottom: parent.bottom
//                    anchors.horizontalCenter: parent.left
//                    color: "yellow"
//                    width: _sideBar.dragMargin

//                    DragHandler
//                    {
//                        id: _sidebarDragHandler
//                        target: null
//                        grabPermissions: TapHandler.TakeOverForbidden
//                        xAxis.maximum: _sideBar.preferredWidth
//                        yAxis.enabled: false

////                        enabled: _sideBar.interactive

//                    }

//                }

                MouseArea
                {
                    id: _overlay
                    z: parent.z + 9999
                    enabled: _sideBar.visible
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    visible: _sideBar.collapsed && _sideBar.position > 0 && _sideBar.visible
                    Rectangle
                    {
                        color: Qt.rgba(_sideBar.Kirigami.Theme.backgroundColor.r, _sideBar.Kirigami.Theme.backgroundColor.g, _sideBar.Kirigami.Theme.backgroundColor.b, 0.5)
                        opacity: _sideBar.position
                        anchors.fill: parent
                    }

                    onClicked: _sideBar.close()
                }


                Kirigami.Theme.colorSet: root.Kirigami.Theme.colorSet
                headerBackground.color: Maui.App.enableCSD ? Qt.darker(Kirigami.Theme.backgroundColor, 1.1) : headBar.Kirigami.Theme.backgroundColor

                headBar.farLeftContent: Loader
                {
                    visible: active
                    active: Maui.App.enableCSD && Maui.App.leftWindowControls.length && !_sideBar.visible
                    Layout.preferredWidth: active ? implicitWidth : 0
                    Layout.fillHeight: true
                    sourceComponent: MauiLab.WindowControls
                    {
                        order: Maui.App.leftWindowControls
                    }
                }

                headBar.leftContent: ToolButton
                {
                    id: menuBtn
                    icon.name: "application-menu"
                    checked: mainMenu.visible
                    onClicked:
                    {
                        menuButtonClicked()
                        mainMenu.visible ? mainMenu.close() : mainMenu.popup(parent, 0 , root.headBar.height )
                    }

                    Menu
                    {
                        id: mainMenu
                        modal: true
                        z: 999
                        width: Maui.Style.unit * 250

                        Loader
                        {
                            id: _accountsMenuLoader
                            width: parent.width - (Maui.Style.space.medium*2)
                            anchors.horizontalCenter: parent.horizontalCenter

                            active: Maui.App.handleAccounts
                            sourceComponent: Maui.App.handleAccounts ?
                                                 _accountsComponent : null
                        }

                        Item
                        {
                            visible: _accountsMenuLoader.active
                        }

                        MenuItem
                        {
                            text: i18n("About")
                            icon.name: "documentinfo"
                            onTriggered: aboutDialog.open()
                        }
                    }
                }

                headBar.farRightContent: Loader
                {
                    id: _rightControlsLoader
                    visible: active
                    active: Maui.App.enableCSD && Maui.App.rightWindowControls.length
                    Layout.preferredWidth: active ? implicitWidth : 0
                    Layout.fillHeight: true
                    sourceComponent: MauiLab.WindowControls
                    {
                        order:  Maui.App.rightWindowControls
                    }
                }
            }

            layer.enabled: Maui.App.enableCSD
            layer.effect: OpacityMask
            {
                maskSource: Item
                {
                    width: _layout.width
                    height: _layout.height

                    Rectangle
                    {
                        anchors.fill: parent
                        radius: _pageBackground.radius
                    }
                }
            }
        }

        Rectangle
        {
            visible: Maui.App.enableCSD
            z: ApplicationWindow.overlay.z + 9999
            anchors.fill: parent
            radius: _pageBackground.radius - 0.5
            color: "transparent"
            border.color: Qt.darker(Kirigami.Theme.backgroundColor, 2.7)
            opacity: 0.8

            Rectangle
            {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                radius: parent.radius - 0.5
                border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
                opacity: 0.8
            }
        }
    }

//    DropShadow
//    {
//        visible: Maui.App.enableCSD
//        anchors.fill: _layout
//        horizontalOffset: 0
//        verticalOffset: 0
//        radius: 8.0
//        samples: 17
//        color: "#80000000"
//        source: _layout
//    }
    
    MouseArea
    {
        visible: Maui.App.enableCSD
        height: 16
        width: height
        anchors.bottom: parent.bottom
        anchors.left: parent.left
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
    
    MouseArea
    {
        visible: Maui.App.enableCSD
        height: 16
        width: height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
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

    Overlay.overlay.modal: Rectangle
    {
        color: Qt.rgba( root.Kirigami.Theme.backgroundColor.r,  root.Kirigami.Theme.backgroundColor.g,  root.Kirigami.Theme.backgroundColor.b, 0.7)
        
        Behavior on opacity { NumberAnimation { duration: 150 } }
        
        radius: Maui.App.enableCSD ? Maui.App.theme.borderRadius : 0
    }
    
    Overlay.overlay.modeless: Rectangle
    {
        radius: Maui.App.enableCSD ? Maui.App.theme.borderRadius : 0

        color: Qt.rgba( root.Kirigami.Theme.backgroundColor.r,  root.Kirigami.Theme.backgroundColor.g,  root.Kirigami.Theme.backgroundColor.b, 0.7)
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Component
    {
        id: _accountsComponent

        Rectangle
        {
            height: _accountLayout.implicitHeight + Maui.Style.space.medium
            color: Qt.darker(Kirigami.Theme.backgroundColor, 1.05)
            radius: Maui.Style.radiusV

            ColumnLayout
            {
                id: _accountLayout
                anchors.fill: parent
                spacing: Maui.Style.space.medium

                ListBrowser
                {
                    id: _accountsListing
                    visible: _accountsListing.count > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, 300)
                    spacing: Maui.Style.space.medium
                    Kirigami.Theme.backgroundColor: "transparent"
                    currentIndex: Maui.App.accounts.currentAccountIndex

                    model:  Maui.BaseModel
                    {
                        list: Maui.App.accounts
                    }

                    background: null

                    delegate: Maui.ListBrowserDelegate
                    {
                        iconSource: "amarok_artist"
                        iconSizeHint: Maui.Style.iconSizes.medium
                        label1.text: model.user
                        label2.text: model.server
                        width: _accountsListing.width
                        height: Maui.Style.rowHeight * 1.2
                        leftPadding: Maui.Style.space.tiny
                        rightPadding: Maui.Style.space.tiny
                        onClicked: Maui.App.accounts.currentAccountIndex = index
                    }

                    Component.onCompleted:
                    {
                        if(_accountsListing.count > 0)
                            Maui.App.accounts.currentAccountIndex = 0
                    }
                }

                Button
                {
                    Layout.margins: Maui.Style.space.small
                    Layout.preferredHeight: implicitHeight
                    Layout.alignment: Qt.AlignCenter
                    text: i18n("Accounts")
                    icon.name: "list-add-user"
                    onClicked:
                    {
                        if(root.accounts)
                            accounts.open()

                        mainMenu.close()
                    }
                }
            }
        }
    }

    Private.AboutDialog
    {
        id: aboutDialog
    }

    Loader
    {
        id: _accountsDialogLoader
        active: Maui.App.handleAccounts
        source: "private/AccountsHelper.qml"
    }

    Maui.Dialog
    {
        id: _notify
        property var cb : ({})
        
        property alias iconName : _notifyTemplate.iconSource
        property alias title : _notifyTemplate.label1
        property alias body: _notifyTemplate.label2
        
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

        page.padding: Maui.Style.space.medium

        footBar.background: null

        maxHeight: Math.max(Maui.Style.iconSizes.large + Maui.Style.space.huge, (_notifyTemplate.implicitHeight)) + Maui.Style.space.big + footBar.height
        maxWidth: Kirigami.Settings.isMobile ? parent.width * 0.9 : Maui.Style.unit * 500
        widthHint: 0.8

        Timer
        {
            id: _notifyTimer
            onTriggered:
            {
                if(_mouseArea.containsPress || _mouseArea.containsMouse)
                    return;

                _notify.close()
            }
        }

        onClosed: _notifyTimer.stop()

        Maui.ListItemTemplate
        {
            id: _notifyTemplate
            Layout.fillHeight: true
            Layout.fillWidth: true
            iconSizeHint: Maui.Style.iconSizes.huge
            label1.font.bold: true
            label1.font.weight: Font.Bold
            label1.font.pointSize: Maui.Style.fontSizes.big
            iconSource: "dialog-warning"

            MouseArea
            {
                id: _mouseArea
                Layout.fillHeight: true
                Layout.fillWidth: true
                hoverEnabled: true
            }
        }

        function show(callback)
        {
            _notify.cb = callback || null
            _notifyTimer.start()
            _notify.open()
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
                Maui.Android.statusbarColor(Kirigami.Theme.backgroundColor, true)
                Maui.Android.navBarColor(headBar.visible ? headBar.Kirigami.Theme.backgroundColor : Kirigami.Theme.backgroundColor, true)

            } else
            {
                Maui.Android.statusbarColor(headBar.Kirigami.Theme.backgroundColor, true)
                Maui.Android.navBarColor(footBar.visible ? footBar.Kirigami.Theme.backgroundColor : Kirigami.Theme.backgroundColor, true)
            }
        }

        if(!Kirigami.Settings.isMobile)
        {
            const rect = Maui.FM.loadSettings("GEOMETRY", "WINDOW", Qt.rect(root.x, root.y, root.width, root.height))
            root.x = rect.x
            root.y = rect.y
            root.width = rect.width
            root.height = rect.height
        }
    }

    function notify(icon, title, body, callback, timeout, buttonText)
    {
        _notify.iconName = icon || "emblem-warning"
        _notify.title.text = title
        _notify.body.text = body
        _notifyTimer.interval = timeout ? timeout : 2500
        _notify.acceptButton.text = buttonText || qsTr ("Accept")
        _notify.show(callback)
    }

    function toggleMaximized()
    {
        if (root.visibility === Window.Maximized)
        {
            root.showNormal();
        } else
        {
            root.showMaximized();
        }
    }

    function window()
    {
        return _page;
    }
}
