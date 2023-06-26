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

T.ItemDelegate
{
    id: control
    opacity: control.enabled ? 1 : 0.5

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight,
                             indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    hoverEnabled: true

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize

    font: Maui.Style.defaultFont

    contentItem: Maui.IconLabel
    {
        text: control.text
        font: control.font
        spacing: control.spacing
        color: control.highlighted || control.checked || (control.pressed && !control.checked && !control.sectionDelegate) ? Maui.Theme.highlightedTextColor : Maui.Theme.textColor
        icon: control.icon
        alignment: Qt.AlignLeft

    }

    background: Rectangle
    {
        color: control.checked || control.pressed ? Maui.Theme.highlightColor : ( control.hovered ? Maui.Theme.hoverColor : "transparent")

        radius: Maui.Style.radiusV

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
