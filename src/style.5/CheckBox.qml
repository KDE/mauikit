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


import QtQuick 2.6
import QtQuick.Templates 2.3 as T
import QtQuick.Controls 2.3
import org.mauikit.controls 1.3 as Maui

import "private"

T.CheckBox 
{
    id: controlRoot
    opacity: enabled ? 1 : 0.5
    
    implicitWidth: Math.max(contentItem.implicitWidth, indicator ? indicator.implicitWidth : 0) + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight, indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding

    padding: 0
    spacing: Maui.Style.space.small  
    
    hoverEnabled: true

    indicator: CheckIndicator
    {
        x: controlRoot.text ? (controlRoot.mirrored ? controlRoot.width - width - controlRoot.rightPadding : controlRoot.leftPadding) : controlRoot.leftPadding + (controlRoot.availableWidth - width) / 2
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2
        control: controlRoot
    }

    contentItem: Label
    {
        leftPadding: controlRoot.indicator && !controlRoot.mirrored ? controlRoot.indicator.width + controlRoot.spacing : 0
        rightPadding: controlRoot.indicator && controlRoot.mirrored ? controlRoot.indicator.width + controlRoot.spacing : 0
        text: controlRoot.text
        font: controlRoot.font
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
    
    background: null
}
