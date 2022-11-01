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



import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import QtQuick.Templates 2.15 as T
import org.mauikit.controls 1.3 as Maui

T.ToolBar 
{
    id: control
    
    default property alias content : _layout.data
        
    Maui.Theme.colorSet: Maui.Theme.Header
    Maui.Theme.inherit: false
    
    property Item translucencySource : null
    
    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)
    
    contentWidth: contentChildren[0].implicitWidth
    contentHeight: contentChildren[0].implicitHeight
    
    spacing: Maui.Style.space.small    
    padding: Maui.Style.space.medium  
    
    contentItem: Row
    {
        id: _layout
        spacing: control.spacing
    }
    
    background: Rectangle
    {
        id: _headBarBG
        color: Maui.Theme.backgroundColor
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        Loader
        {
            asynchronous: true
            active: control.translucencySource !== null && Maui.Style.enableEffects
            anchors.fill: parent
            sourceComponent: Item
            {
                FastBlur
                {    
                    anchors.fill: parent
                    
                    layer.enabled: true
                    layer.effect: Desaturate
                    {
                        desaturation: -1.2
                    }
                    
                    source: control.translucencySource
                    radius: 64
                }  
                
                
                Rectangle
                {
                    color: _headBarBG.color
                    anchors.fill: parent
                    opacity: 0.9
                    
                }   
            }
        }           
        
        
        Maui.Separator
        {
            id: _border
            anchors.left: parent.left
            anchors.right: parent.right
            weight: Maui.Separator.Weight.Light
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }
        
        
        states: [  State
        {
            when: control.position === ToolBar.Header
            
            AnchorChanges
            {
                target: _border
                anchors.top: undefined
                anchors.bottom: parent.bottom
            }
        },
        
        State
        {
            when: control.position === ToolBar.Footer
            
            AnchorChanges
            {
                target: _border
                anchors.top: parent.top
                anchors.bottom: undefined                    
            }
        }
        ]
    }
}
