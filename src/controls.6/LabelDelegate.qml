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
 * @inherit QtQuick.Controls.Control
 * @brief A basic MauiKit delegate for displaying a text label with an icon in a horizontal layout.
 * 
 * @warning This item is not interactive and is meant to be use as an information label. Not press events are handled.
 * For a similar interactive delegate checkout ListDelegate.
 * @see ListDelegate
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-itemdelegate.html">This controls inherits from QQC2 ItemDelegate, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * @image html Misc/labeldelegate.png
 * 
 * @code
 * Column
 * {
 *    width: Math.min(600, parent.width)
 *    anchors.centerIn: parent
 * 
 *    Maui.LabelDelegate
 *    {
 *        width: parent.width
 *        text: "Hola!"
 *        icon.name: "love"
 *    }
 * 
 *    Maui.LabelDelegate
 *    {
 *        width: parent.width
 *        text: "Section Header"
 *        icon.name: "anchor"
 *        isSection: true
 *    }
 * 
 * 
 *    Maui.LabelDelegate
 *    {
 *        width: parent.width
 *        text: "Regular label thingy."
 *    }
 * 
 *    Maui.LabelDelegate
 *    {
 *        width: parent.width
 *        text: "Hola!"
 *        icon.name: "folder"
 *    }
 * }
 * @endcode
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/LabelDelegate.qml">You can find a more complete example at this link.</a>
 * 
 */
Control
{
    id: control
    
    implicitHeight: Maui.Style.rowHeight + topPadding + bottomPadding
    
    focusPolicy: Qt.NoFocus
    hoverEnabled: false
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.defaultSpacing
    
    /**
     * @brief Whether the label should be styled as a section header.
     * @see SectionHeader
     * By default this is set to `false`.
     */
    property bool isSection : false
    
    /**
     * @see IconLabel::label 
     */
    property alias label: _labelTxt.label
    
    /**
     * @see IconLabel::color
     */
    property alias color: _labelTxt.color
    
    /**
     * @brief The group icon properties, to set the icon name, source, and size.
     */
    property alias icon : _dummyButton.icon
    
    /**
     * @see IconLabel::text
     */
    property alias text : _labelTxt.text
    
    /**
     * @brief An alias to the IconLabel control handling the information.
     * @see IconLabel for properties.
     * @property IconLabel LabelDelegate::template
     */
    property alias template : _labelTxt
    
    background: Item{}
    
    AbstractButton
    {
        id: _dummyButton
        visible: false
        icon.height: Maui.Style.iconSize
        icon.width: Maui.Style.iconSize
        icon.color: control.color
    }
    
    contentItem: MouseArea
    {
        propagateComposedEvents: true
        preventStealing: false
        //        onPressed: mouse.accepted= false
        
        Maui.IconLabel
        {
            id: _labelTxt
            
            anchors.fill: parent
            
            display: ToolButton.TextBesideIcon
            icon: control.icon
            font: control.isSection ? Maui.Style.h2Font : Maui.Style.defaultFont
            
            alignment: Qt.AlignLeft
            
            text: control.text
            color: control.isCurrentListItem ? control.Maui.Theme.highlightedTextColor : control.Maui.Theme.textColor
        }
    }
}
