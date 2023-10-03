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

import org.mauikit.controls 1.3 as Maui

/**
    @since org.mauikit.controls 1.0
    @brief A Badge item to display text - as a counter - or an icon as a notification hint.

    <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-control.html">This controls inherits from QQC2 Control, to checkout its inherited properties refer to the Qt Docs.</a>

    @image html Badge/badges.png
    @note A set of badges with different sizes and colors, and using text or icons.

    @code
    Button
    {
        text: "Example1"

        Maui.Badge
        {
            icon.name: "actor"
            color: Maui.Theme.neutralBackgroundColor
            anchors.horizontalCenter: parent.right
            anchors.verticalCenter: parent.top
        }
    }
    @endcode

    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/Badge.qml">You can find a more complete example at this link.</a>

*/
Control
{
    id: control

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary

    /**
     * @brief Size of the badge. Used as width and height, unless the `implicitWidth` is wider.
     * It is also used as the icon size doimentions.
     * By default is set to `Style.iconSizes.small`
    */
    property int size: Maui.Style.iconSizes.small

    /**
     * @brief The icon group property. Exposed to define the icon name, color, and width and height.
     * To know more about it you can check the QQC2 icon property.
     */
    property alias icon : _dummyButton.icon
    
    /**
     * @brief The text to be used in the label.
     * Consider using short text, as this is meant to work as a notification hint.
     */
    property alias text : _dummyButton.text
    
    /**
     * @brief The color for the background of the badge
     */
    property color color:  Maui.Theme.backgroundColor
    
    font.weight: Font.Bold
    font.bold: true
    font.pointSize: Maui.Style.fontSizes.small

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding

    padding: Maui.Style.space.tiny

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
        color: control.color
        border.color: Qt.lighter(control.color)

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
