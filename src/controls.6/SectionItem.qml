/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls 1.3 as Maui

/**
 @since org.*mauikit.controls.labs 1.0
 
 
 */
ItemDelegate
{
    id: control
   
   padding: Maui.Style.defaultPadding
   spacing: Maui.Style.space.small
   
   Layout.fillWidth: true
       implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

       /**
      * @brief The items declared as the children of this element will wrap into a new line on constrained spaces. 
      * @note The content is handled by a RowLayout, so to position items use the Layout attached properties.
      * @property list<QtObject> FlexListItem::content
      */
     default property alias content : _layout.data
         
             /**
      * @brief An alias to the template element handling the information labels and image/icon. 
      * @see ListItemTemplate
      * @property ListItemTemplate FlexListItem::template
      */
    property alias template: _template
    
    /**
      * @brief The Label element for the title. 
      * @property Label FlexListItem::label1
      */
    property alias label1 : _template.label1

    /**
      * @brief The Label element for the message body. 
      * @property Label FlexListItem::label2
      */
    property alias label2 : _template.label2

    /**
      * @brief The Label element for extra information positioned on the right top side.. 
      * @property Label FlexListItem::label3
      */
    property alias label3 : _template.label3

    /**
      * @brief The Label element for extra information positioned on the right bottom side.. 
      * @property Label FlexListItem::label4
      */
    property alias label4 : _template.label4

    /**
      * @brief The icon name to be used in the information section.
      * @property string FlexListItem::iconSource
      */
    property alias iconSource : _template.iconSource

    /**
      * @brief The image source file to be used in the information section.
      * @property url FlexListItem::imageSource
      */
    property alias imageSource : _template.imageSource

    /**
      * @brief The size hint for the icon container.
      * @property int FlexListItem::iconSizeHint
      */
    property alias iconSizeHint : _template.iconSizeHint
    
   property bool flat : !Maui.Handy.isMobile
   
    hoverEnabled: !Maui.Handy.isMobile
    
    background: Rectangle
    {       
        color: control.enabled ? ( control.childCheckable && control.hovered ? Maui.Theme.hoverColor : (control.flat ? "transparent" : Maui.Theme.alternateBackgroundColor)) : "transparent"        
        radius: Maui.Style.radiusV   
        
        Behavior on color
        {
            enabled: !control.flat
            Maui.ColorTransition{}
        }
    }
    
      contentItem: ColumnLayout
    {
        id: _layout
        
        spacing: control.spacing
        
        Maui.ListItemTemplate
        {
            id: _template
            Layout.fillWidth: true
            iconSizeHint: Maui.Style.iconSizes.medium
            label2.wrapMode: Text.WordWrap
            label1.font.weight: Font.Medium
        }
    }
}
