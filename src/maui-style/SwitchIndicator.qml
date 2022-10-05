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

import QtQuick 2.15
import org.mauikit.controls 1.3 as Maui

Item
{
    id: indicator
    implicitWidth: 38
    implicitHeight: 32
    
    property Item control
    property alias handle: handle
    property color m_color : control.checked ? Maui.Theme.highlightColor : (control.hovered ? Maui.Theme.hoverColor :  Maui.Theme.backgroundColor)
    
    Rectangle
    {
        width: parent.width
        height: 20
        radius: height / 2
        y: parent.height / 2 - height / 2
        border.color: control.enabled ? "transparent" : Maui.Theme.disabledTextColor
        color: control.enabled ? m_color : "transparent"
//         opacity: control.checked ? 1 : 0.5
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Behavior on opacity
        {
            NumberAnimation
            {
                easing.type: Easing.InQuad
                duration: Maui.Style.units.shortDuration
            }
        }
    }
    
    Rectangle
    {
        id: handle
        x: Math.max(4, Math.min(parent.width - width, control.visualPosition * parent.width - (width / 2)) - 4)
        y: (parent.height - height) / 2
        width: 16
        height: 16
        radius: width / 2
        color: control.enabled ? (control.checked ? Maui.Theme.highlightedTextColor : Maui.Theme.textColor)
        : "transparent"
        border.color: control.enabled ? "transparent" : Qt.tint(Maui.Theme.textColor, Qt.rgba(Maui.Theme.backgroundColor.r, Maui.Theme.backgroundColor.g, Maui.Theme.backgroundColor.b, 0.9))
        
        Behavior on x
        {
            enabled: !control.pressed
            SmoothedAnimation
            {
                duration: 300
            }
        }
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
