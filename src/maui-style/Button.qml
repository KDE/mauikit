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
import QtQuick.Controls.impl 2.12

T.Button
{
    id: control
    opacity: control.enabled ? 1 : 0.5

    implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth) + Maui.Style.space.big + leftPadding + rightPadding
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    
    hoverEnabled: !Maui.Handy.isMobile

    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize

    icon.color: control.down || control.checked ? (control.flat ? Maui.Theme.highlightColor : Maui.Theme.highlightedTextColor) : Maui.Theme.textColor
    
    spacing: Maui.Style.space.small
    
    padding: Maui.Style.space.small
    rightPadding: padding
    leftPadding: padding
    topPadding: padding
    bottomPadding: padding
    
    contentItem: IconLabel
    {
        text: control.text
        font: control.font
        icon: control.icon
        color: control.icon.color
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignCenter
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
    
    background: Rectangle
    {
        visible: !control.flat
        implicitWidth:  (Maui.Style.iconSizes.medium * 3) + Maui.Style.space.big
        implicitHeight: Maui.Style.rowHeight
        color: control.pressed || control.down || control.checked ? Maui.Theme.highlightColor : (control.highlighted || control.hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor)
        
        radius: Maui.Style.radiusV
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
