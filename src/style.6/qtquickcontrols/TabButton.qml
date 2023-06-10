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
import QtQml.Models
import QtQuick.Templates as T
import org.mauikit.controls  as Maui

T.TabButton
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false

    opacity: enabled ? 1 : 0.5

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding

    hoverEnabled: !Maui.Handy.isMobile

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    font: Maui.Style.defaultFont

    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize

    contentItem: Maui.IconLabel
    {
        text: control.text
        font: control.font
        icon: control.icon
        color: Maui.Theme.textColor
        spacing: control.spacing
        display: control.display
        alignment: Qt.AlignHCenter
    }

    background: Rectangle
    {
        color: control.checked ? Maui.Theme.backgroundColor : (control.hovered || control.pressed ? Maui.Theme.hoverColor : "transparent")
        radius: Maui.Style.radiusV
    }
}
