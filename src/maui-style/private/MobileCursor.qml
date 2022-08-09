/*
    SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.1
import org.mauikit.controls 1.3 as Maui

Item {
    id: root
    width: 1 //<-important that this is actually a single device pixel
    height: Maui.Style.units.gridUnit

    property Item target

    property bool selectionStartHandle: false

    visible: Maui.Handy.isTouch && ((target.activeFocus && !selectionStartHandle) || target.selectedText.length > 0)

    Rectangle {
        width: 3
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: parent.bottom
        }
        color: Qt.tint(Maui.Theme.highlightColor, Qt.rgba(1,1,1,0.4))
        radius: width
        Rectangle {
            width: Math.round(Maui.Style.units.gridUnit/1.5)
            height: width
//            visible: MobileTextActionsToolBar.shouldBeVisible
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.bottom
            }
            radius: width
            color: Qt.tint(Maui.Theme.highlightColor, Qt.rgba(1,1,1,0.4))
        }
        MouseArea {
            anchors {
                fill: parent
                margins: -Maui.Style.units.gridUnit
            }
            preventStealing: true
            onPositionChanged: {
                var pos = mapToItem(target, mouse.x, mouse.y);
                pos = target.positionAt(pos.x, pos.y);

                if (target.selectedText.length > 0) {
                    if (selectionStartHandle) {
                        target.select(Math.min(pos, target.selectionEnd - 1), target.selectionEnd);
                    } else {
                        target.select(target.selectionStart, Math.max(pos, target.selectionStart + 1));
                    }
                } else {
                    target.cursorPosition = pos;
                }
            }
        }
    }
}

