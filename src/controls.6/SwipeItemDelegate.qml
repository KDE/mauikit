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

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit ItemDelegate
 * A template base for presenting an upper and under layer of content.
 * 
 * This control inherits from MauiKit ItemDelegate, to checkout its inherited properties refer to the docs.

 * This control is divided into two sections. 
 * First, is the content, which are the elements declared ans the children of this. Those elements are always placed in the surface.
 * @see content
 * Second is a set of QQC2 Action that go to the far right side - either in the superior or inferior surface.
 * That behavior will depend on the `collapse` property value - where `collapse : true` means it will be displayed under the surface.
 
 @note When the quick actions are displayed above in the surface, they will only be discovered upon hovering, otherwise they will stay hidden.
 
 You can review the SwipeBrowserDelegate which serves as an example of how to use this control.
 @see SwipeBrowserDelegate
 * 
 */
Maui.ItemDelegate
{
    id: control

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    /**
     * @brief The implicit height of the underneath area containing the action button.
     */
    readonly property int buttonsHeight: Math.max(_background.implicitHeight, _swipeDelegate.implicitHeight)

    isCurrentItem : ListView.isCurrentItem

    /**
      * @brief The default content children has to be positioned manually, making use of anchors, etc.
      * @property list<QtObject> SwipeItemDelegate::content
      */
    default property alias content : _content.data

        /**
         * @brief Exposed to quickly append more items to the right side of this control in the far right area.
         *.
         * @property list<QtObject> SwipeItemDelegate::actionRow
         */
    property alias actionRow : _background.data
    
    /**
         * @brief Whether the quick actions declared as `quickActions` should be visible or not.
         * By default this is set to `true`
         */
    property bool showQuickActions : true

    /**
         * @brief The actions that goes underneath the control and is revealed by swiping to the left when the `collapse` property is set to `true`, otherwise the actions will be shown in the far right side above.
         */
    property list<Action> quickActions

    /**
      * @brief Whether the actions will go underneath the control or above. 
      * By default this depends on the available space, so it can fit the information labels and the `quickAction` buttons.
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
