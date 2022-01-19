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
import QtQuick.Controls 2.14

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtQuick.Templates 2.15 as T

/**
 * ItemDelegate
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Control
{
    id: control
    
    hoverEnabled: !Kirigami.Settings.isMobile
    
    padding: 0
    bottomPadding: padding
    rightPadding: padding
    leftPadding: padding
    topPadding: padding
    
    focus: false

    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: control.hovered && control.tooltipText
    ToolTip.text: control.tooltipText

    /**
      * tooltipText : string
      */
    property string tooltipText


    /**
     * content :
     */
    default property alias content : _content.data

    /**
         * mouseArea :
         */
    property alias mouseArea : _mouseArea

    /**
         * draggable :
         */
    property bool draggable: false

    /**
         * isCurrentItem :
         */
    property alias isCurrentItem :  control.highlighted

    /**
         * containsPress :
         */
    property alias containsPress: _mouseArea.containsPress

    /**
         * highlighted :
         */
    property bool highlighted: control.isCurrentItem

    property int radius:  Maui.Style.radiusV

    /**
         * pressed :
         */
    signal pressed(var mouse)

    /**
         * pressAndHold :
         */
    signal pressAndHold(var mouse)

    /**
         * clicked :
         */
    signal clicked(var mouse)

    /**
         * rightClicked :
         */
    signal rightClicked(var mouse)

    /**
         * doubleClicked :
         */
    signal doubleClicked(var mouse)

    Drag.active: mouseArea.drag.active && control.draggable
    Drag.dragType: Drag.Automatic
//     Drag.supportedActions: Qt.MoveAction
    Drag.hotSpot.x: control.width / 2
    Drag.hotSpot.y: control.height / 2

    contentItem : MouseArea
    {
        id: _mouseArea
        //        scrollGestureEnabled: false
        //        preventStealing: true
        propagateComposedEvents: false
        acceptedButtons:  Qt.RightButton | Qt.LeftButton
        property bool pressAndHoldIgnored : false

        onClicked:
        {
            if(mouse.button === Qt.RightButton)
            {
                control.rightClicked(mouse)
            }
            else
            {
                control.clicked(mouse)
            }
        }

        onDoubleClicked:
        {
            control.doubleClicked(mouse)
        }

        onPressed:
        {
            if(control.draggable && mouse.source !== Qt.MouseEventSynthesizedByQt)
            {
                drag.target = _content
                control.grabToImage(function(result)
                {
                    control.Drag.imageSource = result.url
                })
            }else
            {
                drag.target = null
            }

            _mouseArea.pressAndHoldIgnored = false
            control.pressed(mouse)
        }

        onReleased :
        {
            _content.x = 0
            _content.y = 0
            if(control.draggable)
            {
                drag.target = null
            }

            if(_mouseArea.pressAndHoldIgnored)
            {
                control.pressAndHold(mouse)
                _mouseArea.pressAndHoldIgnored = false
            }
        }

        onPressAndHold :
        {
            xAnim.running = control.draggable || mouse.source === Qt.MouseEventSynthesizedByQt

            if(control.draggable && mouse.source === Qt.MouseEventSynthesizedByQt && Maui.Handy.isTouch)
            {
                drag.target = _content
                control.grabToImage(function(result)
                {
                    control.Drag.imageSource = result.url
                })
                _mouseArea.pressAndHoldIgnored = true
            }else
            {
                drag.target = null
                control.pressAndHold(mouse)
            }
        }

        onPositionChanged:
        {
            if(control.Drag.active && _mouseArea.pressAndHoldIgnored)
            {
                //                        console.log(control.Drag.active && pressAndHoldIgnored)
                _mouseArea.pressAndHoldIgnored = false
                mouse.accepted = true
            }
        }

        Item
        {
            id: _content
            
            height: parent.height
            width: parent.width

            SequentialAnimation on y
            {
                id: xAnim
                // Animations on properties start running by default
                running: false
                loops: 3
                NumberAnimation { from: 0; to: -10; duration: 200; easing.type: Easing.InBack }
                NumberAnimation { from: -10; to: 0; duration: 200; easing.type: Easing.OutBack }
                PauseAnimation { duration: 50 } // This puts a bit of time between the loop
            }
        }
    }


    background: Rectangle
    {
        Behavior on color
        {
            ColorAnimation
            {
                easing.type: Easing.InQuad
                duration: Kirigami.Units.longDuration
            }
        }

        color: control.hovered  ? control.Kirigami.Theme.hoverColor : (control.isCurrentItem || _mouseArea.containsPress ? control.Kirigami.Theme.highlightColor: "transparent")

        radius: control.radius
    }
}

