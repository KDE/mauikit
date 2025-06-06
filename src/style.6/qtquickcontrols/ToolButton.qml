/****************************************************************************
 * *
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

import QtQuick
import QtQuick.Templates as T
import org.mauikit.controls as Maui

T.ToolButton
{
    id: control

    focus: false
    focusPolicy: Qt.TabFocus

    Maui.Theme.colorSet:  Maui.Theme.Button
    Maui.Theme.inherit: false

    opacity: enabled ? 1 : 0.5

    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, implicitHeight)
    implicitHeight: implicitContentHeight + topPadding + bottomPadding

    hoverEnabled: !Maui.Handy.isMobile

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize

    icon.color: control.color

    readonly property color color : control.down || control.checked ? ( Maui.Theme.highlightedTextColor) : Maui.Theme.textColor

    flat: true
    font: Maui.Style.defaultFont

    indicator: null //Control should implement the indicator, for example via DropDownIndicator

    contentItem: Maui.IconLabel
    {
        id: _content
        readonly property real arrowPadding: control.indicator && control.indicator.visible ? control.indicator.width + Maui.Style.space.tiny : 0

        rightPadding: arrowPadding + (_badgeLoader.visible ? 8 : 0)

        spacing: control.spacing
        // mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font
        alignment: Qt.AlignHCenter
        color: control.color
    }

    //     Behavior on implicitHeight
    //     {
    //         NumberAnimation
    //         {
    //             duration: Maui.Style.units.shortDuration
    //             easing.type: Easing.InQuad
    //         }
    //     }
    //
    //     Behavior on implicitWidth
    //     {
    //         NumberAnimation
    //         {
    //             duration: Maui.Style.units.shortDuration
    //             easing.type: Easing.InQuad
    //         }
    //     }

    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: control.hovered && control.text.length && (control.display === ToolButton.IconOnly ? true : !checked)
    ToolTip.text: control.text

    background: Rectangle
    {
        // visible: !control.flat
        radius: Maui.Style.radiusV

        color: control.pressed || control.down || control.checked ? control.Maui.Theme.highlightColor : (control.highlighted || control.hovered ?  control.Maui.Theme.hoverColor : (control.flat ? "transparent" : control.Maui.Theme.backgroundColor))

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

    Loader
    {
        id: _badgeLoader

        z: _content.z + 9999999999
        asynchronous: true

        active: control.Maui.Controls.badgeText && control.Maui.Controls.badgeText.length > 0 && control.visible
        visible: active

        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenterOffset: -5

        sourceComponent: Maui.Badge
        {
            text: control.Maui.Controls.badgeText

            padding: 2
            font.pointSize: Maui.Style.fontSizes.tiny

            Maui.Controls.status: Maui.Controls.Negative

            OpacityAnimator on opacity
            {
                from: 0
                to: 1
                duration: Maui.Style.units.shortDuration
                running: parent.visible
            }

            ScaleAnimator on scale
            {
                from: 0.5
                to: 1
                duration: Maui.Style.units.shortDuration
                running: parent.visible
                easing.type: Easing.OutInQuad
            }
        }
    }
}
