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


import QtQuick 2.6
import QtQuick.Templates 2.3 as T
import org.mauikit.controls 1.3 as Maui

import "private"

T.CheckBox 
{
    id: control
    opacity: enabled ? 1 : 0.5
    
    implicitWidth: Math.max(contentItem.implicitWidth, indicator ? indicator.implicitWidth : 0) + leftPadding + rightPadding
    
    implicitHeight: Math.max(contentItem.implicitHeight, indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    hoverEnabled: !Maui.Handy.isMobile

    indicator: CheckIndicator
    {
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        control: control
    }

    contentItem: Label
    {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        text: control.text
        font: control.font
        elide: Text.ElideRight
        visible: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: Maui.Theme.textColor
    }
    
    background: Rectangle
    {
        visible: !control.flat
        
        color: control.checked || control.pressed || control.down ? Maui.Theme.highlightColor : control.highlighted || control.hovered ? Maui.Theme.hoverColor : (control.flat ?   "transparent" : Maui.Theme.alternateBackgroundColor)

        radius: Maui.Style.radiusV
        
        Behavior on color
        {
            enabled: !control.flat
            Maui.ColorTransition{}
        }
    }
}
