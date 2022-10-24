/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import org.mauikit.controls 1.3 as Maui
import QtQuick.Layouts 1.3

import QtQuick.Templates 2.15 as T

/**
 * TextField
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.TextField
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    hoverEnabled: !Maui.Handy.isMobile
    
    opacity: control.enabled ? 1 : 0.5
    
    color: Maui.Theme.textColor
    selectionColor: Maui.Theme.highlightColor
    selectedTextColor: Maui.Theme.highlightedTextColor
    focus: true
    
    implicitHeight: Math.max(_layout.implicitHeight, Maui.Style.rowHeight)  + topPadding + bottomPadding
    implicitWidth: 100 + leftPadding + rightPadding
    
    verticalAlignment: TextInput.AlignVCenter
    horizontalAlignment: Text.AlignLeft
    
    padding: 0
    
    leftPadding: icon.visible ? icon.implicitWidth + Maui.Style.space.medium + Maui.Style.space.small : Maui.Style.space.medium
    rightPadding: _actionsLayoutLoader.implicitWidth + Maui.Style.space.medium
    
    selectByMouse: !Maui.Handy.isMobile
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
    
    persistentSelection: true
    
    wrapMode: TextInput.NoWrap
    /**
     * menu : Menu
     */
    property alias menu : entryMenu
    
    /**
     * actions : RowLayout
     */
    property list<Action> actions
    
    property alias icon : _icon
    
    /**
     * cleared
     */
    signal cleared()
        
    /**
     * contentDropped :
     */
    signal contentDropped(var drop)
    
    onPressAndHold: !Maui.Handy.isMobile ? entryMenu.show() : undefined
    onPressed:
    {
        if(!Maui.Handy.isMobile && event.button === Qt.RightButton)
            entryMenu.show()
    }
    
    Keys.enabled: true  
    
    Shortcut
    {
        sequence: StandardKey.Escape
        onActivated: 
        {
            control.clear()
            control.cleared()
        }
    }

    Behavior on leftPadding 
    {
        NumberAnimation 
        {
            duration: Maui.Style.units.longDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    Behavior on rightPadding 
    {
        NumberAnimation
        {
            duration: Maui.Style.units.longDuration
            easing.type: Easing.InOutQuad
        }
    }    
    
     RowLayout
    {
        id: _layout
       anchors.fill: parent   
            anchors.leftMargin: Maui.Style.space.medium
            
        Maui.Icon
        {
            id: _icon
            visible: source ? true : false
            implicitHeight: visible ? 16 : 0
            implicitWidth: height
            color: control.color   
        }    
        
        Label
        {
            id: placeholder
            Layout.fillWidth: true
            text: control.placeholderText
            font: control.font
            color: control.color
            verticalAlignment: control.verticalAlignment
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
            
            visible: opacity > 0
            opacity: !control.length && !control.preeditText && !control.activeFocus ? 0.4 : 0  
                       
            
            Behavior on opacity 
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }  
        }        
        
        Loader
        {
            id: _actionsLayoutLoader
            asynchronous: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            
            sourceComponent: Row
            {
                z: parent.z + 1
                spacing: Maui.Style.space.medium    
                
                ToolButton
                {
                    id: clearButton
                    height: parent.height
                    flat: true
                    focusPolicy: Qt.NoFocus
                    
                    visible: control.text.length || control.activeFocus
                    icon.name: "edit-clear"
                    
                    onClicked:
                    {
                        control.clear()
                        cleared()
                    }
                }
                
                Repeater
                {
                    model: control.actions
                    
                    ToolButton
                    {
                        flat: !checkable
                        height: parent.height
                        focusPolicy: Qt.NoFocus
                        action: modelData
                    }
                }
            }
        }
        
    }
    
    
    Maui.ContextualMenu
    {
        id: entryMenu
        
        MenuItem
        {
            text: i18n("Copy")
            onTriggered: control.copy()
            enabled: control.selectedText.length
        }
        
        MenuItem
        {
            text: i18n("Cut")
            onTriggered: control.cut()
            enabled: control.selectedText.length
        }
        
        MenuItem
        {
            text: i18n("Paste")
            onTriggered:
            {
                var text = control.paste()
                control.insert(control.cursorPosition, text)
            }
        }
        
        MenuItem
        {
            text: i18n("Select All")
            onTriggered: control.selectAll()
            enabled: control.text.length
        }
        
        MenuItem
        {
            text: i18n("Undo")
            onTriggered: control.undo()
            enabled: control.canUndo
        }
        
        MenuItem
        {
            text: i18n("Redo")
            onTriggered: control.redo()
            enabled: control.canRedo
        }
    }
    
    Loader
    {
        asynchronous: true
        sourceComponent: DropArea
        {            
            onDropped:
            {
                console.log(drop.text, drop.html)
                if (drop.hasText)
                {
                    control.text += drop.text
                    
                }else if(drop.hasUrls)
                {
                    control.text = drop.urls
                }
                
                control.contentDropped(drop)
            }
        }
    }
    
    background: Rectangle 
    {       
        color: control.enabled ? (control.hovered ? Maui.Theme.hoverColor :  Maui.Theme.backgroundColor) : "transparent"
        border.color: !control.enabled ? Maui.Theme.disabledTextColor : "transparent"
        
        radius: Maui.Style.radiusV
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
