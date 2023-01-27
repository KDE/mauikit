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
    
    hoverEnabled: !Maui.Handy.isMobile
    
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    implicitWidth: ListView.view ? ListView.view.width : Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    
    background: null
    
    padding: 0
    spacing: Maui.Style.space.medium
    
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
                Maui.Theme.inherit: true

                width: Math.max(height, implicitWidth)
                height: Math.max(implicitHeight, Maui.Style.rowHeight)
                
                action: modelData
                display: control.display
                
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: ( _delegate.hovered ) && _delegate.text.length
                ToolTip.text: modelData.text
                
                background: Rectangle
                {
                    radius: Maui.Style.radiusV
                    color: _delegate.checked || _delegate.pressed || _delegate.down ? Maui.Theme.highlightColor : _delegate.highlighted || _delegate.hovered ? Maui.Theme.hoverColor : Maui.Theme.alternateBackgroundColor
                    
                }
                
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
