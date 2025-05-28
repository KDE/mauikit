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

import QtQuick.Effects

/**
 * Popup
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Popup
{
    id: control

    parent: T.Overlay.overlay
    Maui.Theme.colorSet: Maui.Theme.View

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    anchors.centerIn: parent

    modal: true
    padding: 0
    clip: false

    background: Rectangle
    {
        color: control.Maui.Theme.backgroundColor

        radius: control.Maui.Controls.flat ? 0 : Maui.Style.radiusV
        // property color borderColor: Maui.Theme.textColor
        // border.color: Maui.Style.trueBlack ? Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3) : undefined
        layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software && !control.Maui.Controls.flat
        layer.effect: MultiEffect
        {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: "#80000000"
        }

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
