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

import QtQuick
import org.mauikit.controls as Maui

Item
{
    id: indicator
    
    implicitWidth: height * 1.8
    implicitHeight: 22
    
    property Item control
    property alias handle: handle
    property color m_color : control.checked ? Maui.Theme.highlightColor : (control.hovered ? Maui.Theme.hoverColor :  Maui.ColorUtils.linearInterpolation(Maui.Theme.alternateBackgroundColor, Maui.Theme.textColor, 0.2))
    
    Rectangle
    {
        width: parent.width
        height: parent.height
        radius: Maui.Style.radiusV
        color:  m_color
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
        
        Behavior on border.color
        {
            Maui.ColorTransition{}
        }
        border.color: statusColor(control)
        
        function statusColor(control)
        {
            if(control.Maui.Controls.status)
            {
                switch(control.Maui.Controls.status)
                {
                    case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
                    case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
                    case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
                    case Maui.Controls.Normal:
                    default:
                        return "transparent"
                }
            }
            
            return "transparent"
        }
    }
    
    Rectangle
    {
        id: handle
        x: control.visualPosition * parent.width >= parent.width ? control.visualPosition * parent.width - (width + 2) : control.visualPosition * parent.width + 2
        y: (parent.height - height) / 2
        width: height
        height: parent.height - 4
        radius: Maui.Style.radiusV
        color: Maui.Theme.backgroundColor
        
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
