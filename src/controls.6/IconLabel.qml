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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 @brief
 */
Item
{
    id: control
    
    implicitWidth: _layoutButton.implicitWidth + leftPadding + rightPadding
    implicitHeight: _layoutButton.implicitHeight + topPadding + bottomPadding
    
    property color color 
    property string text
    property var icon 
    property int display : ToolButton.IconOnly
    property int alignment : Qt.AlignLeft
    
    // font.pointSize: control.display === ToolButton.TextUnderIcon ? Maui.Style.fontSizes.small : Maui.Style.fontSizes.medium            
    
    property int padding : 0
    property int leftPadding: padding
    property int rightPadding: padding
    property int bottomPadding: padding
    property int topPadding: padding
    
    property int spacing: Maui.Style.space.small
    property font font : Maui.Style.defaultFont
    
GridLayout
{
    id: _layoutButton
    
//     width: control.width 
//     height: control.height
//     
//     x: control.leftPadding
//     y: control.topPadding
    
    anchors.fill: parent
    anchors.leftMargin: control.leftPadding
    anchors.rightMargin: control.rightPadding
    anchors.bottomMargin: control.bottomPadding
    anchors.topMargin: control.topPadding
    
    rowSpacing: control.spacing
    columnSpacing: control.spacing
        
        columns: control.display === ToolButton.TextUnderIcon ? 1 : 2
        
    Maui.Icon
    {
        id: _icon
        
        implicitHeight: visible && control.icon ? control.icon.height : 0
        implicitWidth: visible && control.icon ? control.icon.width : 0
      
        Layout.alignment: Qt.AlignCenter
        
        visible: String(_icon.source).length > 0 && (control.display !== ToolButton.TextOnly)        
        
        color: control.icon ? control.icon.color : control.color       
        source: control.icon ? control.icon.name || control.icon.source : ""        
    }    
    
    Label
    {
        id: _label
       
        text: control.text
        
        visible: text.length && (control.display === ToolButton.TextOnly || control.display === ToolButton.TextBesideIcon || control.display === ToolButton.TextUnderIcon || !_icon.visible)
        
        opacity: visible ? ( enabled ? 1 : 0.5) : 0
        
        horizontalAlignment: control.alignment
        
        Layout.fillWidth: true
        // Layout.preferredWidth: implicitWidth 
        
        color: control.color
        font: control.font
        
        elide: Text.ElideRight
        wrapMode: Text.NoWrap
        
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
