/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.3 as T
import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.0 as Maui

T.ToolButton
{
    id: control
    Kirigami.Theme.colorSet: flat ? Kirigami.Theme.Window : Kirigami.Theme.Button
    Kirigami.Theme.inherit: flat
    opacity: enabled ? 1 : 0.5

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
//    baselineOffset: contentItem.y + contentItem.baselineOffset

    hoverEnabled: !Kirigami.Settings.isMobile

    spacing: Maui.Style.space.small

    padding: Maui.Style.space.small
    rightPadding: padding
    leftPadding: padding
    topPadding: padding
    bottomPadding: padding
    
    icon.width: Maui.Style.iconSizes.medium
    icon.height: Maui.Style.iconSizes.medium
    
    icon.color: control.down || control.checked || control.highlighted || control.hovered ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    
    flat: control.parent === T.ToolBar

    font.pointSize: control.display === ToolButton.TextUnderIcon ? Maui.Style.fontSizes.small : undefined

    contentItem: IconLabel
    {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font
        color: control.icon.color

        Behavior on color
        {
            ColorAnimation
            {
                easing.type: Easing.InQuad
                duration: Kirigami.Units.shortDuration
            }
        }
    }

    background: Rectangle
    {
        visible: !control.flat
        implicitWidth: Math.floor(Maui.Style.iconSizes.medium + (Maui.Style.space.medium * 1.5))
        implicitHeight: Math.floor(Maui.Style.iconSizes.medium + (Maui.Style.space.medium * 1.5))

        radius: Maui.Style.radiusV

        color: control.pressed || control.down || control.checked || control.highlighted || control.hovered ? control.Kirigami.Theme.highlightColor : "transparent"

        Behavior on color
        {
            ColorAnimation
            {
                 easing.type: Easing.InQuad
                duration: Kirigami.Units.shortDuration
            }
        }
    }
}
