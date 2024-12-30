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

import QtQuick
import QtQuick.Layouts

import QtQuick.Templates as T
import org.mauikit.controls as Maui

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
    icon.color: setTextColor(control)
    
    property bool flat: !Maui.Handy.isMobile
    readonly property bool showIcon: Maui.Style.menusHaveIcons
    
    font: Maui.Style.defaultFont
    
    Shortcut 
    {
        id: dummyShortcut
        enabled: false
        sequence: control.action ? control.action.shortcut : ""
    }
    
    indicator: CheckIndicator
    {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.checkable
        control: control
    }
    
    arrow: Maui.Icon
    {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        
        visible: control.subMenu
        //        mirror: control.mirrored
        color: control.icon.color
        height: 10
        width: 10
        source: "qrc:/assets/arrow-right.svg"
    }
    
    contentItem: RowLayout
    {   
        spacing: control.spacing
        Maui.IconLabel
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            spacing: control.spacing
            
            display: control.display
            
            alignment: Qt.AlignLeft
            
            icon: control.showIcon ? control.icon : null
            text: control.text
            font: control.font
            color: control.icon.color
        }
        
        Loader
        {
            active: control.action ? (control.action.shortcut !== undefined && Maui.Handy.hasKeyboard) : false
            asynchronous: true
            visible: active
            
            sourceComponent: Label
            {        
                text: dummyShortcut.nativeText
                opacity: 0.5
                font.pointSize: Maui.Style.fontSizes.small
                color: control.icon.color
                // font.family: Maui.Style.monospacedFont.family
                // color: Maui.Theme.backgroundColor
                // padding: 2
                // background: Rectangle
                // {
                //     color: Maui.Theme.textColor
                //     radius: 2
                // }
            }
        }
        
        Item
        {
            readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
            readonly property real indicatorPadding: control.checkable && control.indicator && control.indicator.visible ? control.indicator.width + control.spacing : 0
            Layout.preferredWidth: indicatorPadding + arrowPadding      
        }
    }
    
    background: Rectangle
    {
        radius: Maui.Style.radiusV
        
        color: setBackgroundColor(control)
        
        Behavior on color
        {
            enabled: !control.flat
            Maui.ColorTransition{}
        }
    }
    
    function setTextColor(control)
    {
        let defaultColor = (color) =>
        {
            return control.down || control.checked ? (Maui.Theme.highlightedTextColor) : color
        }
        
        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {
                case Maui.Controls.Normal: return defaultColor(control.Maui.Theme.textColor)
                case Maui.Controls.Positive: return control.Maui.Theme.positiveTextColor
                case Maui.Controls.Negative: return control.Maui.Theme.negativeTextColor
                case Maui.Controls.Neutral: return control.Maui.Theme.neutralTextColor
            }
        }
        
        return defaultColor(control.Maui.Theme.textColor)
    }
    
    function setBackgroundColor(control)
    {
        let defaultColor = (bg) =>
        {
            return control.pressed || control.down || control.checked ? control.Maui.Theme.highlightColor : (control.highlighted || control.hovered ? control.Maui.Theme.hoverColor : (control.flat
            ?   "transparent" : bg))
        }
        
        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {
                case Maui.Controls.Normal: return defaultColor(control.Maui.Theme.backgroundColor)
                case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
                case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
                case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
            }
        }
        
        if(control.Maui.Controls.level)
        {
            switch(control.Maui.Controls.level)
            {
                case Maui.Controls.Undefined: return defaultColor(control.Maui.Theme.backgroundColor)
                case Maui.Controls.Primary: return defaultColor(control.Maui.Theme.backgroundColor)
                case Maui.Controls.Secondary: return defaultColor(control.Maui.Theme.alternateBackgroundColor)
            }
        }
        
        return defaultColor(control.Maui.Theme.alternateBackgroundColor)
    }
}
