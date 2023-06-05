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


import QtQuick
import QtQuick.Templates as T

import org.mauikit.controls as Maui
import Qt5Compat.GraphicalEffects

T.ProgressBar
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
        
    contentItem: Item
    {
        implicitHeight: 10
        implicitWidth: 200
        
        scale: control.mirrored ? -1 : 1
        
        Rectangle
        {
            visible: !control.indeterminate
            height: parent.height
            width: control.position * parent.width

            color: Maui.Theme.highlightColor
        }
        
        Repeater
        {
            model: 2
            enabled: !control.indeterminate
            
            Rectangle
            {
                property real offset: 0
                
                x:  offset * parent.width

                width: offset * (parent.width - x)
                height: parent.height

                color: Maui.Theme.highlightColor
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }
                
                SequentialAnimation on offset
                {
                    loops: Animation.Infinite
                    running: control.indeterminate && control.visible
                    PauseAnimation { duration: index ? 520 : 0 }
                    NumberAnimation
                    {
                        easing.type: Easing.OutCubic
                        duration: 1240
                        from: 0
                        to: 1
                    }
                    PauseAnimation { duration: index ? 0 : 520 }
                }
            }
        }
        
        layer.enabled: control.background && control.background.radius > 0
        layer.effect: OpacityMask
        {
            maskSource: Rectangle
            {
                width: control.width
                height: control.height
                radius: control.background.radius
            }
        }
    }

    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: Maui.Theme.backgroundColor
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}

