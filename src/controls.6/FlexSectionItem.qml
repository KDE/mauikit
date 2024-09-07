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
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 * @inherit FlexListItem
 * @since org.mauikit.controls
 * @brief An item used for holding information in a responsive layout.
 * This control inherits from MauiKit FlexListItem, to checkout its inherited properties refer to the docs.
 * 
 *  @note There is also the SectionItem, which uses a static column layout for positioning its content.
 * @see FlexSectionItem
 * 
 * This control is a wrapper around the FlexListItem, with some added functionality.
 * 
 * @image html Misc/flexsectionitem.png "Demo of a flex section being wrapped"
 * 
 * @note If the first and single child element of this control is `checkable`, then the state of such control will be toggled by clicking on the area of the FlexSectionItem.
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/FlexSectionItem.qml">You can find a more complete example at this link.</a> 
 */
Maui.FlexListItem
{
    id: control
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    Layout.fillWidth: true
    hoverEnabled: !Maui.Handy.isMobile
    
    /**
     * @brief Whether the control should be styled as flat, as in not having a background or hover/pressed visual effect hints.
     * By default this is set to `!Handy.isMobile`
     * @see Handy::isMobile
     */
    property bool flat : !Maui.Handy.isMobile
    
    /**
     * @brief Whether the first children element from the `content` is checkable. 
     * If it is the the control will have a hover effct to hint about the item being checkable.
     */ 
    readonly property bool childCheckable : control.content.length === 1 && control.content[0].hasOwnProperty("checkable") ? control.content[0].checkable : false
    
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
    
    onClicked:
    {
        if(control.childCheckable)
        {
            control.content[0].toggled()
        }        
    }
}
