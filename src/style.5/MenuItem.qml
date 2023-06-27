/****************************************************************************
**
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
import QtQuick.Layouts 1.10

import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui

T.MenuItem
{
    id: control

    opacity: control.enabled ? 1 : 0.5
        
    hoverEnabled: !Maui.Handy.isMobile
           
    implicitWidth: ListView.view ? ListView.view.width : Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    
    width: implicitWidth
    
    implicitHeight: Math.floor(Math.max(implicitContentHeight + topPadding + bottomPadding,
                                       implicitIndicatorHeight + topPadding + bottomPadding) )

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
    icon.color: control.down || control.pressed || control.checked ? Maui.Theme.highlightedTextColor : Maui.Theme.textColor
    
    property bool flat: !Maui.Handy.isMobile
    property bool showIcon: Maui.Style.menusHaveIcons
    
    font: Maui.Style.defaultFont
    
    indicator: CheckIndicator
    {
        x: control.width - width - control.rightPadding 
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.checkable
        control: control
    }

    arrow: Maui.Icon
    {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding 
        y: control.topPadding + (control.availableHeight - height) / 2

        visible: control.subMenu
        //        mirror: control.mirrored
        color: control.icon.color
        height: 10
        width: 10
        source: "qrc:/assets/arrow-right.svg"        
    }
    
    contentItem: Maui.IconLabel
    {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
        
        rightPadding: indicatorPadding + arrowPadding 
        
        spacing: control.spacing
        
        display: control.display
        
        alignment: Qt.AlignLeft
        
        icon: control.showIcon ? control.icon : null
        text: control.text
        font: control.font
        color: control.icon.color        
    }

    background: Rectangle
    {               
        radius: Maui.Style.radiusV
        
        color: control.enabled ? (control.checked || control.pressed || control.down ? Maui.Theme.highlightColor : control.highlighted || control.hovered ? Maui.Theme.hoverColor : (control.flat ?   "transparent" : Maui.Theme.alternateBackgroundColor)) : "transparent"

        Behavior on color
        {
            enabled: !control.flat
            Maui.ColorTransition{}
        }
    }
}
