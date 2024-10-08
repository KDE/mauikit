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


import QtQuick 2.5
import QtQuick.Templates 2.3 as T

import org.mauikit.controls as Maui

import "private"

T.SwitchDelegate 
{
    id: controlRoot

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    hoverEnabled: true

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.defaultSpacing
    rightPadding: 20

    contentItem: Label {
        leftPadding: controlRoot.mirrored ? (controlRoot.indicator ? controlRoot.indicator.width : 0) + controlRoot.spacing : 0
        rightPadding: !controlRoot.mirrored ? (controlRoot.indicator ? controlRoot.indicator.width : 0) + controlRoot.spacing : 0

        text: controlRoot.text
        font: controlRoot.font
        color: (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate) ? Maui.Theme.highlightedTextColor : Maui.Theme.textColor
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: SwitchIndicator {
        x: controlRoot.mirrored ? controlRoot.leftPadding : controlRoot.width - width - controlRoot.rightPadding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2

        control: controlRoot
    }

    background: DefaultListItemBackground {}
}
