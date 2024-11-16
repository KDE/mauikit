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
import org.mauikit.controls as Maui
/**
 * @inherit org.mauikit.controls.TextField
 * @brief A text field meant to enter passwords.
 *
 *  
 * This control allows to mask the password as it is typed, and also includes a button action to toggle between unmask and masking the password.
 * 
 * @see SearchField
 */
Maui.TextField
{
    id: control
    echoMode: TextInput.Password
    passwordMaskDelay: 300
    inputMethodHints: Qt.ImhNoAutoUppercase

    /**
     * @private
     */
    property int previousEchoMode
    
    icon.source: "lock"    
    
    actions: Action
    {
        icon.name: control.echoMode === TextInput.Normal ? "view-hidden" : "view-visible"
        icon.color: control.color
        onTriggered:
        {
            if(control.echoMode === TextInput.Normal)
            {
                control.echoMode = control.previousEchoMode
            }else
            {
                control.echoMode = TextInput.Normal
            }
        }      
    }    
    
    Component.onCompleted:
    {
       control.previousEchoMode = control.echoMode
    }
}
