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

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

T.Pane
{
    id: control
    
    implicitWidth: _layout.implicitWidth +leftPadding + rightPadding
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    spacing: Maui.Style.space.medium
    padding: 0
    background: null
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

    Behavior on implicitWidth
    {
        NumberAnimation
        {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    property Component delegate : Maui.BasicToolButton
    {
        id: _buttonDelegate
        Layout.alignment: Qt.AlignCenter
        //         Layout.preferredWidth: visible ? implicitWidth : 0
        //Layout.fillWidth: true
        autoExclusive: true
        visible: modelData.visible
        checked:  index == control.currentIndex
        padding: Maui.Style.space.medium
        leftPadding: Maui.Style.space.big
        rightPadding: Maui.Style.space.big
        //Kirigami.Theme.backgroundColor: modelData.Kirigami.Theme.backgroundColor
        //Kirigami.Theme.highlightColor: modelData.Kirigami.Theme.highlightColor
        icon.name: modelData.Maui.AppView.iconName
        text: modelData.Maui.AppView.title
        //         flat: display === ToolButton.IconOnly
        font.bold: true
        display: checked ? (!isWide ? ToolButton.IconOnly : ToolButton.TextBesideIcon) : ToolButton.IconOnly

        Maui.Badge
        {
            visible: modelData.Maui.AppView.badgeText
            text: modelData.Maui.AppView.badgeText
            
            anchors.horizontalCenter: parent.right
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 10
            anchors.horizontalCenterOffset: -5
            
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            Kirigami.Theme.backgroundColor: Kirigami.Theme.negativeBackgroundColor
            Kirigami.Theme.textColor: Kirigami.Theme.negativeTextColor
            border.color: Kirigami.Theme.textColor
            
            mouseArea.enabled: false
        }
        //        onCheckedChanged:
        //        {
        //            if(checked)
        //            {
        //                _enterAnim.start()
        //            }else
        //            {
        ////                _exitAnim.start()
        //            }
        //        }

        SequentialAnimation
        {
            id: _enterAnim

            NumberAnimation
            {
                target: _buttonDelegate.kicon
                property: "scale"
                from: 1.5
                to: 1
                duration: 200
                easing.type: Easing.InQuad
            }
//            onFinished:
//            {
//                control.currentIndex = index
//                control.clicked(index)
//            }
        }

        SequentialAnimation
        {
            id: _exitAnim

            NumberAnimation
            {
                target: _buttonDelegate.kicon
                property: "scale"
                from: 1.5
                to: 1
                duration: 200
                easing.type: Easing.InQuad
            }
        }

        onClicked:
        {
            if(index == control.currentIndex )
            {
                return
            }
            if(_buttonDelegate.display === ToolButton.IconOnly)
            {
                _enterAnim.start()
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

    contentItem:  RowLayout
    {
        id: _layout
        spacing: control.spacing


        Repeater
        {
            model: control.items
            delegate: control.delegate
        }

        Maui.BasicToolButton
        {
            Layout.alignment: Qt.AlignCenter
            padding: Maui.Style.space.medium
            leftPadding: Maui.Style.space.big
            rightPadding: Maui.Style.space.big
            readonly property QtObject obj : control.currentIndex >= control.items.length && control.currentIndex < control.count? control.hiddenItems[control.currentIndex - control.items.length] : null

            visible: obj && obj.visible
            checked: visible
            autoExclusive: true
            icon.name: obj ? obj.Maui.AppView.iconName : ""
            icon.width: Maui.Style.iconSizes.medium
            icon.height: Maui.Style.iconSizes.medium
            //                flat: display === ToolButton.IconOnly

            display: checked ? (!isWide ? ToolButton.IconOnly : ToolButton.TextBesideIcon) : ToolButton.IconOnly

            text: obj ? obj.Maui.AppView.title : ""

            //                Kirigami.Theme.backgroundColor: obj ? obj.Kirigami.Theme.backgroundColor : undefined
            //                Kirigami.Theme.highlightColor: obj ? obj.Kirigami.Theme.highlightColor: undefined
        }

        Maui.ToolButtonMenu
        {
            id: _menuButton
            icon.name: "overflow-menu"
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
