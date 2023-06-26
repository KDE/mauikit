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
import QtQuick.Controls
import QtQuick.Window

import org.mauikit.controls as Maui

import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

/**
 * PieButton
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Control
{
    id: control

    /**
      * alignment : int
      */
    property int alignment : Qt.AlignLeft

    /**
      * maxWidth : int
      */
    property int maxWidth : Window.window.width - control.anchors.margins

    /**
      * actions : list<Action>
      */
    default property list<Action> actions

    /**
      * icon : icon
      */
    property alias icon : _button.icon

    /**
      * text : string
      */
    property alias text: _button.text

    /**
      * display : ToolButton.display
      */
    property alias display: _button.display

    implicitWidth: implicitContentWidth + leftPadding + rightPadding

    implicitHeight: implicitContentHeight+ topPadding + bottomPadding

    Behavior on implicitWidth
    {
        NumberAnimation
        {
            duration: Maui.Style.units.longDuration
            easing.type: Easing.InOutQuad
        }
    }

//    MouseArea
//    {
//        id: _overlay
//        anchors.fill: parent

//        parent: control.parent

//        preventStealing: true
//        propagateComposedEvents: true
//        visible: _actionsBar.visible
//        opacity: visible ? 1 : 0

//        Behavior on opacity
//        {
//            NumberAnimation
//            {
//                duration: Maui.Style.units.longDuration
//                easing.type: Easing.InOutQuad
//            }
//        }
//        Rectangle
//        {
//            color: Qt.rgba(control.Maui.Theme.backgroundColor.r,control.Maui.Theme.backgroundColor.g,control.Maui.Theme.backgroundColor.b, 0.5)
//            anchors.fill: parent
//        }

//        onClicked: (mouse) =>
//                   {
//                       control.close()
//                       mouse.accepted = false
//                   }
//    }

    background: Rectangle
    {
        id: _background
        visible: control.implicitWidth > height

        color: Maui.Theme.backgroundColor
        radius: Maui.Style.radiusV
        layer.enabled: true

        layer.effect: DropShadow
        {
            cached: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 16
            color: "#333"
            opacity: 0.5
            smooth: true
            source: _background
        }
    }

    contentItem: RowLayout
    {
        id: _layout

        Maui.ToolBar
        {
            id: _actionsBar
            visible: false

            //            Layout.fillWidth: true
            //            Layout.fillHeight: true

            background: null

            middleContent: Repeater
            {
                model: control.actions

                ToolButton
                {
                    Layout.fillHeight: true
                    action: modelData
                    display: ToolButton.TextUnderIcon
                    onClicked: control.close()
                }
            }
        }

        Maui.FloatingButton
        {
            id: _button
            Layout.alignment:Qt.AlignRight

            onClicked: _actionsBar.visible = !_actionsBar.visible
        }
    }

    /**
      *
      */
    function open()
    {
        _actionsBar.visible = true
    }

    /**
      *
      */
    function close()
    {
        _actionsBar.visible = false
    }
}




