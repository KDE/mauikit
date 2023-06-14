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
import QtQuick.Layouts
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * SwipeItemDelegate
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.ItemDelegate
{
    id: control

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    readonly property int buttonsHeight: Math.max(_background.implicitHeight, _swipeDelegate.implicitHeight)

    isCurrentItem : ListView.isCurrentItem

    /**
      * content : Item.data
      */
    default property alias content : _content.data

    property alias actionRow : _background.data
    /**
      * showQuickActions : bool
      */
    property bool showQuickActions : true

    /**
      * quickActions : list<Action>
      */
    property list<Action> quickActions

    /**
      * collapse : bool
      */
    property bool collapse : width < Maui.Style.units.gridUnit * 26 || Maui.Handy.isMobile

    onCollapseChanged:
    {
        if(_swipeDelegate.swipe.position < 0)
            _swipeDelegate.swipe.close()
    }
    
    background: Rectangle
    {
        color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.95))
        radius: Maui.Style.radiusV
    }

    SwipeDelegate
    {
        id: _swipeDelegate
        anchors.fill: parent
        hoverEnabled: true
        clip: true

        onClicked: control.clicked(null)
        onPressed: control.pressed(null)
        onDoubleClicked: control.doubleClicked(null)
        onPressAndHold: control.pressAndHold(null)

        swipe.enabled: control.collapse && control.showQuickActions
        padding: 0

        background: null


        contentItem: RowLayout
        {
            spacing: control.spacing
            id: _background

            Item
            {
                id: _content
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Loader
            {
                active: control.showQuickActions && !control.collapse
                visible: active && control.hovered
                asynchronous: true

                sourceComponent: Row
                {
                    spacing: control.spacing
                    Layout.alignment: Qt.AlignRight

                    Repeater
                    {
                        model: control.quickActions

                        ToolButton
                        {
                            action: modelData
                        }
                    }
                }
            }

            ToolButton
            {
                visible: control.collapse && control.quickActions.length > 0 && control.showQuickActions
                icon.name: _swipeDelegate.swipe.complete ? "go-next" : "go-previous"
                onClicked: _swipeDelegate.swipe.complete ? _swipeDelegate.swipe.close() : _swipeDelegate.swipe.open(SwipeDelegate.Right)
            }

        }

        swipe.right: Row
        {
            id: _rowActions
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.spacing
            padding: Maui.Style.space.medium
            //                width:  implicitWidth * Math.abs(_swipeDelegate.swipe.position)
            height: parent.height

            opacity: Math.abs(_swipeDelegate.swipe.position) > 0.5 ? 1 : 0

            Repeater
            {
                model: control.quickActions

                ToolButton
                {
                    action: modelData
                    onClicked: _swipeDelegate.swipe.close()
                }
            }
        }
    }
}
