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

import org.mauikit.controls as Maui

import QtQuick.Templates as T

import Qt5Compat.GraphicalEffects

/**
 * Popup
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Popup
{
    id: control
    
    parent: Overlay.overlay
    Maui.Theme.colorSet: Maui.Theme.View

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    width: (filling ? parent.width  : mWidth)
    height: (filling ? parent.height : mHeight)
    
    Behavior on width
    {
        enabled: control.hint === 1
        
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    Behavior on height
    {
        enabled: control.hint === 1
        
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    readonly property int mWidth:  Math.round(Math.min(control.parent.width * widthHint, maxWidth))
    readonly property int mHeight: Math.round(Math.min(control.parent.height * heightHint, maxHeight))
    
    anchors.centerIn: parent

    modal: true
    padding: 0
    clip: false

    margins: filling ? 0 : Maui.Style.space.medium
        
    property bool filling : false
    /**
     * content : Item.data
     */
    default property alias content : _content.data

    /**
         * maxWidth : int
         */
    property int maxWidth : 700

    /**
         * maxHeight : int
         */
    property int maxHeight : 400

    /**
         * hint : double
         */
    property double hint : 0.9

    /**
         * heightHint : double
         */
    property double heightHint: hint

    /**
         * widthHint : double
         */
    property double widthHint: hint

    contentItem: Item
    {
        id: _content
        layer.enabled: true
        layer.effect: OpacityMask
        {
            cached: true
            maskSource:  Rectangle
            {
                width: _content.width
                height: _content.height
                radius:  control.filling ? 0 : Maui.Style.radiusV
            }
        }
    }

    background: Rectangle
    {
        color: control.Maui.Theme.backgroundColor

        radius:  control.filling ? 0 : Maui.Style.radiusV
        // property color borderColor: Maui.Theme.textColor
        // border.color: Maui.Style.trueBlack ? Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3) : undefined
        layer.enabled: !control.filling
        layer.effect: DropShadow
        {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8
            samples: 16
            color: "#80000000"
            transparentBorder: true
        }

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    //         enter: Transition {
    //             NumberAnimation {
    //                 property: "opacity"
    //                 from: 0
    //                 to: 1
    //                 easing.type: Easing.InOutQuad
    //                 duration: 250
    //             }
    //         }
    //
    //         exit: Transition {
    //             NumberAnimation {
    //                 property: "opacity"
    //                 from: 1
    //                 to: 0
    //                 easing.type: Easing.InOutQuad
    //                 duration: 250
    //             }
    //         }
    //


    //         T.Overlay.modal: Rectangle
    //         {
    //             color: Qt.rgba( control.Maui.Theme.backgroundColor.r,  control.Maui.Theme.backgroundColor.g,  control.Maui.Theme.backgroundColor.b, 0.7)
    //
    //             Behavior on opacity { NumberAnimation { duration: 150 } }
    //         }
    //
    //         T.Overlay.modeless: Rectangle
    //         {
    //             color: Qt.rgba( control.Maui.Theme.backgroundColor.r,  control.Maui.Theme.backgroundColor.g,  control.Maui.Theme.backgroundColor.b, 0.7)
    //             Behavior on opacity { NumberAnimation { duration: 150 } }
    //         }
    /**
         *
         */

}
