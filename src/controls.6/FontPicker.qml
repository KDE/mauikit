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
 * @inherit QtQuick.Controls.Control
 * @brief A custom control use to pick a font and its properties.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-control.html">This controls inherits from QQC2 Control, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * @image html Misc/fontpicker.png
 * 
 * The FontPicker controls allows to pick a font and its derived properties - there is an extra option to restrain the listing to only mono-spaced fonts, using the model property `model.onlyMonospaced`. This option is visually exposed in the control with a Switch toggle.
 * 
 * The control includes a section to display a text paragraph using the selected font and its properties. The example text is a text area where more text can be typed.
 * 
 * @code
 * Maui.Page
 * {
 *    id: _page
 * 
 *    anchors.fill: parent
 *    Maui.Controls.showCSD: true
 * 
 *    Maui.FontPicker
 *    {
 *        anchors.fill: parent
 *    }
 * } 
 * @endcode
 * 
 *  <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/FontPicker.qml">You can find a more complete example at this link.</a>
 * 
 */
Control
{
    id: control
    
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    padding: 0
    
    /**
     * @brief The model used to list the fonts. It is exposed to access its internal properties.
     * @see FontPickerModel
     * @property FontPickerModel FontPicker::model
     */
    readonly property alias model : _model
    
    /**
     * @brief The current font picked. 
     * @property font FontPicker::mfont
     */
    property alias mfont : _model.font
    
    spacing: Maui.Style.space.medium
    
    /**
     * @brief Emitted when a new font has been picked or its properties have been modified.
     * @param font The font object of the newly modified font.
     */
    signal fontModified(var font)
    
    Maui.FontPickerModel
    {
        id: _model
    }
    
    contentItem: ColumnLayout
    {
        id: _layout
        spacing: control.spacing
        
        Maui.FlexSectionItem
        {
            label1.text: i18n ("Family")
            label2.text: i18n("Pick the font family.")
            wide: control.width > 600
            
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
        
        Maui.FlexSectionItem
        {
            label1.text: i18n("Style")
            label2.text: i18n("Font style.")
            wide: control.width > 600
            
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
        
        Maui.FlexSectionItem
        {
            label1.text: i18n("Size")
            label2.text: i18n("Font size from recommended values.")
            wide: control.width > 600
            
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
        
        Maui.FlexSectionItem
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
