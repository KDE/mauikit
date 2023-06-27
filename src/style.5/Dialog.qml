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
import QtQuick.Layouts 1.15

import QtQuick.Templates 2.15 as T
import org.mauikit.controls 1.3 as Maui

import QtGraphicalEffects 1.0

T.Dialog
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    parent: T.Overlay.overlay

    anchors.centerIn: parent

    implicitWidth: Math.min(300, control.parent.width)
    implicitHeight: implicitContentHeight + topPadding + bottomPadding + implicitFooterHeight + implicitHeaderHeight + topMargin + bottomMargin

    spacing: Maui.Style.defaultSpacing
    padding: Maui.Style.contentMargins
    margins: Maui.Style.space.medium
    modal: true

     closePolicy: control.modal ? Popup.NoAutoClose | Popup.CloseOnEscape : Popup.CloseOnEscape | Popup.CloseOnPressOutside

//    enter: Transition {
//        NumberAnimation {
//            property: "opacity"
//            from: 0
//            to: 1
//            easing.type: Easing.InOutQuad
//            duration: 250
//        }
//    }

//    exit: Transition {
//        NumberAnimation {
//            property: "opacity"
//            from: 1
//            to: 0
//            easing.type: Easing.InOutQuad
//            duration: 250
//        }
//    }

    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: Maui.Theme.backgroundColor

        layer.enabled: true
        layer.effect: DropShadow
        {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8
            samples: 16
            color: "#80000000"
            transparentBorder: true
        }

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    header: Maui.ToolBar
    {
        visible: control.title.length >0
        background: null

        middleContent: Label
        {
            text: control.title
            horizontalAlignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            font: Maui.Style.h2Font
        }
    }

    footer: DialogButtonBox
    {
        visible: count > 0
        width: parent.width
        padding: control.padding
    }
}
