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
import QtQml 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui

/*!
\since org.mauikit.controls 1.0
\inqmlmodule org.mauikit.controls
\brief Collapsible sidebar

A global sidebar for the application window that can be collapsed.
To use a collapsable sidebar is a better idea to make use of the SideBar or ActionSideBar components which are ready for it and are handled by a ListView, you only need a data model or list of actions to be used.
*/
Drawer
{
    id: control
    edge: Qt.LeftEdge
    
    position: visible ? 1 : 0
    visible: enabled    
    
    implicitWidth: Math.min(preferredWidth, window().width)
    width: implicitWidth

    implicitHeight: window().internalHeight
    height: window().internalHeight

    y: (window().header && !window().altHeader ? window().header.height : 0)
    //    closePolicy: modal || collapsed ?  Popup.CloseOnEscape | Popup.CloseOnPressOutside : Popup.NoAutoClose

    interactive: (modal || collapsed ) && Maui.Handy.isTouch && enabled

    dragMargin: Maui.Style.space.medium

    modal: false

    opacity: _dropArea.containsDrag ? 0.5 : 1
    clip: true
    
    contentItem: null

    padding: 0
    leftPadding: 0
    rightPadding: 0
    background: Kirigami.ShadowedRectangle
    {
        color: Kirigami.Theme.backgroundColor
        property int radius: !Maui.App.controls.enableCSD ? 0 : Maui.App.controls.borderRadius
        
        corners
        {
            topLeftRadius: radius
            topRightRadius: 0
            bottomLeftRadius: radius
            bottomRightRadius: 0
        }
    }

    /*!
      \qmlproperty Item AbstractSideBar::content

      The main content is added to an Item contents, it can anchored or sized normally.
    */
    default property alias content : _content.data

    /*!
      If the sidebar can be collapsed into a slimmer bar with a width defined by the collapsedSize hint.
    */
    property bool collapsible: false

    /*!
      If the sidebar should be collapsed or not, this property can be used to dynamically collapse
      the sidebar on constrained spaces.
    */
    property bool collapsed: false

    /*!
      preferredWidth : int
      The preferred width of the sidebar in the expanded state.
    */
    property int preferredWidth : Kirigami.Units.gridUnit * 12

    /*!
      \qmlproperty MouseArea AbstractSideBar::overlay

      When the application has a constrained width to fit the sidebar and main contain,
      the sidebar is in a constrained state, and the app main content gets dimmed by an overlay.
      This property gives access to such ovelay element drawn on top of the app contents.
    */
    readonly property alias overlay : _overlay

    signal contentDropped(var drop)
    
    Binding on z
    {
        value: root.window().z
        restoreMode: Binding.RestoreBindingOrValue
    }
    
    onCollapsedChanged:
    {
        if(collapsed || !control.enabled)
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
    }

    Kirigami.Separator
    {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 0.5
        weight: Kirigami.Separator.Weight.Light
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
    
    //layer.enabled: Maui.App.controls.enableCSD
    //layer.effect: OpacityMask
    //{
        //maskSource: Item
        //{
            //width: _page.width
            //height: _page.height
            
            //Rectangle
            //{
                //anchors.fill: parent
                //radius: _pageBackground.radius
            //}
        //}
    //}

    function toggle()
    {
        if(!control.enabled)
        {
             close()
             return
        }
        
        if(control.position > 0 && control.visible)
        {
            control.close()
        }
        else
        {
            control.open()
        }
    }
}

