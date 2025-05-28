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
import QtQuick.Layouts
import QtQuick.Templates as T
import org.mauikit.controls as Maui

T.DialogButtonBox
{
    id: control

    implicitWidth: visible ? contentItem.implicitWidth + leftPadding + rightPadding : 0
    implicitHeight: visible ? contentItem.implicitHeight + topPadding + bottomPadding : 0
    
    padding: 0
    spacing: Maui.Style.space.small
    alignment: undefined

    delegate: Button
    {
        focus: true
        Layout.fillWidth: true
    }

    contentItem: GridLayout
    {
        rowSpacing: control.spacing
        columnSpacing: control.spacing

        property bool isWide : control.width > (100 * _repeater.count)

        //        visible: control.defaultButtons || control.actions.length

        rows: isWide? 1 : children.length
        columns: isWide ? children.length : 1

        Repeater
        {
         id: _repeater
            model: control.contentModel
        }
    }

    background: null
}
