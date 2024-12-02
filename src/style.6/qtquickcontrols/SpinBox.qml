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
import QtQuick.Templates as T

import org.mauikit.controls as Maui
import QtQuick.Window

T.SpinBox
{
    id: control
    opacity: control.enabled ? 1 : 0.5
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    hoverEnabled: !Maui.Handy.isMobile

    property int preferredWidth : 100

    implicitWidth: Math.max(preferredWidth, contentItem.implicitWidth +
                            up.implicitIndicatorWidth +
                            down.implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitContentHeight + topPadding + bottomPadding,
                             up.implicitIndicatorHeight,
                             down.implicitIndicatorHeight)
    

    editable: true

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    leftPadding: (control.mirrored ? (up.indicator ? up.indicator.width : 0) : (down.indicator ? down.indicator.width : 0))
    rightPadding: (control.mirrored ? (down.indicator ? down.indicator.width : 0) : (up.indicator ? up.indicator.width : 0))
    
    validator: IntValidator
    {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }
    property int wheelDelta

    
    contentItem: TextInput
    {

        text: control.textFromValue(control.value, control.locale)
        opacity: control.enabled ? 1 : 0.3
        
        font: control.font
        color: Maui.Theme.textColor
        selectionColor: Maui.Theme.highlightColor
        selectedTextColor: Maui.Theme.highlightedTextColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        
        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

        Behavior on color
        {
            Maui.ColorTransition{}
        }

        MouseArea
        {
            anchors.fill: parent
            onPressed: (mouse) => mouse.accepted = false;
            onExited: wheelDelta = 0
            onWheel: (wheel) =>
                     {
                         wheelDelta += wheel.angleDelta.y;
                         // magic number 120 for common "one click"
                         // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                         while (wheelDelta >= 120) {
                             wheelDelta -= 120;
                             control.increase();
                             control.valueModified();
                         }
                         while (wheelDelta <= -120) {
                             wheelDelta += 120;
                             control.decrease();
                             control.valueModified();
                         }
                     }
            cursorShape: Qt.IBeamCursor
        }
    }
    
    up.indicator: Item
    {
        x: control.mirrored ? 0 : parent.width - width
        height: control.height
        width: height
        
        Maui.Icon
        {
            source: "value-increase-symbolic"
            anchors.centerIn: parent
            width: Maui.Style.iconSizes.small
            height: width
            color: Maui.Theme.textColor
        }
    }
    
    down.indicator: Item
    {
        x: control.mirrored ? parent.width - width : 0
        height: control.height
        width: height
        
        Maui.Icon
        {
            source: "value-decrease-symbolic"
            anchors.centerIn: parent
            width: Maui.Style.iconSizes.small
            height: width
            color: Maui.Theme.textColor
            Behavior on color
            {
                Maui.ColorTransition{}
            }
            
        }
    }
    
    background: Rectangle
    {
        radius: Maui.Style.radiusV
        
        color: control.hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor

        Behavior on color
        {
            Maui.ColorTransition{}
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
}
