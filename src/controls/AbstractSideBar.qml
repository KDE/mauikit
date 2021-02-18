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

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.2 as Maui

/**
 * AbstractSideBar
 * A global sidebar for the application window that can be collapsed.
 *
 * To use a collapsable sidebar is a better idea to make use of the SideBar or ActionSideBar components
 * which are ready for it and are handled by a ListView, you only need a data model or list of actions to be used.
 *
 *
 *
 */
Drawer
{
    id: control
    edge: Qt.LeftEdge

    implicitWidth: Math.min(preferredWidth, window().width)
    width: implicitWidth

    implicitHeight: window().internalHeight
    height: window().internalHeight

    y: (window().header && !window().altHeader ? window().header.height : 0)
    //    closePolicy: modal || collapsed ?  Popup.CloseOnEscape | Popup.CloseOnPressOutside : Popup.NoAutoClose

    interactive: (modal || collapsed || !visible) && Maui.Handy.isTouch

//     dragMargin: Maui.Style.iconSizes.huge

    modal: false

    opacity: _dropArea.containsDrag ? 0.5 : 1

    contentItem: null

    background: Rectangle
    {
        color: Kirigami.Theme.backgroundColor
    }

    /**
      * content : Item.data
      * The main content is added to an Item contents, it can anchored or sized normally.
      */
    default property alias content : _content.data

    /**
      * collapsible : bool
      * If the sidebar can be collapsed into a slimmer bar with a width defined by the collapsedSize hint.
      */
    property bool collapsible: false

    /**
      * collapsed : bool
      * If the sidebar should be collapsed or not, this property can be used to dynamically collapse
      * the sidebar on constrained spaces.
      */
    property bool collapsed: false

    /**
      * preferredWidth : int
      * The preferred width of the sidebar in the expanded state.
      */
    property int preferredWidth : Kirigami.Units.gridUnit * 12

    /**
      * overlay : MouseArea
      * When the application has a constrained width to fit the sidebar and main contain,
      * the sidebar is in a constrained state, and the app main content gets dimmed by an overlay.
      * This property gives access to such ovelay element drawn on top of the app contents.
      */
    readonly property alias overlay : _overlay

    /**
      * contentDropped
      */
    signal contentDropped(var drop)

    onCollapsedChanged:
    {
        if(collapsed)
        {
            control.position = 0
            control.close()
        }
        else
        {
            control.position = 1
            control.open()
        }
    }

    MouseArea
    {
        id: _overlay
        enabled: control.visible
        anchors.fill: parent
        anchors.margins: 0
        anchors.leftMargin: (control.width * control.position)
        parent: window().pageContent
        preventStealing: true
        propagateComposedEvents: false
        visible: (control.collapsed && control.position > 0 && control.visible)
        Rectangle
        {
            color: Qt.rgba(control.Kirigami.Theme.backgroundColor.r,control.Kirigami.Theme.backgroundColor.g,control.Kirigami.Theme.backgroundColor.b, 0.5)
            opacity: control.position
            anchors.fill: parent
        }

        onClicked: control.close()
    }

    Item
    {
        id: _content
        anchors.fill: parent

        Maui.Separator
        {
            z: 9999
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            position: Qt.Vertical
        }
    }

    Component.onCompleted:
    {
        if(control.visible)
        {
            control.position = 1
            control.open()
        }
    }

    Behavior on position
    {
        enabled: control.collapsible && control.position === 1
        NumberAnimation
        {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }

    DropArea
    {
        id: _dropArea
        anchors.fill: parent
        onDropped:
        {
            control.contentDropped(drop)
        }
    }

    function toggle()
    {
        if(control.position > 0 && control.visible)
            control.close()
        else
            control.open()
    }
}

