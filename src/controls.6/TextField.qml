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
import QtQuick.Controls as QC
import QtQuick.Templates as T

import org.mauikit.controls as Maui
import QtQuick.Layouts


/**
 * TextField
 * A customizable text field for MauiKit applications.
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

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: 200
    property int spacing: Maui.Style.space.small

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

    function setTextColor(control)
    {
        if(control.Maui.Controls.status)
        {
            switch(control.Maui.Controls.status)
            {
            case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
            case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
            case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
            case Maui.Controls.Normal: return control.Maui.Theme.textColor
            }
        }

        return control.Maui.Theme.textColor
    }

    hoverEnabled: !Maui.Handy.isMobile

    opacity: control.enabled ? 1 : 0.5

    color: Maui.Theme.textColor
    selectionColor: Maui.Theme.highlightColor
    selectedTextColor: Maui.Theme.highlightedTextColor
    focus: true

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignLeft

    padding: 0

    leftPadding: Maui.Style.space.medium
    rightPadding: _rightLayout.implicitWidth + Maui.Style.space.medium
    topPadding: _titleLoader.implicitHeight
    topInset: _titleLoader.implicitHeight

    bottomPadding: _subtitleLoader.implicitHeight
    bottomInset: _subtitleLoader.implicitHeight

    selectByMouse: !Maui.Handy.isMobile
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    persistentSelection: true
    font: Maui.Style.defaultFont

    wrapMode: TextInput.NoWrap

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

    background: Rectangle
    {
        implicitHeight: Maui.Style.iconSize
        color: control.enabled ? (control.hovered ? control.Maui.Theme.hoverColor :  control.Maui.Theme.backgroundColor) : "transparent"

        radius: Maui.Style.radiusV

        Behavior on color
        {
            Maui.ColorTransition{}
        }

        Behavior on border.color
        {
            Maui.ColorTransition{}
        }

        border.color: statusColor(control)

        function statusColor(control)
        {
            if(control.Maui.Controls.status)
            {
                switch(control.Maui.Controls.status)
                {
                case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
                case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
                case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
                case Maui.Controls.Normal:
                default:
                    return "transparent"
                }
            }

            return "transparent"
        }
    }

    Loader
    {
        id: _titleLoader
        active: control.Maui.Controls.title && control.Maui.Controls.title.length > 0
        visible: active

        anchors.bottom: _layout.top

        sourceComponent: QC.Label
        {
            text: control.Maui.Controls.title
            color: setTextColor(control)
            bottomPadding: Maui.Style.defaultSpacing
            elide:Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }

    Loader
    {
        id: _subtitleLoader
        active: control.Maui.Controls.subtitle && control.Maui.Controls.subtitle.length > 0
        visible: active

        anchors.top: _layout.bottom

        sourceComponent: QC.Label
        {
            text: control.Maui.Controls.subtitle
            font.pointSize: Maui.Style.fontSizes.small
            opacity: 0.6
            color: setTextColor(control)
            topPadding: Maui.Style.defaultSpacing
            elide:Text.ElideRight
            wrapMode: Text.WordWrap
        }
    }


    RowLayout
    {
        id: _layout
        clip: true

        anchors.fill: parent

        anchors.topMargin: _titleLoader.implicitHeight
        anchors.bottomMargin: _subtitleLoader.implicitHeight

        anchors.leftMargin: Maui.Style.space.medium
        anchors.rightMargin: _badgeLoader.visible ? 8 : 0

        spacing: control.spacing

        Maui.Icon
        {
            id: _icon
            visible: source ? true : false
            implicitHeight: visible ? 16 : 0
            implicitWidth: height
            color: control.color
            opacity: placeholder.opacity
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

        QC.Label
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

            QC.ToolButton
            {
                flat: !checkable
                focusPolicy: Qt.NoFocus
                topInset: 2
                rightInset: 2
                bottomInset: 2
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

                QC.ToolButton
                {
                    flat: !checkable
                    focusPolicy: Qt.NoFocus
                    action: modelData
                    checkable: action.checkable
                    topInset: 2
                    rightInset: 2
                    bottomInset: 2
                }
            }
        }
    }

    Loader
    {
        id: _badgeLoader
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

        QC.MenuItem
        {
            text: i18nd("mauikit", "Copy")
            onTriggered: control.copy()
            enabled: control.selectedText.length
        }

        QC.MenuItem
        {
            text: i18nd("mauikit", "Cut")
            onTriggered: control.cut()
            enabled: control.selectedText.length
        }

        QC.MenuItem
        {
            text: i18nd("mauikit", "Paste")
            onTriggered:
            {
                var text = control.paste()
                control.insert(control.cursorPosition, text)
            }
        }

        QC.MenuItem
        {
            text: i18nd("mauikit", "Select All")
            onTriggered: control.selectAll()
            enabled: control.text.length
        }

        QC.MenuItem
        {
            text: i18nd("mauikit", "Undo")
            onTriggered: control.undo()
            enabled: control.canUndo
        }

        QC.MenuItem
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

    // Loader
    // {
    //     active: control.Maui.Controls.subtitle && control.Maui.Controls.subtitle.length > 0
    //     visible: active
    //     height: visible ? implicitHeight : -_mainLayout.spacing
    //     Layout.fillWidth: true

    //     sourceComponent: QC.Label
    //     {
    //         text: control.Maui.Controls.subtitle
    //         font.pointSize: Maui.Style.fontSizes.small
    //         opacity: 0.6
    //         color: setTextColor(control)
    //     }
    // }
}

