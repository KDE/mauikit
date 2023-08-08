/*
 *   Copyright 2023 Camilo Higuita <milo.h@aol.com>
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
import QtQuick.Layouts 1.3

import QtGraphicalEffects 1.0
import QtQuick.Window 2.15

import org.mauikit.controls 1.3 as Maui

AbstractButton
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    property int minimumWidth: 400
    property int minimumHeight: 500
    
    implicitWidth: 200
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    
    hoverEnabled: true
    
    default property alias content: _page.content
   
        property alias popup: _popup
        property alias textField : _textField
    
    property alias popupVisible: _popup.visible
    property alias closePolicy: _popup.closePolicy
    
    property int position:  ToolBar.Header
    
    property alias placeholderText: _textField.placeholderText
    property alias inputMethodHints: _textField.inputMethodHints
    property alias activeFocusOnPress: _textField.activeFocusOnPress
    property alias wrapMode :_textField.wrapMode
    property alias color: _textField.color
    property alias verticalAlignment: _textField.verticalAlignment
    property alias preeditText: _textField.preeditText
    
    onClicked:
    {
        _popup.open()
    }
    
    text: _textField.text
    icon.name: "edit-find"
    
    Keys.onEscapePressed: control.close()
    
    signal accepted()
    signal cleared()
    signal opened()
    signal closed()
    
    function open()
    {
        _popup.open()
    }
    
    function close()
    {
        _popup.close()
    }  
    
    function clear()
    {
        _textField.clear()
    }
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    contentItem:  RowLayout
    {
        id: _layout       
        spacing: control.spacing 
        
        Maui.Icon
        {
            visible: source ? true : false
            source: control.icon.name
            implicitHeight: visible ? 16 : 0
            implicitWidth: height
            color: control.color   
        }
        
        Item
        {
            Layout.fillWidth: true
            visible: !placeholder.visible
        }
        
        Label
        {
            id: placeholder
            Layout.fillWidth: true
            text: control.text.length > 0 ? control.text : control.placeholderText
            font: control.font
            color: control.color
            verticalAlignment: control.verticalAlignment
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
            
            opacity: !_textField.activeFocus ? 1 : 0.5 
                        
            Behavior on opacity 
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }  
        }      
    }
    
    data: Popup
    {
        id: _popup
        
        parent: control
        
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        modal: false
        
        y: control.position === ToolBar.Header ? 0 : (0 - (height) + control.height)
        x: width === control.width ? 0 : 0 - ((width - control.width)/2)
        
        width: Math.min(Math.max(control.minimumWidth, parent.width), control.Window.window.width - Maui.Style.defaultPadding*2)
        height: Math.min(control.Window.window.height- Maui.Style.defaultPadding*2, control.minimumHeight)
        
        margins: 0
        padding: 0
        
        onClosed: 
        {
            _textField.clear()
            control.closed()
        }
        
        onOpened: 
        {
            _textField.forceActiveFocus()
            _textField.selectAll()
            control.opened()
        }
        
        Maui.Page
        {
            id:_page
            anchors.fill: parent
            altHeader: control.position === ToolBar.Footer
                                    
                                    headBar.visible: false
                                    headerColumn: TextField
                                    {
                                        implicitHeight: control.height
               width: parent.width
                
                id: _textField
                text: control.text
                               
                icon.source: control.icon.name
                
                onTextChanged: control.text = text
                onAccepted: 
                {
                    control.text = text
                    control.accepted()
                }
                
                onCleared: 
                {
                    control.cleared()
                }                
                
                Keys.enabled: true
                Keys.forwardTo: control
                Keys.onEscapePressed: control.close()
                
                background: Rectangle
                {
                    color: Maui.Theme.backgroundColor
                    
                    
                    Maui.Separator
                    {
                        id: _border
                        anchors.left: parent.left
                        anchors.right: parent.right
                        weight: Maui.Separator.Weight.Light
                        opacity: 0.4
                        
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
            
        }
        
        background: Rectangle
        {
            color: Maui.Theme.backgroundColor
            
            radius: Maui.Style.radiusV    
            layer.enabled: true
            layer.effect: DropShadow
            {
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8
                samples: 16
                color: "#80000000"
                transparentBorder: true
            }
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }          
        }
    }
    
    background: Rectangle 
    {       
        color: control.enabled ? (control.hovered ? Maui.Theme.hoverColor :  Maui.Theme.backgroundColor) : "transparent"
        
        radius: Maui.Style.radiusV
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
    
    function forceActiveFocus()
    {
        control.open()
    }
}
