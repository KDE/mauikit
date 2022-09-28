/****************************************************************************
 * *
 ** Copyright (C) 2017 The Qt Company Ltd.
 ** Contact: http://www.qt.io/licensing/
 **
 ** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
 **
 ** $QT_BEGIN_LICENSE:LGPL3$
 ** Commercial License Usage
 ** Licensees holding valid commercial Qt licenses may use this file in
 ** accordance with the commercial license agreement provided with the
 ** Software or, alternatively, in accordance with the terms contained in
 ** a written agreement between you and The Qt Company. For licensing terms
 ** and conditions see http://www.qt.io/terms-conditions. For further
 ** information use the contact form at http://www.qt.io/contact-us.
 **
 ** GNU Lesser General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU Lesser
 ** General Public License version 3 as published by the Free Software
 ** Foundation and appearing in the file LICENSE.LGPLv3 included in the
 ** packaging of this file. Please review the following information to
 ** ensure the GNU Lesser General Public License version 3 requirements
 ** will be met: https://www.gnu.org/licenses/lgpl.html.
 **
 ** GNU General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU
 ** General Public License version 2.0 or later as published by the Free
 ** Software Foundation and appearing in the file LICENSE.GPL included in
 ** the packaging of this file. Please review the following information to
 ** ensure the GNU General Public License version 2.0 requirements will be
 ** met: http://www.gnu.org/licenses/gpl-2.0.html.
 **
 ** $QT_END_LICENSE$
 **
 ****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui

T.ToolButton
{
    id: control
    Maui.Theme.colorSet:  Maui.Theme.Button
    Maui.Theme.inherit: false
    
    property bool subMenu : false
    
    opacity: enabled ? 1 : 0.5
    
    property int preferredWidth : Math.floor(Maui.Style.iconSizes.medium + (Maui.Style.space.medium * 1.5))
    property int preferredHeight : Maui.Style.rowHeight
    
    implicitWidth: Math.max(preferredWidth, implicitContentWidth + leftPadding + rightPadding, implicitHeight)    
    implicitHeight: Math.max(preferredHeight,implicitContentHeight + topPadding + bottomPadding)
    //    baselineOffset: contentItem.y + contentItem.baselineOffset
    
    hoverEnabled: !Maui.Handy.isMobile
    
    spacing: Maui.Style.space.small
    
    padding: Maui.Style.space.medium
    
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
    
    icon.color: control.down || control.checked ? (control.flat ? Maui.Theme.highlightColor : Maui.Theme.highlightedTextColor) : Maui.Theme.textColor
    
    flat: control.parent === T.ToolBar
    
    font.pointSize: control.display === ToolButton.TextUnderIcon ? Maui.Style.fontSizes.small : undefined
    
    indicator: Maui.Icon
    {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding 
        y: control.topPadding + (control.availableHeight - height) / 2
        
        visible: control.subMenu
        //        mirror: control.mirrored
        color: control.icon.color
        height: 8
        width: 8
        rotation: 90
        source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/Material/images/arrow-indicator.png"
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
    
    contentItem: IconLabel
    {
        readonly property real arrowPadding: control.subMenu && control.indicator ? control.indicator.width + control.spacing : 0
        
        rightPadding: arrowPadding
                
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        
        icon: control.icon
        text: control.text
        font: control.font
        color: control.icon.color
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
    
    Behavior on implicitHeight
    {
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InQuad
        }
    }
    
    Behavior on implicitWidth
    {
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InQuad
        }
    }
    
    background: Rectangle
    {
        visible: !control.flat
                radius: Maui.Style.radiusV
        
        color: control.pressed || control.down || control.checked ? control.Maui.Theme.highlightColor : (control.highlighted || control.hovered ? control.Maui.Theme.hoverColor : "transparent")
        
        //         Behavior on color
        //         {
        //            Maui.ColorTransition{}
        //         }
    }
}
