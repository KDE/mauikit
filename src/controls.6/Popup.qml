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

import QtQuick as Q
import QtQuick.Controls as QQC

import org.mauikit.controls as Maui
import QtQuick.Effects

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
QQC.Popup
{
    id: control
    
    width: (filling ? parent.width  : mWidth)
    height: (filling ? parent.height : mHeight)

    anchors.centerIn: parent
    
    Q.Behavior on width
    {
        enabled: control.hint === 1
        
        Q.NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Q.Easing.InOutQuad
        }
    }
    
    Q.Behavior on height
    {
        enabled: control.hint === 1
        
        Q.NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Q.Easing.InOutQuad
        }
    }
    
    readonly property int mWidth: Math.round(Math.min(control.parent.width * widthHint, maxWidth))
    readonly property int mHeight: Math.round(Math.min(control.parent.height * heightHint, maxHeight))
    
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

    contentItem: Q.Item
    {
        id: _content

        layer.enabled: Q.GraphicsInfo.api !== Q.GraphicsInfo.Software
        layer.effect: MultiEffect
        {
            maskEnabled: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
            maskSpreadAtMax: 0.0
            maskThresholdMax: 1.0
            maskSource: Q.ShaderEffectSource
            {
                sourceItem: Q.Rectangle
                {
                    width: _content.width
                    height: _content.height
                    radius:  control.filling ? 0 : Maui.Style.radiusV
                }
            }
        }
    }

    Maui.Controls.flat: control.filling
}
