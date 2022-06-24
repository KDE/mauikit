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


import QtQuick 2.15
import QtQuick.Templates 2.14 as T

import org.mauikit.controls 1.3 as Maui

import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import QtGraphicalEffects 1.0

T.ProgressBar
{
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentItem: ProgressBarImpl 
    {
        implicitHeight: Maui.Style.iconSizes.tiny

        scale: control.mirrored ? -1 : 1
        color: Maui.Theme.highlightColor
        progress: control.position
        indeterminate: control.visible && control.indeterminate
//         radius: Maui.Style.radiusV
        
    }

    background: Rectangle 
    {
        id: bg
        implicitWidth: 200
        implicitHeight: 4
        y: (control.height - height) / 2
        height: Maui.Style.iconSizes.tiny

        color: Maui.Theme.backgroundColor
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        layer.enabled: true
        layer.effect: OpacityMask
        {
            maskSource: Rectangle
            {
                width: bg.width
                height: bg.height
                radius:  Maui.Style.radiusV
            }
        }
    }
}

