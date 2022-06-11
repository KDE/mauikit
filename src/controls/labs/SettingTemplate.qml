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

import QtQuick 2.15
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Maui.FlexListItem
{
    id: control
    padding: Math.floor(Maui.Style.space.medium * 1.5)
    Layout.fillWidth: true
    hoverEnabled: !Maui.Handy.isMobile
//    label2.opacity: 0.5
        
    background: Rectangle
    {
        color: control.enabled ? ( control.pressed ? control.Maui.Theme.hoverColor :  Maui.Theme.alternateBackgroundColor) : "transparent"        
        radius: Maui.Style.radiusV

        Behavior on color
        {
            Maui.ColorTransition{}
        }        
    }
    
    onClicked:
    {
        const item = control.content[0]
        if(item.hasOwnProperty("checkable"))
        {
            if(item.checkable)
            {
                //item.checked = !item.checked
                item.toggled()
            }
        }
    }
}
