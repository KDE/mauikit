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

import QtQuick
import QtQuick.Templates as T
import org.mauikit.controls as Maui

T.ScrollView
{
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: !background || !background.visible
    clip: false

    padding: 0
    rightPadding: padding + (Maui.Style.scrollBarPolicy === Maui.Style.AutoHide ? 0 : ScrollBar.vertical.width)
    leftPadding: padding
    topPadding: padding
    bottomPadding: padding + (Maui.Style.scrollBarPolicy === Maui.Style.AutoHide ? 0 :ScrollBar.horizontal.height)
    
    property alias orientation : _wheelHandler.primaryOrientation

    data: Maui.WheelHandler
    {
        id: _wheelHandler
        target: control.contentItem
    }
    
    ScrollBar.vertical: ScrollBar
    {
        parent: control
        width: visible ? implicitWidth : 0
        x: control.mirrored ? 0 : control.width - width - 2
        y: control.topPadding
        height: control.availableHeight
        active: control.ScrollBar.vertical.active
        policy: switch(Maui.Style.scrollBarPolicy)
                {
                case Maui.Style.AlwaysOn: return ScrollBar.AlwaysOn;
                case Maui.Style.AlwaysOff: return ScrollBar.AlwaysOff;
                case Maui.Style.AsNeeded: return ScrollBar.AsNeeded;
                case Maui.Style.AutoHide: return ScrollBar.AsNeeded;
                }
    }

    ScrollBar.horizontal: ScrollBar
    {
        parent: control
        height: visible ? implicitHeight : 0
        
        x: control.leftPadding
        y: control.height - height - 2
        width: control.availableWidth
        active: control.ScrollBar.horizontal.active
        policy: ScrollBar.AlwaysOff
        
    }
    
    background: null
}
