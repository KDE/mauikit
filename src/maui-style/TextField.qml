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
import QtQuick.Window 2.1
import QtQuick.Controls 2.3 as Controls
import QtQuick.Templates 2.3 as T
import org.mauikit.controls 1.3 as Maui

T.TextField
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false

    implicitWidth: Math.max(200,
                            placeholderText ? placeholder.implicitWidth + leftPadding + rightPadding : 0)
                            || contentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: Maui.Style.space.medium

    color: Maui.Theme.textColor
    selectionColor: Maui.Theme.highlightColor
    selectedTextColor: Maui.Theme.highlightedTextColor
	
	verticalAlignment: TextInput.AlignVCenter
    horizontalAlignment: Text.AlignLeft
	
// 	cursorDelegate: CursorDelegate { }

    Controls.Label
	{
		id: placeholder
		x: control.leftPadding
		y: control.topPadding
		width: control.width - (control.leftPadding + control.rightPadding)
		height: control.height - (control.topPadding + control.bottomPadding)
		
		text: control.placeholderText
		font: control.font
        color: Maui.Theme.textColor
		opacity: 0.4
        horizontalAlignment: !control.length ? Text.AlignHCenter : Text.AlignLeft
		verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
		wrapMode: Text.NoWrap
    }

	background: Rectangle 
	{        
        implicitWidth: 200
        implicitHeight: Maui.Style.rowHeight

        color: control.enabled ? (control.activeFocus ? Maui.Theme.backgroundColor : Qt.lighter(Maui.Theme.backgroundColor)) : "transparent"
        border.color: control.enabled ? (control.activeFocus ? Maui.Theme.highlightColor : color) : Qt.tint(Maui.Theme.textColor, Qt.rgba(Maui.Theme.backgroundColor.r, Maui.Theme.backgroundColor.g, Maui.Theme.backgroundColor.b, 0.7))

        radius: Maui.Style.radiusV
	}
}
