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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

Pane
{
    id: control

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding

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

    property int display: ToolButton.TextBesideIcon
    /**
     *
     */
    signal clicked(int index)

    /**
     *
     */
    signal pressAndHold(int index)

    signal itemVisibilityChanged(int index,bool visible)
    /**
     *
     */
    signal doubleClicked(int index)

    Behavior on implicitWidth
    {
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }

    property Component delegate : ToolButton
    {
        id: _buttonDelegate
        // Layout.alignment: Qt.AlignCenter
        autoExclusive: true
        visible: modelData.visible
        onVisibleChanged: control.itemVisibilityChanged(index, visible)
        checked:  index === control.currentIndex

        leftPadding: Maui.Style.space.big
        rightPadding: Maui.Style.space.big

        icon.name: modelData.Maui.Controls.iconName
        text: modelData.Maui.Controls.title

        display: checked ? (!isWide ? ToolButton.IconOnly : ToolButton.TextBesideIcon) : ToolButton.IconOnly

        Maui.Controls.badgeText: modelData.Maui.Controls.badgeText

        onClicked:
        {
            if(index === control.currentIndex )
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

    contentItem: RowLayout
    {
        id: _layout
        spacing: control.spacing

        Repeater
        {
            model: control.items
            delegate: control.delegate
        }

        ToolButton
        {
            // Layout.alignment: Qt.AlignCenter
//             padding: Maui.Style.space.medium
            leftPadding: Maui.Style.space.big
            rightPadding: Maui.Style.space.big
            readonly property QtObject obj : control.currentIndex >= control.items.length && control.currentIndex < control.count? control.hiddenItems[control.currentIndex - control.items.length] : null

            visible: obj && obj.visible
            checked: visible
            autoExclusive: true
            icon.name: obj ? obj.Maui.Controls.iconName : ""

            //                flat: display === ToolButton.IconOnly

            display: checked ? (!isWide ? ToolButton.IconOnly : ToolButton.TextBesideIcon) : ToolButton.IconOnly

            text: obj ? obj.Maui.Controls.title : ""
        }

        Maui.ToolButtonMenu
        {
            id: _menuButton
            icon.name: "overflow-menu"
            visible: control.hiddenItems.length > 0

            Layout.alignment: Qt.AlignCenter
            display: checked ? ToolButton.TextBesideIcon : ToolButton.IconOnly

            Behavior on implicitWidth
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }

            Repeater
            {
                model: control.hiddenItems

                MenuItem
                {
                    text: modelData.Maui.Controls.title
                    icon.name: modelData.Maui.Controls.iconName
                    autoExclusive: true
                    checkable: true
                    checked: control.currentIndex === control.items.length + index
                    showIcon: true

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
