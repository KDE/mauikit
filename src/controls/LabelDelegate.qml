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

import QtQuick 2.14
import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui

import QtQuick.Templates 2.15 as T

/**
 * LabelDelegate
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Control
{
    id: control
    Maui.Theme.backgroundColor: isSection ? "transparent" : (index % 2 === 0 ? Qt.darker(Maui.Theme.backgroundColor) : "transparent")
    implicitHeight: Maui.Style.rowHeight + topPadding + bottomPadding
    
    
    focusPolicy: Qt.NoFocus
    hoverEnabled: false
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.defaultSpacing
    
    //   highlighted:  ListView.isCurrentItem
    /**
   * isCurrentListItem : bool
   */
    //property alias isCurrentListItem : control.highlighted

    /**
   * isSection : bool
   */
    property bool isSection : false

    /**
   * label : string
   */
    property alias label: labelTxt.text

    /**
   * labelTxt : Label
   */
    property alias labelTxt : labelTxt
    
    property alias color :labelTxt.color

    background: Item{}

    contentItem: MouseArea
    {
        propagateComposedEvents: true
        preventStealing: false
//        onPressed: mouse.accepted= false

        Label
        {
            anchors.fill: parent
            id: labelTxt
            font: control.isSection ? Maui.Style.h2Font : Maui.Style.defaultFont
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            text: labelTxt.text
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
            color: control.isCurrentListItem ? control.Maui.Theme.highlightedTextColor : control.Maui.Theme.textColor
        }
    }
}
