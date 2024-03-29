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

import org.mauikit.controls 1.3 as Maui
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
    
    hoverEnabled: !Maui.Handy.isMobile
    
    padding: 0
    
    focus: true

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
    
    property bool flat : !Maui.Handy.isMobile

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
        
        propagateComposedEvents: false
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        
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
                // drag.target = null
            }
            // 
            _mouseArea.pressAndHoldIgnored = false
            control.pressed(mouse)
        }

        onReleased :
        {
            _content.x = 0
            _content.y = 0
//            if(control.draggable)
//            {
//                drag.target = null
//            }
            console.log("DROPPING DRAG", _mouseArea.pressAndHoldIgnored)

            if(!mouseArea.drag.active && _mouseArea.pressAndHoldIgnored)
            {
                control.pressAndHold(mouse)
                _mouseArea.pressAndHoldIgnored = false
            }
        }

        onPressAndHold :
        {
            xAnim.running = control.draggable || mouse.source === Qt.MouseEventSynthesizedByQt

            _mouseArea.pressAndHoldIgnored = true

            if(control.draggable && mouse.source === Qt.MouseEventSynthesizedByQt)
            {
                drag.target = _content
                console.log("GETTING DRAG", _mouseArea.pressAndHoldIgnored)
                control.grabToImage(function(result)
                {
                    control.Drag.imageSource = result.url
                })                

            }else
            {
                // drag.target = null
                control.pressAndHold(mouse)
            }
        }

        onPositionChanged:
        {
            if(control.draggable)
            {
                console.log("MOVING DRAG", _mouseArea.pressAndHoldIgnored)
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
        color: control.isCurrentItem || control.containsPress ? Maui.Theme.highlightColor : ( control.hovered ? Maui.Theme.hoverColor : "transparent")
        
        radius: control.radius
    }
}

