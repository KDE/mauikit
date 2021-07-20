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

import QtQuick 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.14
import QtQuick.Templates 2.15 as T
import QtQuick.Window 2.1

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

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
    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false


    implicitWidth: Math.max(200,
                            placeholderText ? placeholder.implicitWidth + leftPadding + rightPadding : 0)
                            || contentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    /**
      * menu : Menu
      */
    property alias menu : entryMenu

    /**
      * actions : RowLayout
      */
    property list<Action> actions

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



       color: control.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
       selectionColor: Kirigami.Theme.highlightColor
       selectedTextColor: Kirigami.Theme.highlightedTextColor
       verticalAlignment: TextInput.AlignVCenter
       hoverEnabled: !Kirigami.Settings.tabletMode
       renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    rightPadding: _actionsLayout.implicitWidth + Maui.Style.space.small
    padding: 6

    selectByMouse: !Kirigami.Settings.isMobile

    persistentSelection: true
    focus: true

    wrapMode: TextInput.NoWrap

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

    Row
    {
        id: _actionsLayout
        z: parent.z + 1
        spacing: Maui.Style.space.medium

        anchors.right: control.right
        anchors.verticalCenter: parent.verticalCenter

        Maui.BasicToolButton
        {
            property int previousEchoMode
            flat: true
            icon.name: control.echoMode === TextInput.Normal ? "view-hidden" : "view-visible"
            icon.color: control.color
            onClicked:
            {
                if(control.echoMode === TextInput.Normal)
                {
                    control.echoMode = previousEchoMode
                }else
                {
                    control.echoMode = TextInput.Normal
                }
            }

            Component.onCompleted:
            {
                previousEchoMode = control.echoMode
                visible =  control.echoMode === TextInput.Password || control.echoMode === TextInput.PasswordEchoOnEdit
            }
        }

        Maui.BasicToolButton
        {
            id: clearButton
            flat: true
            focusPolicy: Qt.NoFocus

            visible: control.text.length
            icon.name: "edit-clear"
            icon.color: control.color
            icon.height: Maui.Style.iconSizes.small
            icon.width: Maui.Style.iconSizes.small
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
                flat: true
                focusPolicy: Qt.NoFocus
                action: modelData
                icon.height: Maui.Style.iconSizes.small
                icon.width: Maui.Style.iconSizes.small
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

    DropArea
    {
        anchors.fill: parent

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

    Text
    {
           id: placeholder
           anchors.fill: parent
           anchors.margins: Maui.Style.space.medium
           // Work around Qt bug where NativeRendering breaks for non-integer scale factors
           // https://bugreports.qt.io/browse/QTBUG-67007
           renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

           text: control.placeholderText
           font: control.font
           color: Kirigami.Theme.textColor
           opacity: 0.5
           horizontalAlignment: control.activeFocus ? control.horizontalAlignment : Qt.AlignHCenter
           verticalAlignment:  Qt.AlignVCenter
           visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
           elide: Text.ElideRight
       }

    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: Maui.Style.rowHeight

        color: control.activeFocus ? Kirigami.Theme.backgroundColor : Qt.lighter(Kirigami.Theme.backgroundColor)
        border.color: control.activeFocus ? Kirigami.Theme.highlightColor : color

        radius: Maui.Style.radiusV
    }
}
