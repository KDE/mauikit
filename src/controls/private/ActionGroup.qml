/*
 *   Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
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

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    
    implicitWidth: _layout.implicitWidth
    implicitHeight: _layout.implicitHeight
    
    Layout.fillWidth: !root.isWide
    /**
     * 
     */
    default property list<QtObject> items
    
    /**
     * 
     */
    property list<QtObject> hiddenItems
    
    /**
     * 
     */
    property int currentIndex : 0
 
    /**
     * 
     */
    readonly property int count : control.items.length + control.hiddenItems.length
    
    /**
     * 
     */
    signal clicked(int index)
    
    /**
     * 
     */
    signal pressAndHold(int index)
    
    /**
     * 
     */
    signal doubleClicked(int index)
    
    property Component delegate : BasicToolButton
    {
        Layout.alignment: Qt.AlignCenter
//         Layout.preferredWidth: visible ? implicitWidth : 0
       //Layout.fillWidth: true
        autoExclusive: true
        visible: modelData.visible
        checked:  index == control.currentIndex
        //Kirigami.Theme.backgroundColor: modelData.Kirigami.Theme.backgroundColor
        //Kirigami.Theme.highlightColor: modelData.Kirigami.Theme.highlightColor
        icon.name: modelData.Maui.AppView.iconName
        text: modelData.Maui.AppView.title
        flat: display === ToolButton.IconOnly
        
        display: checked ? (!isWide ? ToolButton.IconOnly : ToolButton.TextBesideIcon) : ToolButton.IconOnly
        
        onClicked:
        {
            if(index == control.currentIndex )
            {
                return
            }
            
            control.currentIndex = index
            control.clicked(index)
        }
        
        DropArea
        {
            anchors.fill: parent
            onEntered: control.currentIndex = index
        }
    }
    
    RowLayout
    {
        id: _layout     
        anchors.fill: parent
        spacing: Maui.Style.space.medium
        
        Repeater
        {
            model: control.items
            delegate: control.delegate
        }
        
        BasicToolButton
        {
                    Layout.alignment: Qt.AlignCenter

            readonly property QtObject obj : control.currentIndex >= control.items.length && control.currentIndex < control.count? control.hiddenItems[control.currentIndex - control.items.length] : null
            
            visible: obj && obj.visible
            checked: visible
            autoExclusive: true
            icon.name: obj ? obj.Maui.AppView.iconName : ""
            icon.width: Maui.Style.iconSizes.medium
            icon.height: Maui.Style.iconSizes.medium
            flat: display === ToolButton.IconOnly
            
            display: checked ? (!isWide ? ToolButton.IconOnly : ToolButton.TextBesideIcon) : ToolButton.IconOnly
            
            text: obj ? obj.Maui.AppView.title : ""
            
            Kirigami.Theme.backgroundColor: obj ? obj.Kirigami.Theme.backgroundColor : undefined
            Kirigami.Theme.highlightColor: obj ? obj.Kirigami.Theme.highlightColor: undefined
        }
        
        Maui.ToolButtonMenu
        {
            id: _menuButton
            icon.name: "list-add"
            icon.width: Maui.Style.iconSizes.medium
            icon.height: Maui.Style.iconSizes.medium
            visible: control.hiddenItems.length > 0
            
            Layout.alignment: Qt.AlignCenter
            display: checked ? ToolButton.TextBesideIcon : ToolButton.IconOnly
            
            Behavior on implicitWidth
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }
            
            Repeater
            {
                model: control.hiddenItems

                MenuItem
                {
                    text: modelData.Maui.AppView.title
                    icon.name: modelData.Maui.AppView.iconName
                    autoExclusive: true
                    checkable: true
                    checked: control.currentIndex === control.items.length + index

                    onTriggered:
                    {
                        if(control.items.length + index === control.currentIndex)
                        {
                            return
                        }

                        control.currentIndex = control.items.length + index
                        control.clicked(control.currentIndex)
                    }
                }
            }
        }
    }
}
