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

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.2

import QtQuick.Templates 2.12 as T

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import QtGraphicalEffects 1.0

Maui.ComboBox
{
    id: control
    font.family: control.displayText
    model: Qt.fontFamilies()
    
    delegate: MenuItem
    {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.family: text      
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
        Maui.Theme.colorSet: control.Maui.Theme.inherit ? control.Maui.Theme.colorSet : Maui.Theme.View
        Maui.Theme.inherit: control.Maui.Theme.inherit

    }
    
    contentItem: T.TextField
    {
        padding: Maui.Style.space.small
        leftPadding: (control.editable ? Maui.Style.space.medium : control.mirrored ? 0 : Maui.Style.space.medium) + control.leftPadding
        rightPadding: (control.editable ? Maui.Style.space.medium : control.mirrored ? Maui.Style.space.medium : 0) + control.rightPadding
        text: control.editable ? control.editText : control.displayText
        
        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
        selectByMouse: !Maui.Handy.isMobile

        font: control.font
        color: control.Maui.Theme.textColor
        selectionColor:  control.Maui.Theme.highlightColor
        selectedTextColor: control.Maui.Theme.highlightedTextColor
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1 : 0.5
        //        cursorDelegate: CursorDelegate { }
    }
}
