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
import QtQuick.Templates as T
import org.mauikit.controls as Maui

T.RadioButton 
{
    id: control

    property alias m_control: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    hoverEnabled: true
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
    
    icon.color: Maui.Theme.textColor
    indicator: RadioIndicator
    {
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        control: m_control
    }

    contentItem: Maui.IconLabel
    {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        opacity: control.enabled ? 1 : 0.6
        text: control.text
        font: control.font
        icon: control.icon
      
        color: control.icon.color
        // elide: Text.ElideRight
        visible: control.text
        // horizontalAlignment: Text.AlignLeft
        // verticalAlignment: Text.AlignVCenter
    }
    
    background: Rectangle
    {
        radius: Maui.Style.radiusV
        
        color: "transparent"
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
}
