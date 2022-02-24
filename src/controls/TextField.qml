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

import org.kde.kirigami 2.14 as Kirigami
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
    
    Kirigami.Theme.colorSet: Kirigami.Theme.View
//     Kirigami.Theme.inherit: true
    
    color: Kirigami.Theme.textColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    focus: true
    implicitHeight: Maui.Style.rowHeight + topPadding + bottomPadding
    implicitWidth: 100 + leftPadding + rightPadding
    
    verticalAlignment: TextInput.AlignVCenter
    horizontalAlignment: Text.AlignLeft
    padding: 0
    leftPadding: Maui.Style.space.small
    rightPadding: _actionsLayoutLoader.item.implicitWidth + Maui.Style.space.small
    
    selectByMouse: !Kirigami.Settings.isMobile
    
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
     * goBackTriggered :
     */
    signal goBackTriggered()
    
    /**
     * goFowardTriggered :
     */
    signal goFowardTriggered()
    
    /**
     * contentDropped :
     */
    signal contentDropped(var drop)
    
    onPressAndHold: !Kirigami.Settings.isMobile ? entryMenu.show() : undefined
    onPressed:
    {
        if(!Kirigami.Settings.isMobile && event.button === Qt.RightButton)
            entryMenu.show()
    }
    
    Keys.onBackPressed:
    {
        goBackTriggered();
    }
    
    Shortcut
    {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: control.clear()
    }
    
    Shortcut
    {
        sequence: "Forward"
        onActivated: goFowardTriggered();
    }
    
    Shortcut
    {
        sequence: StandardKey.Forward
        onActivated: goFowardTriggered();
    }
    
    Shortcut
    {
        sequence: StandardKey.Back
        onActivated: goBackTriggered();
    }
    
    Behavior on leftPadding 
    {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    Behavior on rightPadding 
    {
        NumberAnimation
        {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }    
    
    RowLayout
    {
        width: Math.min(implicitWidth, control.width)
        anchors.centerIn: parent
        visible: opacity > 0
        anchors.verticalCenter: parent.verticalCenter  
        opacity: !control.length && !control.preeditText && !control.activeFocus ? 0.4 : 0     
        
        Behavior on opacity 
        {
            NumberAnimation
            {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }        
        
        Kirigami.Icon
        {
            id: _icon
            visible: String(_icon.source).length > 0
            implicitHeight: visible ? 16 : 0
            implicitWidth: height
            color: control.color        
        }    
        
        Label
        {
            id: placeholder
            
            text: control.placeholderText
            font: control.font
            color: control.color
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: control.verticalAlignment
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    
    Loader
    {
        id: _actionsLayoutLoader
//         height: parent.height
anchors.top: parent.top
anchors.bottom: parent.bottom
anchors.margins: 2
        anchors.right: control.right
//         anchors.verticalCenter: parent.verticalCenter
        asynchronous: true
        
        sourceComponent: Row
        {
            z: parent.z + 1
            spacing: Maui.Style.space.medium        
            
            Maui.BasicToolButton
            {
                id: clearButton
                height: parent.height
                flat: true
                focusPolicy: Qt.NoFocus
                
                visible: control.text.length
                icon.name: "edit-clear"
                icon.color: control.color
                icon.height: Maui.Style.iconSizes.medium
                icon.width: Maui.Style.iconSizes.medium
                onClicked:
                {
                    control.clear()
                    cleared()
                }
            }
            
            Repeater
            {
                model: control.actions
                
                Maui.BasicToolButton
                {
                    flat: !checkable
                    height: parent.height
                    focusPolicy: Qt.NoFocus
                    action: modelData
                    icon.color: control.color
                    icon.height: Maui.Style.iconSizes.medium
                    icon.width: Maui.Style.iconSizes.medium
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
        color: control.enabled ? (control.activeFocus ? Kirigami.Theme.backgroundColor : Qt.lighter(Kirigami.Theme.backgroundColor)) : "transparent"
        border.color: control.activeFocus ? Kirigami.Theme.highlightColor : "transparent"
        
        radius: Maui.Style.radiusV
        
        Behavior on color
        {
            ColorAnimation
            {
                easing.type: Easing.InQuad
                duration: Kirigami.Units.longDuration
            }
        }
    }
}
