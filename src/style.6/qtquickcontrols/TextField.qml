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

import org.mauikit.controls as Maui

import QtQuick.Templates as T

/**
 * TextField
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.TextField
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false

    hoverEnabled: !Maui.Handy.isMobile

    opacity: control.enabled ? 1 : 0.5

    color: Maui.Theme.textColor
    selectionColor: Maui.Theme.highlightColor
    selectedTextColor: Maui.Theme.highlightedTextColor
    focus: true

    implicitHeight: implicitBackgroundHeight + topPadding + bottomPadding
    implicitWidth: 200

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignLeft

    padding: Maui.Style.defaultPadding

    selectByMouse: !Maui.Handy.isMobile
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    persistentSelection: true
    font: Maui.Style.defaultFont

    wrapMode: TextInput.NoWrap

    background: Rectangle
    {
        implicitHeight: Maui.Style.iconSize
        color: control.enabled ? (control.hovered ? Maui.Theme.hoverColor :  Maui.Theme.backgroundColor) : "transparent"

        radius: Maui.Style.radiusV

        Label
        {
            id: placeholder
            anchors.fill: parent
            anchors.leftMargin: control.leftPadding
            text: control.placeholderText
            font: control.font
            color: control.color
            verticalAlignment: control.verticalAlignment
            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            visible: opacity > 0
            opacity: !control.length && !control.preeditText && !control.activeFocus ? 0.5 : 0

            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Behavior on color
        {
            Maui.ColorTransition{}
        }

        Behavior on border.color
        {
            Maui.ColorTransition{}
        }

        border.color: statusColor(control)

        function statusColor(control)
        {
            if(control.Maui.Controls.status)
            {
                switch(control.Maui.Controls.status)
                {
                case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
                case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
                case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
                case Maui.Controls.Normal:
                default:
                    return "transparent"
                }
            }

            return "transparent"
        }
    }
}
