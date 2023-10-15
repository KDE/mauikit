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

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Controls.Control
 * @brief ItemDelegate is the base for the MauiKit delegate controls. 
 * It is radically different from QQC2 ItemDelegate.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-control.html">This controls inherits from QQC2 Control, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * This is just a container with some predefined features to allow items using it to be drag and drop, and allow long-press selection to trigger contextual actions.
 * 
 * Some of the controls that inherit from this are the GridBrowserDelegate adn ListBrowserDelegate.
 * 
 * @section features Features
 * 
 * Setting up the drag and drop feature requires a few lines. To start you need to set `draggable: true`, and after that set up what the drag data will contain.:
 * 
 * @code
 * ItemDelegate
 * {
 *    draggable: true
 * 
 *    Drag.keys: ["text/uri-list"]
 *    Drag.mimeData: { "text/uri-list": "file:/path/one.txt,file:/path/two.txt,file:/path/three.txt" } //a dummy example of three paths in a single string separated by comma.
 * }
 * @endcode
 * 
 * Another feature is to react to a long-press - to emulate a "right-click" - sent by a touch gesture in a mobile device, where it could mean a request to launch some contextual action menu for the item.
 * 
 * @attention The long-press can either launch the drag-and-drop (DnD) or the contextual request via the `pressAndHold` signal. If after a long press the item is dragged while maintaining the pressed it will launch the DnD action, but if the long-press is released then it will launch the signal `pressAndHold`.
 * @see pressAndHold 
 */
Control
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
     * @brief The text used for the tool-tip, revealed when the item is hovered with the mouse cursor.
     * This type of text usually presents to the user with some extra information about the item.
     */
    property string tooltipText
    
    
    /**
     * @brief The children items of this item will be place by default inside an Item.
     * Ideally there is only one single child element. The children elements need to be positioned manually, using either anchors or coordinates and explicit sizes.
     * @code
     * Maui.ItemDelegate
     * {
    *   Rectangle //the single child element
     *  {
     *      anchors.fill: parent
     *      color: "pink"
     *  }
     * }
     * @endcode
     * 
     * @property list<QtObject> ItemDelegate::content
     */
    default property alias content : _content.data
        
        /**
         * @brief An alias to the MouseArea handling the press events.
         * @note See Qt documentation on the MouseArea for more information.
         * @property MouseArea ItemDelegate::mouseArea
         */
        readonly property alias mouseArea : _mouseArea
        
        /**
         * @brief Whether the item should respond to a drag event after have been pressed for a long time.
         * If this is set to `true`, after the long press and a drag movement, the item contain will be captured as the Drag image source. And the drag target will be set to enable dropping the element.
         * By default this is set to `false`.
         */
        property bool draggable: false
        
        /**
         * @brief Whether the item should be styled in a "selected/checked" state.
         * This is an alias to the `highlighted` property.
         * @property bool ItemDelegate::isCurrentItem
         */
        property alias isCurrentItem :  control.highlighted
        
        /**
         * @brief Whether the item is currently being pressed.
         * This is an alias to `mouseArea.containsPress` property.
         * @property bool ItemDelegate::containsPress
         */
        property alias containsPress: _mouseArea.containsPress
        
        /**
         * @brief Whether the item is being highlighted. A visual clue will be use to indicate the highlighted state.
         * By default this is set to `false`.
         */
        property bool highlighted: false
        
        /**
         * @brief The border radius of the background. 
         * @By default this is set to `Style.radiusV`, which picks the system preference for the radius of rounded elements corners.
         */
        property int radius:  Maui.Style.radiusV
        
        /**
         * @brief Whether the item should be styled as a flat element. A flat element usually does not have any selected state or background.
         * By default this property is set to `!Handy.isMobile"
         * @see Handy::isMobile
         */
        property bool flat : !Maui.Handy.isMobile
        
        /**
         * @brief Emitted when the item has been pressed.
         * @param mouse The object with the event information.
         */
        signal pressed(var mouse)
        
        /**
         * @brief Emitted when the item has been pressed and hold for a few seconds.
         * @param mouse The object with the event information.
         */
        signal pressAndHold(var mouse)
        
        /**
         * @brief Emitted when the item has been clicked - this means that the item has been pressed and then released.
         * @param mouse The object with the event information.
         */
        signal clicked(var mouse)
        
        /**
         * @brief Emitted when the item has been right clicked. Usually with a mouse device.
         * @param mouse The object with the event information.
         */
        signal rightClicked(var mouse)
        
        /**
         * @brief Emitted when the item has been double clicked in a short period of time.
         * @param mouse The object with the event information.
         */
        signal doubleClicked(var mouse)
        
        Drag.active: mouseArea.drag.active && control.draggable
        Drag.dragType: Drag.Automatic
        //     Drag.supportedActions: Qt.MoveAction
        Drag.hotSpot.x: control.width / 2
        Drag.hotSpot.y: control.height / 2
        
        contentItem: MouseArea
        {
            id: _mouseArea
            
            propagateComposedEvents: false
            acceptedButtons: Qt.RightButton | Qt.LeftButton
            
            property bool pressAndHoldIgnored : false
            
            onClicked: (mouse) =>
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
            
            onDoubleClicked: (mouse) =>
            {
                control.doubleClicked(mouse)
            }
            
            onPressed: (mouse) =>
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
            
            onReleased : (mouse) =>
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
            
            onPressAndHold : (mouse) =>
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
            
            onPositionChanged: (mouse) =>
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

