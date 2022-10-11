/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.0

T.Slider
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: !Maui.Handy.isMobile
    
    handle: Rectangle
    {
        id: handleRect
        visible: control.pressed
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))

        width: Maui.Style.iconSizes.medium
        height: width
        radius: width /2
        color: Maui.Theme.highlightColor
        border.color: Maui.Theme.highlightColor

        Behavior on scale
        {
            NumberAnimation
            {
                duration: 250
            }
        }
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
    }

    snapMode: T.Slider.SnapOnRelease

    background: Rectangle
    {
        id: bg
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)

        implicitWidth: control.horizontal ? 200 : 48
        implicitHeight: control.horizontal ? 48 : 200

        width: control.horizontal ? control.availableWidth : 8
        height: control.horizontal ? 8 : control.availableHeight

        color: control.hovered ? control.Maui.Theme.hoverColor : control.Maui.Theme.backgroundColor
        scale: control.horizontal && control.mirrored ? -1 : 1
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }

        Rectangle
        {
            x: control.horizontal ? 0 : (parent.width - width) / 2
            y: control.horizontal ? (parent.height - height) / 2 : control.visualPosition * parent.height
            width: control.horizontal ? control.position * parent.width : 8
            height: control.horizontal ? 8 : control.position * parent.height

            color: Qt.rgba(control.Maui.Theme.highlightColor.r, control.Maui.Theme.highlightColor.g, control.Maui.Theme.highlightColor.b, 0.7)
            //            border.color: control.Maui.Theme.highlightColor
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask
        {
            maskSource: Rectangle
            {
                width: bg.width
                height: bg.height
                radius:  Maui.Style.radiusV
            }
        }
    }
}
