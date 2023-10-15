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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit SettingsDialog
 * @brief The Mauikit FontPicker component wrapped inside a popup dialog for convenience.
 * @see FontPicker
 * 
 *  This controls inherits from MauiKit SettingsDialog, to checkout its inherited properties refer to docs.
 *  
 *  The control has two `actions` predefined: accept and reject/cancel. 
 *  The cancel action discards changes and closes the dialog, while the accept one emits the `accepted(var font)` signal with the modified font as the argument.
 *  @see accepted 
 *  
 * @image html Misc/fontpickerdialog.png
 *     
 * @code     
 * Maui.Page
 * {
 *    anchors.fill: parent
 *    Maui.Controls.showCSD: true
 * 
 *    Button
 *    {
 *        anchors.centerIn: parent
 *        text: "Font Picker"
 *        onClicked: _fontPickerDialog.open()
 *    }
 * 
 *    Maui.FontPickerDialog
 *    {
 *        id: _fontPickerDialog
 *    }
 * }     
 * @endcode
 * 
 *  <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/FontPickerDialog.qml">You can find a more complete example at this link.</a>
 *  
 */ 
Maui.SettingsDialog
{
    id: control
    
    /**
     * @brief The current font object selected.
     * @property font FontPickerDialog::mfont
     */
    property alias mfont : _picker.mfont   
    
    /**
     * @brief An alias to expose the font picker model and its properties.
     * @see FontModel
     * @property FontModel FontPickerDialog::model
     */
    readonly property alias model : _picker.model
    
    title: i18n("Fonts")
    
    /**
     * @brief Emitted when the accepted action/button is triggered.
     * @param font The modified font object.
     */
    signal accepted(var font)
    
    FontPicker
    {
        id: _picker
        Layout.fillWidth: true
    }
    
    actions: [        
    Action
    {
        text: i18n("Cancel")
        
        onTriggered:
        {
            control.close()
        }
    },
    
    Action
    {
        text: i18n("Accept")
        onTriggered: 
        {
            control.accepted(_picker.mfont)
        }            
    }        
    ]   
    
}
