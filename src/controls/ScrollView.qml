/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.9
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.9 as Kirigami
import org.mauikit.controls 1.3 as Maui

T.ScrollView
{
    id: control

    clip: true

    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: !background || !background.visible
    
    padding: 0
    rightPadding: padding + internal.verticalScrollBarWidth
    leftPadding: padding 
    topPadding: padding
    bottomPadding: padding
    
    wheelEnabled: false
    data: [
    Kirigami.WheelHandler {
        target: control.contentItem
    },    
    
    QtObject 
    {
        id: internal
        
        readonly property real verticalScrollBarWidth: control.ScrollBar.vertical.visible && !Kirigami.Settings.tabletMode ? control.ScrollBar.vertical.width : 0
        readonly property real horizontalScrollBarHeight: control.ScrollBar.horizontal.visible && !Kirigami.Settings.tabletMode ? control.ScrollBar.horizontal.height : 0
    }    
    ]
    
    ScrollBar.vertical: ScrollBar
    {
        parent: control
        x: control.mirrored ? 0 : control.width - width
        y: 0
        height: control.height
        active: control.ScrollBar.horizontal.active
    }
    
    ScrollBar.horizontal: ScrollBar 
    {
        parent: control
        x: 0
        y: control.height - height
        width: control.width
        active: control.ScrollBar.vertical.active
    }  
}
