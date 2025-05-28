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

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Item
 * @brief A icon and a label put together in two possible positions, a horizontal or vertical layout.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This control inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a> 
 * 
 * This is a base template for other controls, such as for setting the contents of the ToolButton, Button, MenuItem, etc, in the style.
 *  
 * @note This control is only a visual item, and does not handle any event or gets any focus.
 *  
 * @image html Misc/iconlabel.png
 *  
 * @code
 * ColumnLayout
 * {
 *    anchors.centerIn: parent
 *    spacing: Maui.Style.space.big
 * 
 *    Maui.IconLabel
 *    {
 *        icon: ({name: "folder", height: "22", width: "22", color: "yellow"})
 *        text: "Testing"
 *        display: ToolButton.TextBesideIcon
 *        alignment: Qt.AlignLeft
 *        color: "yellow"
 *    }
 * 
 *    Maui.IconLabel
 *    {
 *        icon: ({name: "vvave", height: "64", width: "64"})
 *        text: "Vvave"
 *        display: ToolButton.TextUnderIcon
 *        alignment: Qt.AlignHCenter
 *    }
 * }
 * @endcode
 * 
 * @warning To set the `icon` properties, you need to set it as a dictionary map. The supported key values are:
 * - name
 * - source
 * - color
 * - height
 * - width
 * - cache
 * @see icon 
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/IconLabel.qml">You can find a more complete example at this link.</a>
 */
Item
{
    id: control
    
    focus: false
    
    implicitWidth: _layoutButton.implicitWidth + leftPadding + rightPadding
    implicitHeight: _layoutButton.implicitHeight + topPadding + bottomPadding
    
    /**
     * @brief The color for the text. 
     * By default this is set to `Theme.textColor`.
     * @note to set the icon color, use the `icon.color` property.
     * @property color IconLabel::color
     */
    property alias color : _label.color
    
    /**
     * @brief The text to be used.
     * @property string IconLabel::text
     */
    property alias text : _label.text
    
    /**
     * @brief This is a dictionary, which represents the properties for the icon. 
     * The supported key values are:
     * - name
     * - source
     * - color
     * - height
     * - width
     * - cache
     * 
     * @code
     * Maui.IconLabel
     * {
     *  icon: ({name: "folder", height: "22", width: "22", color: "yellow"})
     * }
     * @endcode
     * 
     */
    property var icon 
    
    /**
     * @brief How to display the icon and the label. 
     * The available options are:
     * - ToolButton.TextBesidesIcon
     * - ToolButton.TextUnderIcon
     * - ToolButton.TextOnly
     * - ToolButton.IconOnly
     * 
     * By default this is set to `ToolButton.IconOnly`
     */
    property int display : ToolButton.IconOnly
    
    /**
     * @brief The preferred horizontal alignment of the text.
     * By default this is set to `Qt.AlignLeft`.
     * @note The alignment will depend on the width of the container. If there is a width bigger then the implicit width, then the alignment will be set as preferred.
     * @property enum IconLabel::alignment
     */
    property alias alignment : _label.horizontalAlignment
    
    // font.pointSize: control.display === ToolButton.TextUnderIcon ? Maui.Style.fontSizes.small : Maui.Style.fontSizes.medium            
    
    /**
     * @brief The total padding all around the element.
     * By default this is set to `0`.
     */
    property int padding : 0
    
    /**
     * @brief Left padding. 
     * By default this is set to `padding`
     */
    property int leftPadding: padding
    
    /**
     * @brief Right padding. 
     * By default this is set to `padding`
     */
    property int rightPadding: padding
    
    /**
     * @brief Bottom padding. 
     * By default this is set to `padding`
     */
    property int bottomPadding: padding
    
    /**
     * @brief Top padding. 
     * By default this is set to `padding`
     */
    property int topPadding: padding
    
    /**
     * @brief The spacing value between the icon element and the text label.
     * By default this is set to `Style.space.small`.
     * @see Style
     */
    property int spacing: Maui.Style.space.small
    
    /**
     * @brief The font properties of the text.
     * By default this is set to `Style.defaultFont`.
     * @property font IconLabel::font
     */
    property alias font : _label.font
    
    /**
     * @brief An alias tot he QQC2 Label handling the text.
     * Exposed for fine tuning the label properties.
     * @property Label IconLabel::label
     */
    property alias label : _label

    GridLayout
    {
        id: _layoutButton
        
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
            
            implicitHeight: visible && control.icon ? control.icon.height : -control.spacing
            implicitWidth: visible && control.icon ? control.icon.width : -control.spacing
            
            Layout.alignment: Qt.AlignCenter
            
            visible: String(_icon.source).length > 0 && (control.display !== ToolButton.TextOnly)        
            
            color: control.icon ? control.icon.color : control.color       
            source: control.icon ? control.icon.name || control.icon.source : ""   
        }    
        
        Label
        {
            id: _label
            
            visible: text.length && (control.display === ToolButton.TextOnly || control.display === ToolButton.TextBesideIcon || control.display === ToolButton.TextUnderIcon || !_icon.visible)
            
            opacity: visible ? ( enabled ? 1 : 0.5) : 0
            
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter

            Layout.fillWidth: true
            
            color: control.Maui.Theme.textColor
            font:  Maui.Style.defaultFont
            
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
