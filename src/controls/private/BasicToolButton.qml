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

import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

ToolButton
{
    id: control
        
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
    
    
    //    Maui.Theme.inherit: false
    //    Maui.Theme.colorSet: Maui.Theme.Button
    
    focusPolicy: Qt.NoFocus
                
    contentItem: GridLayout
    {
        id: _layoutButton
        rowSpacing: control.spacing
        columnSpacing: control.spacing
        
       
            Maui.Icon
            {
                id: _icon
                height: control.icon.height
                width: control.icon.width
               
               
               Layout.column: 0
               Layout.row: 0
               Layout.alignment: Qt.AlignCenter
               
               visible: _icon.source && _icon.source.length && (control.display === ToolButton.TextBesideIcon || control.display === ToolButton.TextUnderIcon || control.display === ToolButton.IconOnly)
               
                
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
    
}
