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

/*!
\since org.mauikit.controls 1.0
\inqmlmodule org.mauikit.controls
\brief Badge to show a counter or an icon as a notification hint.
*/
Control
{
    id: control

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary

    /*!
      Size of the badge. Can be used as width and height, unless the implicitWidth is wider.
    */
    property int size: Maui.Style.iconSizes.small

    font.weight: Font.Bold
    font.bold: true
    font.pointSize: Maui.Style.fontSizes.small

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding

    padding: Maui.Style.space.tiny

    property alias icon : _dummyButton.icon
    property alias text : _dummyButton.text

    AbstractButton
    {
        id: _dummyButton
        visible: false
        icon.color: Maui.Theme.textColor
        icon.width: size
        icon.height: size
    }

    background: Rectangle
    {
        radius: Math.min(width, height)
        color: Maui.Theme.backgroundColor
        border.color: Maui.Theme.textColor

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    contentItem: Maui.IconLabel
    {
        text: control.text
        font: control.font
        icon: control.icon
        color: control.icon.color
        spacing: control.spacing
        alignment: Qt.AlignHCenter
    }
}
