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
import QtQuick.Templates 2.15 as T
import org.mauikit.controls 1.3 as Maui

T.ScrollBar
{
    id: control

    // Maui.Theme.colorSet: Maui.Theme.Button
    // Maui.Theme.inherit: false
    
    implicitWidth: (control.interactive ? 6 : 4 )
    implicitHeight: (control.interactive ? 6 : 4 ) 

    padding: 0
    
    visible: control.policy !== T.ScrollBar.AlwaysOff && !_timer.shouldHide
    
    minimumSize: orientation == Qt.Horizontal ? height / width : width / height

    interactive: !Maui.Handy.isMobile
    contentItem: Rectangle
    {       
        
        radius: Maui.Style.radiusV

        color: control.pressed ? Maui.Theme.highlightColor :
               control.interactive && control.hovered ? Maui.Theme.highlightColor : (Maui.ColorUtils.linearInterpolation(Maui.Theme.alternateBackgroundColor, Maui.Theme.textColor, 0.2))
        opacity: 0.0
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    background: Rectangle
    {
        radius: Maui.Style.radiusV       
       
        color: Maui.Theme.alternateBackgroundColor
        opacity: 0.0
        visible: control.interactive && control.pressed && control.active 
        
        
    }

    states: State 
    {
        name: "active"
        when: control.policy === T.ScrollBar.AlwaysOn || control.policy === T.ScrollBar.AsNeeded
    }

    transitions: [
        Transition {
            to: "active"
            NumberAnimation { targets: [control.contentItem, control.background]; property: "opacity"; to: 1.0 }
        },
        Transition {
            from: "active"
            SequentialAnimation {
                PropertyAction{ targets: [control.contentItem, control.background]; property: "opacity"; value: 1.0 }
                PauseAnimation { duration: 2450 }
                NumberAnimation { targets: [control.contentItem, control.background]; property: "opacity"; to: 0.0 }
            }
        }
    ]
    
    onSizeChanged: 
    {
        if(control.policy !== T.ScrollBar.AlwaysOff)
            _timer.restart()
    }
    
    Timer
    {
        id: _timer
        interval: 300
        repeat: false
        
        property bool shouldHide : true
        property real before
        onTriggered:
        {
            console.log(control.size)
            if(before === control.size && control.size !== 1)
                return
            
            shouldHide = control.size >= 1.0 
            before = control.size
        }
    }
}
