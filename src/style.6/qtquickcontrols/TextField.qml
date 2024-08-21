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

import QtQuick
import QtQuick.Window

import org.mauikit.controls as Maui
import QtQuick.Layouts

import QtQuick.Templates as T

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

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: 200

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignLeft

    padding: 0
    property int spacing: Maui.Style.space.small

    leftPadding: icon.visible ? icon.implicitWidth + Maui.Style.space.medium + Maui.Style.space.small : Maui.Style.space.medium
    rightPadding: _rightLayout.implicitWidth + Maui.Style.space.medium

    selectByMouse: !Maui.Handy.isMobile
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    persistentSelection: true
    font: Maui.Style.defaultFont

    wrapMode: TextInput.NoWrap

    /**
     * menu : Menu
     */
    readonly property alias menu : entryMenu

    /**
     * actions : RowLayout
     */
    property list<QtObject> actions

    property alias icon : _icon

    property alias rightContent : _rightLayout.data

    /**
     * cleared
     */
    signal cleared()

    /**
     * contentDropped :
     */
    signal contentDropped(var drop)

    onPressAndHold: (event) =>
                    {
                        if(Maui.Handy.isMobile)
                        {
                            entryMenu.show()
                            event.accepted = true
                            return
                        }

                        event.accepted = false
                        return
                    }

    onPressed: (event) =>
               {
                   if(!Maui.Handy.isMobile && event.button === Qt.RightButton)
                   {
                       entryMenu.show()
                       event.accepted = true
                       return
                   }

                   event.accepted = true
                   return
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
        clip: true

        anchors.fill: parent
        anchors.leftMargin: Maui.Style.space.medium
        spacing: control.spacing

        Maui.Icon
        {
            id: _icon
            visible: source ? true : false
            implicitHeight: visible ? 16 : 0
            implicitWidth: height
            color: control.color
        }

        Item
        {
            Layout.preferredHeight: Maui.Style.iconSize + (Maui.Style.defaultPadding * 2) //simulate the implicitHeight of common button controls

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
            text: control.placeholderText
            font: control.font
            color: control.color
            verticalAlignment: control.verticalAlignment
            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            visible: opacity > 0
            opacity: !control.length && !control.preeditText && !control.activeFocus ? 0.5 : 0


            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Row
        {
            id: _rightLayout

            z: parent.z + 1
            spacing: control.spacing

            ToolButton
            {
                flat: !checkable
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
                    focusPolicy: Qt.NoFocus
                    action: modelData
                    checkable: action.checkable
                }
            }
        }
    }

    Loader
    {
        asynchronous: true

        active: control.Maui.Controls.badgeText && control.Maui.Controls.badgeText.length > 0 && control.visible
        visible: active

        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenterOffset: -5

        sourceComponent: Maui.Badge
        {
            text: control.Maui.Controls.badgeText

            padding: 2
            font.pointSize: Maui.Style.fontSizes.tiny

            Maui.Theme.colorSet: Maui.Theme.View
            Maui.Theme.backgroundColor: Maui.Theme.negativeBackgroundColor
            Maui.Theme.textColor: Maui.Theme.negativeTextColor

            OpacityAnimator on opacity
            {
                from: 0
                to: 1
                duration: Maui.Style.units.longDuration
                running: parent.visible
            }

            ScaleAnimator on scale
            {
                from: 0.5
                to: 1
                duration: Maui.Style.units.longDuration
                running: parent.visible
                easing.type: Easing.OutInQuad
            }
        }
    }

    Maui.ContextualMenu
    {
        id: entryMenu

        MenuItem
        {
            text: i18nd("mauikit", "Copy")
            onTriggered: control.copy()
            enabled: control.selectedText.length
        }

        MenuItem
        {
            text: i18nd("mauikit", "Cut")
            onTriggered: control.cut()
            enabled: control.selectedText.length
        }

        MenuItem
        {
            text: i18nd("mauikit", "Paste")
            onTriggered:
            {
                var text = control.paste()
                control.insert(control.cursorPosition, text)
            }
        }

        MenuItem
        {
            text: i18nd("mauikit", "Select All")
            onTriggered: control.selectAll()
            enabled: control.text.length
        }

        MenuItem
        {
            text: i18nd("mauikit", "Undo")
            onTriggered: control.undo()
            enabled: control.canUndo
        }

        MenuItem
        {
            text: i18nd("mauikit", "Redo")
            onTriggered: control.redo()
            enabled: control.canRedo
        }
    }

    Loader
    {
        asynchronous: true
        anchors.fill: parent
        sourceComponent: DropArea
        {
            onDropped: (drop) =>
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

        radius: Maui.Style.radiusV

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
