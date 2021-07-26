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

import QtQuick 2.12
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.12

import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.0 as Maui

T.MenuItem
{
    id: control

    opacity: control.enabled ? 1 : 0.5

    hoverEnabled: !Kirigami.Settings.isMobile

    implicitWidth: ListView.view ? ListView.view.width : Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: visible ? Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                       implicitContentHeight + topPadding + bottomPadding,
                                       implicitIndicatorHeight + topPadding + bottomPadding) : 0
    Layout.fillWidth: true

    padding: Maui.Style.space.small
    verticalPadding: Maui.Style.space.small

    spacing: Kirigami.Settings.isMobile ? Maui.Style.space.big :  Maui.Style.space.small

    icon.width: Maui.Style.iconSizes.small
    icon.height: Maui.Style.iconSizes.small
    leftInset: Maui.Style.space.small
    rightInset: Maui.Style.space.small
    
    icon.color: control.Kirigami.Theme.textColor

    indicator: CheckIndicator
    {
        x: control.width - width - control.rightPadding - Maui.Style.space.small
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.checkable
        control: control
    }

    arrow: Kirigami.Icon
    {
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2

        visible: control.subMenu
//        mirror: control.mirrored
        color: control.icon.color
        height: 10
        width: 10
        source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/Material/images/arrow-indicator.png"
    }

    contentItem: IconLabel
    {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0

        leftPadding: arrowPadding + Maui.Style.space.medium
        rightPadding: indicatorPadding + Maui.Style.space.medium

        spacing: control.spacing

        mirrored: control.mirrored
        display: control.display

        alignment: Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        color: control.icon.color
    }

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: control.visible ? (Kirigami.Settings.isMobile ? Maui.Style.rowHeight*1.2 : Maui.Style.rowHeightAlt) : 0
        radius: Maui.Style.radiusV

        readonly property color m_color : Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))

        color: control.enabled ? (control.pressed || control.hovered ? Qt.rgba(control.Kirigami.Theme.highlightColor.r, control.Kirigami.Theme.highlightColor.g, control.Kirigami.Theme.highlightColor.b, 0.2) : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.3)) : "transparent"

//         border.color: control.enabled ? (control.checked || control.down ? control.Kirigami.Theme.highlightColor : "transparent") : m_color
    }
}
