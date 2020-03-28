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

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import org.kde.mauikit 1.1 as MauiLab

Item
{
    id: control
    
    default property list<QtObject> items
    property list<QtObject> hiddenItems
    
    property int currentIndex : 0
    property bool strech: false
    readonly property int count : control.items.length + control.hiddenItems.length
    
    signal clicked(int index)
    signal pressAndHold(int index)
    signal doubleClicked(int index)	
    
    property Component delegate : ToolButton
    {
        id: _delegate
        visible: modelData.visible
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: control.strech
        icon.name: modelData.MauiLab.AppView.iconName
        text: modelData.MauiLab.AppView.title
        icon.width: Maui.Style.iconSizes.medium
        icon.height: Maui.Style.iconSizes.medium
        autoExclusive: true
        checkable: true
        checked: index == control.currentIndex
        display: control.currentIndex === index ? ToolButton.TextBesideIcon : ToolButton.IconOnly
        Kirigami.Theme.backgroundColor: modelData.Kirigami.Theme.backgroundColor
        Kirigami.Theme.highlightColor: modelData.Kirigami.Theme.highlightColor		
        
        Behavior on implicitWidth
        {		
            NumberAnimation
            {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
        
        onClicked: 
        {
            control.currentIndex = index
            control.clicked(index)
        }
        onPressAndHold: control.pressAndHold(index)
        onDoubleClicked: control.doubleClicked(index)
		
		ToolTip.delay: 1000
		ToolTip.timeout: 5000
		ToolTip.visible: _delegate.hovered
		ToolTip.text: text
    }
    
    implicitHeight: parent.height
    implicitWidth: strech ? parent.width : _layout.implicitWidth    
    
    Behavior on implicitWidth
    {		
        NumberAnimation
        {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    RowLayout
    {
        id: _layout
        height: parent.height
        width: control.strech ? parent.width : undefined
        // 		width: Math.min(implicitWidth, parent.width)
        spacing: Maui.Style.space.medium	
        clip: true
        
        Repeater
        {
            model: control.items
            delegate: control.delegate		
        }
        
        ToolButton
        {
            id: _exposedHiddenActionButton
            visible: obj
            Layout.fillWidth: control.strech
            
            readonly property QtObject obj : control.currentIndex >= control.items.length && control.currentIndex < control.count? control.hiddenItems[control.currentIndex - control.items.length] : null
            
            icon.name: obj ? obj.MauiLab.AppView.iconName : ""
            text: obj ? obj.MauiLab.AppView.title : ""
            
            checkable: true
            checked: true
            Layout.alignment: Qt.AlignVCenter
            icon.width: Maui.Style.iconSizes.medium
            icon.height: Maui.Style.iconSizes.medium
            display: ToolButton.TextBesideIcon
            width: visible ? implicitWidth : 0
            Behavior on width
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }		
        
        Maui.ToolButtonMenu
        {
            id: _menuButton
            icon.name: "list-add"
            
			visible: control.hiddenItems.length > 0          
            
            Layout.alignment: Qt.AlignVCenter
            autoExclusive: false
            checkable: true
            display: checked ? ToolButton.TextBesideIcon : ToolButton.IconOnly
            
            menu.closePolicy: Popup.CloseOnReleaseOutsideParent
            
            
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
					text: modelData.MauiLab.AppView.title
                    icon.name: modelData.MauiLab.AppView.iconName
                    autoExclusive: true
                    checkable: true
                    checked: control.currentIndex === control.items.length + index
                    
                    onTriggered:
                    {
						control.currentIndex = control.items.length + index
                        control.clicked(control.currentIndex)
                    }
                }
            }
        }
    }
}