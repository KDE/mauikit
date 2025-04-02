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
import QtQuick.Effects

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.Control
 *    @since org.mauikit.controls 1.0
 *    @brief A Badge item to display text - as a counter - or an icon as a notification hint.
 *
 *    <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-control.html">This controls inherits from QQC2 Control, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 *    @image html Badge/badges.png "Badges with different sizes and colors"
 *
 *    @code
 *    Button
 *    {
 *        text: "Example1"
 *
 *        Maui.Badge
 *        {
 *            icon.name: "actor"
 *            color: Maui.Theme.neutralBackgroundColor
 *            anchors.horizontalCenter: parent.right
 *            anchors.verticalCenter: parent.top
 *        }
 *    }
 *    @endcode
 *
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/Badge.qml">You can find a more complete example at this link.</a>
 *
 */
AbstractButton
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
     * @brief The color for the background of the badge
     */
    property color color: setBackgroundColor(control)
    
    /**
     * Display or not a drop shadow.
     */
property bool flat : false
    icon.color: setTextColor(control)

    font.weight: Font.Bold
    font.bold: true
    font.pointSize: Maui.Style.fontSizes.tiny

    implicitWidth: Math.max(implicitHeight, _layout.implicitWidth + leftPadding + rightPadding)
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    padding: Maui.Style.space.small

    background: Rectangle
    {
        id: _bg
        visible: !_bgEffect.visible 
        radius: Math.min(width, height)
        color: control.color
        border.color: Qt.lighter(control.color)

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    MultiEffect
    {
        id: _bgEffect
        visible: GraphicsInfo.api !== GraphicsInfo.Software && !control.flat
        source: _bg
        anchors.fill: _bg
        shadowColor: "#80000000"
        shadowEnabled: true
        autoPaddingEnabled: true
        shadowVerticalOffset: 3
        shadowHorizontalOffset: -2
        shadowBlur: 0.5
    }

    contentItem: Maui.IconLabel
    {
        id: _layout
        z: 2
        text: control.text
        font: control.font
        icon: control.icon
        color: control.icon.color
        spacing: control.spacing
        alignment: Qt.AlignHCenter
    }

    function setTextColor(control)
    {
        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {
            case Maui.Controls.Normal: return control.Maui.Theme.textColor
            case Maui.Controls.Positive: return control.Maui.Theme.positiveTextColor
            case Maui.Controls.Negative: return control.Maui.Theme.negativeTextColor
            case Maui.Controls.Neutral: return control.Maui.Theme.neutralTextColor
            }
        }

        return control.Maui.Theme.textColor
    }

    function setBackgroundColor(control)
    {
        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {
            case Maui.Controls.Normal: return control.Maui.Theme.backgroundColor
            case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
            case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
            case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
            }
        }

        return control.Maui.Theme.backgroundColor
    }
}
