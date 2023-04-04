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


Control
{
    id: control
 
 implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
 padding: 0
 
 property alias model : _model
 property alias mfont : _model.font   
 
 spacing: Maui.Style.space.medium
 
 signal fontModified(var font)
 
 Maui.FontPickerModel
 {
     id: _model
 }
 
 contentItem: ColumnLayout
 {
     id: _layout
     spacing: control.spacing
 Maui.SectionItem
 {
     label1.text: i18n ("Family")
     label2.text: i18n("Pick the font family.")
     columns: 1
     
     Maui.FontsComboBox
     {
         Layout.fillWidth: true
         Component.onCompleted: currentIndex = find(control.mfont.family, Qt.MatchExactly)
         model: _model.fontsModel
         
         onActivated:
         {
             let newFont = control.mfont
             newFont.family = currentText           
             
             control.mfont = newFont
             control.fontModified(control.mfont)
         }
     }
     
 }
 
 Maui.SectionItem
 {
     label1.text: i18n("Style")
     label2.text: i18n("Font style.")
     columns: 1
     ComboBox
     {
         Layout.fillWidth: true
         model: _model.styles
         Component.onCompleted: currentIndex = find(control.mfont.styleName, Qt.MatchExactly)
         icon.source: "format-text-color"
         onActivated:
         {
             control.mfont.styleName = currentText
             control.fontModified(control.mfont)             
         }
     }
 }
 
 Maui.SectionItem
 {
     label1.text: i18n("Size")
     label2.text: i18n("Font size from recommended values.")
     columns: 1
     ComboBox
     {
         Layout.fillWidth: true
         model: _model.sizes
         Component.onCompleted: currentIndex = find(control.mfont.pointSize, Qt.MatchExactly)
         icon.source: "font-size-down"
         onActivated:
         {
             control.mfont.pointSize = currentText
             control.fontModified(control.mfont)             
         }
     }
 }
 
 Maui.SectionItem
 {
     label1.text: i18n("Monospaced Fonts")
     label2.text: i18n("Display only monospaced fonts.")
     
     Switch
     {
         checked: control.model.onlyMonospaced
         onToggled: control.model.onlyMonospaced = !control.model.onlyMonospaced
     }
 }
 
 Maui.SectionItem
 {
     label1.text: i18n("Preview")
     label2.text: i18n("Test the font.")
     columns: 1     
     
     TextArea
     {
         Layout.fillWidth: true
         implicitHeight: contentHeight + topPadding + bottomPadding
         
         text: i18n("The Quick Brown Fox Jumps Over The Lazy Dog")
         font: control.mfont
     }
 }
 }
}
