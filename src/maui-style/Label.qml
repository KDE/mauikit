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

T.Label 
{
    id: control

    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    activeFocusOnTab: false
    focus: false
    //Text.NativeRendering is broken on non integer pixel ratios
    renderType: Window.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
  

    font.capitalization: Maui.Theme.defaultFont.capitalization
    font.family: Maui.Theme.defaultFont.family
    font.italic: Maui.Theme.defaultFont.italic
    font.letterSpacing: Maui.Theme.defaultFont.letterSpacing
    font.pointSize: Maui.Theme.defaultFont.pointSize
    font.strikeout: Maui.Theme.defaultFont.strikeout
    font.underline: Maui.Theme.defaultFont.underline
    font.weight: Maui.Theme.defaultFont.weight
    font.wordSpacing: Maui.Theme.defaultFont.wordSpacing
    
    color: Maui.Theme.textColor
    linkColor: Maui.Theme.linkColor

    opacity: enabled? 1 : 0.6

    Accessible.role: Accessible.StaticText
    Accessible.name: text
    
    Behavior on color
    {
        Maui.ColorTransition{}
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: control.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton // Not actually accepting clicks, just changing the cursor
    }
}
