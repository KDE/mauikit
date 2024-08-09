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

import QtQuick.Effects

/**
 * @inherit QtQuick.Controls.ToolButton
 * @brief A button styled to be used "floating" above other elements.
 * 
 *   <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-toolbutton.html">This controls inherits from QQC2 ToolButton, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * 
 * This button has a colorful background and drops a shadow, this is meant to elevate it over the surface and to distinguish it form other elements, since it is meant o be used above other UI elements.
 * 
 * Typically this button is placed on a corner of a pane.
 * By default the button background color is picked from the style accent color, but this can be modify ad set any custom color.
 * @see color
 *  
 *    
 *  @image html Misc/floatingbutton.png
 *  
 * @code
 * Maui.Page
 * {
 *    id: _page
 * 
 *    anchors.fill: parent
 *    Maui.Controls.showCSD: true
 *    Maui.Theme.colorSet: Maui.Theme.Window
 *    headBar.forceCenterMiddleContent: true
 * 
 *    Maui.FloatingButton
 *    {
 *        anchors.right: parent.right
 *        anchors.bottom: parent.bottom
 *        anchors.margins: Maui.Style.space.big
 * 
 *        icon.name: "list-add"
 *    }
 * 
 * }
 * @endcode
 * 
 *   <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/FloatingButton.qml">You can find a more complete example at this link.</a>
 * 
 * 
 */
ToolButton
{
    id: control
    
    padding: Maui.Style.defaultPadding * 2
    
    icon.height: Maui.Style.iconSize
    icon.width: Maui.Style.iconSize
    
    icon.color: Maui.Theme.highlightedTextColor
    
    display: ToolButton.IconOnly
    
    /**
     * @brief The background color of the button.
     * This can be set to any color, but contrast with the icon should be manually adjusted by using the `icon.color` property or checking the current style, to see if it is dark or light. See `Style.styleType === Style.Dark` for example.
     * 
     * By default the color used is the accent color represented by `Theme.highlightColor`
     */
    property color color : control.hovered || control.pressed ? Qt.lighter( Maui.Theme.highlightColor, 1.2) : Maui.Theme.highlightColor
    
    background: Rectangle
    {
        id: _rec
        radius: Maui.Style.radiusV
        color: control.color
    }
    
    layer.enabled: true
    layer.effect: MultiEffect
    {
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: "#80000000"
    }
}
