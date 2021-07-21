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
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtQuick.Window 2.1


T.SpinBox
{
    id: control
    opacity: control.enabled ? 1 : 0.5

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth +
                            up.implicitIndicatorWidth +
                            down.implicitIndicatorWidth)
    implicitHeight: Math.max(implicitContentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight,
                             up.implicitIndicatorHeight,
                             down.implicitIndicatorHeight)

    spacing: Maui.Style.space.medium
    editable: true

    topPadding: 0
    bottomPadding: 0
    leftPadding: (control.mirrored ? (up.indicator ? up.indicator.width : 0) : (down.indicator ? down.indicator.width : 0))
    rightPadding: (control.mirrored ? (down.indicator ? down.indicator.width : 0) : (up.indicator ? up.indicator.width : 0))

    validator: IntValidator
    {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput
    {
        text: control.textFromValue(control.value, control.locale)
        opacity: control.enabled ? 1 : 0.3

        font: control.font
        color: Kirigami.Theme.textColor
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

        MouseArea
        {
            anchors.fill: parent
            onPressed: mouse.accepted = false;
            onExited: wheelDelta = 0
            onWheel:
            {
                wheelDelta += wheel.angleDelta.y;
                // magic number 120 for common "one click"
                // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                while (wheelDelta >= 120) {
                    wheelDelta -= 120;
                    controlRoot.increase();
                    controlRoot.valueModified();
                }
                while (wheelDelta <= -120) {
                    wheelDelta += 120;
                    controlRoot.decrease();
                    controlRoot.valueModified();
                }
            }
            cursorShape: Qt.IBeamCursor
        }
    }

    up.indicator: Item
    {
        x: control.mirrored ? 0 : parent.width - width
        height: parent.height
        width: height

        Kirigami.Icon
        {
            source: "list-add"
            anchors.centerIn: parent
            width: Maui.Style.iconSizes.small
            height: width
            color: Kirigami.Theme.textColor
        }
    }

    down.indicator: Item
    {
        x: control.mirrored ? parent.width - width : 0
        height: parent.height
        width: height

        Kirigami.Icon
        {
            source: "list-remove"
            anchors.centerIn: parent
            width: Maui.Style.iconSizes.small
            height: width
            color: Kirigami.Theme.textColor
        }
    }

    background: Rectangle
    {
        implicitWidth:  (Maui.Style.iconSizes.medium * 6) + Maui.Style.space.big
        implicitHeight: Math.floor(Maui.Style.iconSizes.medium + (Maui.Style.space.medium * 1.25))

        radius: Maui.Style.radiusV

        color: Qt.lighter(Kirigami.Theme.backgroundColor)
    }
}
