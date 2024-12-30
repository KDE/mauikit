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

T.Button
{
    id: control
    opacity: control.enabled ? 1 : 0.5

    highlighted: activeFocus

    implicitWidth: implicitContentWidth + leftPadding + rightPadding

    implicitHeight: implicitContentHeight + topPadding + bottomPadding

    hoverEnabled: !Maui.Handy.isMobile

    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false

    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize

    icon.color: setTextColor(control)

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    font: Maui.Style.defaultFont

    focusPolicy: Qt.StrongFocus
    focus: true

    Keys.enabled: true

    Keys.onReturnPressed: { control.clicked() }
    Keys.onEnterPressed: { control.clicked() }

    enabled: action ? action.enabled :  true

    contentItem: Maui.IconLabel
    {
        text: control.text
        font: control.font
        icon: control.icon
        color: control.icon.color
        spacing: control.spacing
        display: control.display
        alignment: Qt.AlignHCenter
        rightPadding: _badgeLoader.visible ? 8 : 0
    }

    background: Rectangle
    {
        visible: !control.flat

        color: setBackgroundColor(control)

        radius: Maui.Style.radiusV

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    Loader
    {
        id: _badgeLoader

        z: control.contentItem.z + 9999
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
                duration: Maui.Style.units.longDuration
                running: parent.visible
            }

            ScaleAnimator on scale
            {
                from: 0.5
                to: 1
                duration: Maui.Style.units.longDuration
                running: parent.visible
                easing.type: Easing.OutInQuad
            }
        }
    }

    function setTextColor(control)
    {
        let defaultColor = (color) =>
        {
            return control.down || control.checked ? (control.flat ? Maui.Theme.highlightColor : Maui.Theme.highlightedTextColor) : color
        }

        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {
            case Maui.Controls.Normal: return defaultColor(control.Maui.Theme.textColor)
            case Maui.Controls.Positive: return control.Maui.Theme.positiveTextColor
            case Maui.Controls.Negative: return control.Maui.Theme.negativeTextColor
            case Maui.Controls.Neutral: return control.Maui.Theme.neutralTextColor
            }
        }

        return defaultColor(control.Maui.Theme.textColor)
    }

    function setBackgroundColor(control)
    {
        let defaultColor = (bg) =>
        {
            return control.pressed || control.down || control.checked ? control.Maui.Theme.highlightColor : (control.highlighted || control.hovered ? control.Maui.Theme.hoverColor : bg)
        }

        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {                
            case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
            case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
            case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
            case Maui.Controls.Normal: 
            default:
            return defaultColor(control.Maui.Theme.backgroundColor)
            }
        }

        if(control.Maui.Controls.level)
        {
            switch(control.Maui.Controls.level)
            {
            case Maui.Controls.Undefined: return defaultColor(control.Maui.Theme.backgroundColor)
            case Maui.Controls.Primary: return defaultColor(control.Maui.Theme.backgroundColor)
            case Maui.Controls.Secondary: return defaultColor(control.Maui.Theme.alternateBackgroundColor)
            }
        }

        return defaultColor(control.Maui.Theme.backgroundColor)
    }
}
