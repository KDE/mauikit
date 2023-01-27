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

import QtQuick.Templates 2.15 as T
import org.mauikit.controls 1.3 as Maui
import QtQuick.Controls.impl 2.15

T.Switch
{
    id: control
    opacity: control.enabled ? 1 : 0.5
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    hoverEnabled: !Maui.Handy.isMobile
    
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset
    
    padding: Maui.Style.defaultPadding
    spacing: padding
    
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
    icon.color: Maui.Theme.textColor
    
    indicator: SwitchIndicator
    {
        Maui.Theme.colorSet: control.Maui.Theme.colorSet
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        control: control
    }    
    
    contentItem: IconLabel
    {        
        spacing: control.spacing
        
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        
        icon: control.icon
        
        mirrored: control.mirrored
        display: control.display
        text: control.text
        font: control.font
        color: control.icon.color        
    }
    
    background: Item
    {
        implicitHeight: Math.floor(Maui.Style.iconSizes.medium + (Maui.Style.space.medium * 1.25))
    }
}
