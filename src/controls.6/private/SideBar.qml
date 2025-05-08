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
import QtQuick.Controls
import QtQml
import org.mauikit.controls as Maui

/**
 @brief The container for the sidebar section in the SideBarView.
 This is the container for the sidebar section in the SideBarView.
 @warning This control is private and can not be used independently. It exists only as part of the SideBarView implementation and can only be accessed via the exposed alias property `sideBar` in said control.
 @see SideBarView

 */
Pane
{
    id: control
    focus: false
    focusPolicy: Qt.NoFocus

    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    /**
     * @brief The SideBarView item to which this sidebar section belongs.
     */
    property Item sideBarView : null

    /**
     * @brief The position of the sidebar. 1 means it is full opened, while 0 means it has been hidden.
     * Values in-between can be used to determined the actual position between the open and hidden states.
     * @property double SideBar::position
     */
    readonly property alias position : _private.position

    /**
     * @brief True when the sidebar is collapse but it is still visible.
     */
    readonly property bool peeking : control.collapsed && control.position > 0

    /**
     * @brief True when the resizing the sidebar by the user action.
     */
    readonly property bool resizing: _dragHandler.active

    /**
     * @brief Where all the sidebar section contents go.
     * @property list<QtObject> AbstractSideBar::content
     */
    default property alias content : _content.data

    /**
     * @brief If the sidebar should be collapsed or not, this property can be used to dynamically collapse the sidebar on constrained spaces.
     * For example, using unit metrics to determine an appropriate size-width restriction: if the application window width is less than 400 pixels then collapse the sidebar, or if the SideBarView main content area width is less than an ideal width size, then collapse the sidebar.
     */
    property bool collapsed: false

    /**
     * @brief Wether the sidebar area can be resized manually by using a cursor or touch gesture. The resizing will be stopped at reaching the minimum and/or maximum values.
     */
    property bool resizeable : !Maui.Handy.isMobile

    /**
     * @brief If when collapsed the sidebar should automatically be hidden or stay in place.
     * By default the sidebar will stay in place, and the SideBarView main area content will be displaced.
     */
    property bool autoHide: false

     /**
     * @brief If when opened/un-collapsed - after have been hidden - the sidebar should automatically be shown or remain hidden.
     * By default the sidebar will be shown as soon as it is un-collapsed.
     */
    property bool autoShow: true

    /**
     * @brief The actual size of the width that the sidebar will have in order to reserve a right margin to never exceed the SideBarView full width.
     * Most of the time this value will be the same as the sidebar preferred width
     */
    readonly property int constrainedWidth : Math.min(control.preferredWidth, control.sideBarView.width*0.9)

     /**
     * @brief The preferred width of the sidebar in the expanded state.
     * This value can be changed by the user action of manually resizing the sidebar.
     */
    property int preferredWidth : Maui.Style.units.gridUnit * 12

    /**
     * @brief The maximum width the sidebar can have when being resized.
     */
    property int maximumWidth:  Maui.Style.units.gridUnit * 20

     /**
     * @brief The minimum width the sidebar can have when being resized.
     */
    property int minimumWidth:  Maui.Style.units.gridUnit * 4

    visible: position > 0

    width: (position * constrainedWidth)

    clip: true

    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    signal opened()
    signal closed()

    background: Rectangle
    {
        opacity: Maui.Style.translucencyAvailable && Maui.Style.enableEffects ? 0.8 :  1
        color: Maui.Theme.backgroundColor
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    QtObject
    {
        id: _private
        property bool initial: true
        property double position
        property int resizeValue
        property int finalWidth : control.constrainedWidth + _dragHandler.centroid.position.x

        //       Binding on resizeValue
        //       {
        //         //delayed: true
        // //         when: _dragHandler.active
        //         value:
        //         restoreMode: Binding.RestoreBindingOrValue
        //       }
        //
        Binding on position
        {
            // when: control.autoHide
            value: control.enabled ? (!control.autoShow ? 0 : (control.collapsed && control.autoHide ? 0 : 1)) : 0
            restoreMode: Binding.RestoreBindingOrValue
        }

        Behavior on position
        {
            enabled: Maui.Style.enableEffects

            NumberAnimation
            {
                duration: Maui.Style.units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    onCollapsedChanged:
    {
        if(control.collapsed || !control.enabled)
        {
            if(control.autoHide)
            {
                control.close()
            }
        }
        else
        {

            if(control.autoShow)
            {
                control.open()
            }
        }
    }

    contentItem: Item
    {
        Item
        {
            id: _content
            width: control.constrainedWidth
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        Loader
        {
            active: control.resizing
            sourceComponent: Item
            {
                Rectangle
                {
                    parent: control.parent
                    id: _resizeTarget
                    width: Math.max(Math.min(_private.finalWidth, control.maximumWidth), control.minimumWidth)
                    height: parent.height
                    color: control.Maui.Theme.backgroundColor

                    HoverHandler
                    {
                        cursorShape: Qt.SizeHorCursor
                    }

                    Maui.Separator
                    {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        weight: Maui.Separator.Weight.Light
                        opacity: 0.4

                        Behavior on color
                        {
                            Maui.ColorTransition{}
                        }
                    }
                }

                Rectangle
                {
                    Maui.Theme.colorSet: Maui.Theme.View
                    Maui.Theme.inherit: false
                    parent: control.parent
                    id: _resizeTarget2
                    anchors.leftMargin:  _resizeTarget.width
                    width: parent.width
                    height: parent.height
                    color: Maui.Theme.backgroundColor
                }
            }
        }

        Rectangle
        {
            visible: control.resizeable
            height: parent.height
            width : 6
            anchors.right: parent.right
            color:  _dragHandler.active ? Maui.Theme.highlightColor : "transparent"

            HoverHandler
            {
                cursorShape: Qt.SizeHorCursor
            }

            DragHandler
            {
                id: _dragHandler
                enabled: control.resizeable
                yAxis.enabled: false
                xAxis.enabled: true
                xAxis.minimum: control.minimumWidth - control.constrainedWidth
                xAxis.maximum: control.maximumWidth - control.constrainedWidth
                target: null
                cursorShape: Qt.SizeHorCursor

                onActiveChanged:
                {
                    let value = control.preferredWidth + _dragHandler.centroid.position.x
                    if(!active)
                    {
                        if(value > control.maximumWidth)
                        {
                            control.preferredWidth = control.maximumWidth
                            return
                        }

                        if( value < control.minimumWidth)
                        {
                            control.preferredWidth = control.minimumWidth
                            return
                        }
                        control.preferredWidth = value
                    }
                }
            }
        }

        // Maui.Separator
        // {
        //     anchors.top: parent.top
        //     anchors.bottom: parent.bottom
        //     anchors.right: parent.right
        //     weight: Maui.Separator.Weight.Light
        //
        //     Behavior on color
        //     {
        //         Maui.ColorTransition{}
        //     }
        // }
    }

    /**
     * @brief Force to open the sidebar and expand it.
     */
    function open()
    {
        _private.position = 1
    }

    /**
     * @brief Force to close the sidebar. This will make the position of the sidebar equal to 0.
     */
    function close()
    {
        _private.position = 0
    }

    /**
     * @brief Switch between the open and closed states.
     */
    function toggle()
    {
        if(_private.position === 0)
        {
            control.open()
        }else
        {
            control.close()
        }
    }
}

