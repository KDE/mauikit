/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */

import QtQuick

import QtQuick.Templates as T
import org.mauikit.controls as Maui

T.ToolBar
{
    id: control

    // default property alias content : _layout.data
    focus: true
    focusPolicy: Qt.NoFocus

    Maui.Theme.colorSet: Maui.Theme.Header
    Maui.Theme.inherit: false

    Maui.Controls.flat: true

    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    implicitWidth: implicitContentWidth + leftPadding + rightPadding

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    font: Maui.Style.defaultFont

    contentItem: Row
    {
        id: _layout
        spacing: control.spacing
    }

    background: Rectangle
    {
        id: _headBarBG
        color: control.Maui.Controls.level ? control.Maui.Controls.level === Maui.Controls.Primary ? Maui.Theme.backgroundColor : Maui.Theme.alternateBackgroundColor : Maui.Theme.backgroundColor

        Behavior on color
        {
            Maui.ColorTransition{}
        }

        clip: true      

        Maui.Separator
        {
            id: _border
            visible: !control.Maui.Controls.flat
            anchors.left: parent.left
            anchors.right: parent.right
            weight: Maui.Separator.Weight.Light
            opacity: 0.4

            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }

        states: [  State
            {
                when: control.position === ToolBar.Header

                AnchorChanges
                {
                    target: _border
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },

            State
            {
                when: control.position === ToolBar.Footer

                AnchorChanges
                {
                    target: _border
                    anchors.top: parent.top
                    anchors.bottom: undefined
                }
            }
        ]
    }
}
