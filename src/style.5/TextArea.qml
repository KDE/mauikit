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
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T
import org.mauikit.controls 1.3 as Maui
import "private" as Private


T.TextArea
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false
clip: false

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            background ? background.implicitWidth : 0,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: Maui.Style.space.medium

    color: Maui.Theme.textColor
    selectionColor: Maui.Theme.highlightColor
    selectedTextColor: Maui.Theme.highlightedTextColor

    opacity: control.enabled ? 1 : 0.6
    wrapMode: Text.WordWrap

    verticalAlignment: TextEdit.AlignTop
    hoverEnabled: !Maui.Handy.isTouch

    // Work around Qt bug where NativeRendering breaks for non-integer scale factors
    // https://bugreports.qt.io/browse/QTBUG-67007
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    selectByMouse: !Maui.Handy.isMobile
    selectByKeyboard: true

    persistentSelection: true
    activeFocusOnPress: true
    activeFocusOnTab: true

    cursorDelegate: Maui.Handy.isTouch && Maui.Handy.isLinux ? mobileCursor : null
    Component
    {
        id: mobileCursor
        Private.MobileCursor
        {
            target: control
        }
    }

    onPressAndHold:
    {
        if (!Maui.Handy.isTouch) {
            return;
        }

        forceActiveFocus();
        cursorPosition = positionAt(event.x, event.y);
        selectWord();
    }

    Label
    {
        id: placeholder

        opacity: 0.5

        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: control.color
        horizontalAlignment: control.horizontalAlignment
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }



    background: Rectangle
    {
//        y: parent.height - height - control.bottomPadding / 2
        implicitWidth: 120
//        height: control.activeFocus ? 2 : 1
        color: control.Maui.Theme.backgroundColor
    }
}
