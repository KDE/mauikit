// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

T.MenuItem
{
    id: control
    default property list<Action> actions
    
    opacity: control.enabled ? 1 : 0.5
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    hoverEnabled: !Maui.Handy.isMobile
    
    width: implicitWidth
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    implicitWidth: ListView.view ? ListView.view.width : Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    
    background: null
    
    spacing: Maui.Style.space.medium
    padding: Maui.Style.space.small
    
    display : width > Maui.Style.units.gridUnit * 28 && control.actions.length <= 3 ?  ToolButton.TextBesideIcon : (Maui.Handy.isMobile ? ToolButton.TextUnderIcon : ToolButton.IconOnly)
    
    contentItem: Flow
        {
            id: _layout
//            anchors.centerIn: parent
            spacing: control.spacing
            
            Repeater
            {
                id: _repeater
                model: control.actions
                
                delegate: ToolButton
                {
                    id: _delegate      
                    width: Math.max(height, implicitWidth)
                   height: Math.max(implicitHeight, Maui.Style.rowHeight)
                   
                    action: modelData
                    display: control.display
                    
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: ( _delegate.hovered ) && _delegate.text.length
                    ToolTip.text: modelData.text
                    
                    Connections
                    {
                        target: _delegate.action
                        ignoreUnknownSignals: true
                        function onTriggered()
                        {
                            control.triggered()
                        }
                    }
                }
            }  
        }
    
}
