/*
 *   Copyright 2020 Camilo Higuita <milo.h@aol.com>
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


//this basic toolbutton provides a basic anima

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

T.ToolButton
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    spacing: Maui.Style.space.small
    
    padding: Maui.Style.space.small
    rightPadding: padding
    leftPadding: padding
    topPadding: padding
    bottomPadding: padding
    
//     property bool flat : false
    
    /**
     * 
     */
    property alias extraContent : _layoutButton.data
    
    /**
     * 
     */
    readonly property alias label : _label
    
    /**
     * 
     */
    readonly property alias kicon : _icon
    
    /**
     * 
     */
    property alias rec : _background
    
    //    Maui.Theme.inherit: false
    //    Maui.Theme.colorSet: Maui.Theme.Button
    
    focusPolicy: Qt.NoFocus
    
    hoverEnabled: !Maui.Handy.isMobile
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
         
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
    
    icon.color: ((control.checked || control.pressed) ? (control.flat ? Maui.Theme.highlightColor : Maui.Theme.highlightedTextColor) : control.Maui.Theme.textColor)
    
    opacity: enabled ? 1 : 0.5
    
    background: Rectangle
    {
        id: _background
        
        visible: !control.flat
        radius: Maui.Style.radiusV
        color: control.down || control.checked || control.pressed ? control.Maui.Theme.highlightColor : (control.hovered ? control.Maui.Theme.hoverColor : "transparent")
        //         border.color:  checked ?  control.Maui.Theme.highlightColor : "transparent"
        Behavior on color
        {
             Maui.ColorTransition{}
        }
    }
    
    contentItem: GridLayout
    {
        id: _layoutButton
        rowSpacing: control.spacing
        columnSpacing: control.spacing
        
        Item
        {
            implicitWidth: control.icon.width
            implicitHeight: control.icon.height
            Layout.fillHeight: true
            
            Layout.column: 0
            Layout.row: 0
            Layout.alignment: Qt.AlignCenter
            
            visible: _icon.source && _icon.source.length && (control.display === ToolButton.TextBesideIcon || control.display === ToolButton.TextUnderIcon || control.display === ToolButton.IconOnly)
            
            Kirigami.Icon
            {
                id: _icon
                height: control.icon.height
                width: control.icon.width
                anchors.centerIn: parent
                
                color: control.icon.color
                
                source: control.icon.name
                isMask: true
                
//                 Behavior on height
//                 {
//                     NumberAnimation
//                     {
//                         duration: Maui.Style.units.shortDuration
//                         easing.type: Easing.InQuad
//                     }
//                 }
//                 
//                 Behavior on width
//                 {
//                     NumberAnimation
//                     {
//                         duration: Maui.Style.units.shortDuration
//                         easing.type: Easing.InQuad
//                     }
//                 }

                Behavior on color
                {
                    Maui.ColorTransition{}
                }
            }
        }
        
        Label
        {
            id: _label
            Layout.column: control.display === ToolButton.TextUnderIcon? 0 : 1
            Layout.row: control.display === ToolButton.TextUnderIcon ? 1 : 0
            text: control.text
            visible: text.length && (control.display === ToolButton.TextOnly || control.display === ToolButton.TextBesideIcon || control.display === ToolButton.TextUnderIcon || !_icon.visible)
            opacity: visible ? ( enabled ? 1 : 0.5) : 0
            horizontalAlignment: Qt.AlignHCenter
            Layout.fillWidth: visible
            Layout.preferredWidth: visible ? implicitWidth : 0
            color: control.icon.color
            font.pointSize: control.display === ToolButton.TextUnderIcon ? Maui.Style.fontSizes.small : Maui.Style.fontSizes.medium
            
            Behavior on Layout.preferredWidth
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.shortDuration
                    easing.type: Easing.InQuad
                }
            }
            
            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.shortDuration
                    easing.type: Easing.InQuad
                }
            }
        }
    }
    
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: ( control.hovered ) && control.text.length && (control.display === ToolButton.IconOnly ? true : !checked)
    ToolTip.text: control.text
}
