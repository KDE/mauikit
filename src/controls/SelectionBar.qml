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
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.0
import QtQuick.Templates 2.15 as T

/**
 * SelectionBar
 *
 * A bar to group selected items with a list of actions to perform to the selection.
 * The list of actions is  positioned into a Kirigami ActionToolBar.
 * This control provides methods to append and query elements added to it. To add elements to it, it is necesary to map them,
 * so an item is mapped to an unique id refered here as an URI.
 */
Item
{
    id: control
    
    implicitHeight:  _imp.implicitHeight + Maui.Style.space.big
    implicitWidth: _imp.implicitWidth
    readonly property bool hidden : count === 0
    
    onHiddenChanged:
    {
        if(hidden)
        {
            control.close()
        }else
        {
            control.open()
        }
    }
    
    visible: false
    focus: true
    Keys.enabled: true
    /**
     * actions : list<Action>
     * Default list of actions, the actions are positioned into a Kirigami ActionToolBar.
     */
    default property list<Action> actions
    
    /**
     * hiddenActions : list<Action>
     * List of action that wont be shown, and instead will always hidden and listed in the overflow menu.
     */
    property list<Action> hiddenActions
    
    
    /**
     * display : int
     * Preferred display mode of the visible actions. As icons only, or text beside icons... etc.
     */
    property int display : ToolButton.TextBesideIcon
    
    /**
     * maxListHeight : int
     * The selectionbar can list the grouped items under a collapsable list. This property defines the maximum height the list can take.
     * This can be changed to avoid overlapping the list with other components.
     */
    property int maxListHeight : 400
    
    /**
     * radius : int
     * By default the selectionbar was designed to be floating and thus has a rounded border corners.
     * This property allows to change the border radius.
     */
    property int radius: Maui.Style.radiusV
    
    /**
     * singleSelection : bool
     * if singleSelection is set to true then only a single item can be appended,
     * if another item is added then it replaces the previous one.
     **/
    property bool singleSelection: false
    
    /**
     * uris : var
     * List of URIs associated to the grouped elements.
     */
    readonly property alias uris: _private._uris
    
    /**
     * items : var
     * List of items grouped.
     */
    readonly property alias items: _private._items
    
    /**
     * count : int
     * Size of the elements grouped.
     */
    readonly property alias count : _urisModel.count
    
    //     /**
    //      * background : Rectangle
    //      * The default style of the background. This can be customized by changing its properties.
    //      */
    //     property alias background : bg
    
    /**
     * listDelegate : Component
     * Delegate to be used in the component where the grouped elements are listed.
     */
    property Component listDelegate: Maui.ListBrowserDelegate
    {
        id: delegate
        height: Maui.Style.rowHeight * 1.5
        width: ListView.view.width
        
        Kirigami.Theme.backgroundColor: "transparent"
        Kirigami.Theme.textColor: control.Kirigami.Theme.textColor
        
        iconVisible: false
        label1.text: model.uri
        
        checkable: true
        checked: true
        onToggled: control.removeAtIndex(index)
        
        onClicked: control.itemClicked(index)
        onPressAndHold: control.itemPressAndHold(index)
        
    }
    
    /**
     * cleared :
     * Triggered when the selection is cleared by using the close button or calling the clear method.
     */
    signal cleared()
    
    /**
     * exitClicked :
     * Triggered when the selection bar is closed by using the close button or the close method.
     */
    signal exitClicked()
    
    /**
     * itemClicked :
     * Triggered when an item in the selection list view is clicked.
     */
    signal itemClicked(int index)
    
    /**
     * itemPressAndHold :
     * Triggered when an item in the selection list view is pressed and hold.
     */
    signal itemPressAndHold(int index)
    
    /**
     * itemAdded :
     * Triggered when an item newly added to the selection.
     */
    signal itemAdded(var item)
    
    /**
     * itemRemoved :
     * Triggered when an item has been removed from the selection.
     */
    signal itemRemoved(var item)
    
    /**
     * uriAdded :
     * Triggered when an item newly added to the selection. This signal only sends the refered URI of the item.
     */
    signal uriAdded(string uri)
    
    /** uriRemoved:
     * Triggered when an item has been removed from the selection. This signal only sends the refered URI of the item.
     */
    signal uriRemoved(string uri)
    
    /**
     * clicked :
     * Triggered when an empty area of the selectionbar has been clicked.
     */
    signal clicked(var mouse)
    
    /**
     * rightClicked :
     * Triggered when an empty area of the selectionbar has been right clicked.
     */
    signal rightClicked(var mouse)
    
    /**
     * urisDropped :
     * Triggered when a group of URIs has been dropped.
     */
    signal urisDropped(var uris)
    
    property QtObject m_private : QtObject
    {
        id: _private
        property var _uris : []
        property var _items : []
    }
    
    ListModel
    {
        id: _urisModel
    }
    
    Loader
    {
        id: _loader
        active: control.visible
    }
    
    Component
    {
        id: _listContainerComponent
        
        Maui.Popup
        {
            parent: control
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            modal: true
            height: Math.min(Math.min(400, control.maxListHeight), selectionList.contentHeight) + Maui.Style.space.big
            width: Math.max(600, parent.width)
            
            y: ((height) * -1) - Maui.Style.space.big
            x: Math.round( parent.width / 2 - width / 2 )
            
            Maui.ListBrowser
            {
                id: selectionList
                
                anchors.fill: parent
                spacing: Maui.Style.space.small
                model: _urisModel
                
                delegate: control.listDelegate
            }
        }
    }
    
    T.Control
    {
        id: _imp
        
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        implicitWidth: implicitContentWidth + leftPadding + rightPadding

        width: control.width

        padding: 0
        topPadding: padding
        bottomPadding: padding
        rightPadding: padding
        leftPadding: padding
        
        y: control.height
        
        ParallelAnimation
        {
            id: _openAnimation
            NumberAnimation
            {
                target: _imp
                property: "y"
                from: _imp.height
                to: Maui.Style.space.big/2
                duration: Kirigami.Units.longDuration*1
                easing.type: Easing.OutBack
                
            }
            
            NumberAnimation
            {
                target: _imp
                property: "scale"
                from: 0.5
                to: 1
                duration: Kirigami.Units.longDuration*1
                easing.type: Easing.OutQuad
            }
            
            //NumberAnimation
            //{
            //target: _imp
            //property: "opacity"
            //from: 0
            //to: 1
            //duration: Kirigami.Units.longDuration*2
            //easing.type: Easing.InBack
            //}
        }
        
        ParallelAnimation
        {
            id: _closeAnimation
            NumberAnimation
            {
                target: _imp
                property: "y"
                from: Maui.Style.space.big/2
                to: _imp.height
                duration: Kirigami.Units.longDuration*1
                easing.type: Easing.InBack
                
            }
            
            NumberAnimation
            {
                target: _imp
                property: "scale"
                from: 1
                to: 0.5
                duration: Kirigami.Units.longDuration*1
                easing.type: Easing.InQuad
                
            }
            
            //NumberAnimation
            //{
            //target: _imp
            //property: "opacity"
            //from: 1
            //to: 0
            //duration: Kirigami.Units.longDuration*2
            //easing.type: Easing.OutBack

            //}
            
            onFinished: control.visible = false
        }
        
        
        focus: true
        
        background: Rectangle
        {
            id: bg
            color: Kirigami.Theme.backgroundColor
            radius: control.radius

            Behavior on color
            {
                ColorAnimation
                {
                    easing.type: Easing.InQuad
                    duration: Kirigami.Units.shortDuration
                }
            }

            MouseArea
            {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                propagateComposedEvents: false
                preventStealing: true
                
                onClicked:
                {
                    if(!Kirigami.Settings.isMobile && mouse.button === Qt.RightButton)
                        control.rightClicked(mouse)
                    else
                        control.clicked(mouse)
                }
                
                onPressAndHold :
                {
                    if(Kirigami.Settings.isMobile)
                        control.rightClicked(mouse)
                }
            }
            
            Maui.Rectangle
            {
                opacity: 0.2
                anchors.fill: parent
                anchors.margins: 4
                visible: _dropArea.containsDrag
                color: "transparent"
                borderColor: Kirigami.Theme.textColor
                solidBorder: false
            }
            
            DropArea
            {
                id: _dropArea
                anchors.fill: parent
                onDropped:
                {
                    control.urisDropped(drop.urls)
                }
            }
            
            layer.enabled: true
            layer.effect: DropShadow
            {
                cached: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 16
                color:  "#80000000"
                smooth: true
            }
        }
        
        
        contentItem: Maui.ToolBar
        {
            id: _layout
            
            clip: true
            position: ToolBar.Footer
            //             spacing: Maui.Style.space.big
            //preferredHeight: height
            
            background: null

            Maui.Badge
            {
                id: _counter
                Layout.fillHeight: true
                Layout.margins: Maui.Style.space.medium
                implicitWidth: height
                text: control.count
                radius: Maui.Style.radiusV
                font.pointSize: Maui.Style.fontSizes.big
                Kirigami.Theme.colorSet: control.Kirigami.Theme.colorSet
                Kirigami.Theme.backgroundColor: _loader.item && _loader.item.visible ?
                                                    Kirigami.Theme.highlightColor : Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
                border.color: "transparent"

                //                 onTextChanged: _counterAnimation.start()
                //
                //                     ColorAnimation on color
                //                     {
                //                         id:  _counterAnimation
                //
                //                         from: Kirigami.Theme.highlightColor
                //                         to: Kirigami.Theme.backgroundColor
                //                         loops:3
                //                         easing {
                //                             type: Easing.OutElastic
                //                             amplitude: 1.0
                //                             period: 0.5
                //                         }
                //                     }

                onClicked:
                {
                    _loader.sourceComponent = _listContainerComponent
                    _loader.item.open()
                }

                Maui.Rectangle
                {
                    opacity: 0.3
                    anchors.fill: parent
                    anchors.margins: 4
                    visible: _counter.hovered
                    color: "transparent"
                    borderColor: "white"
                    solidBorder: false
                }

                MouseArea
                {
                    id: _mouseArea
                    anchors.fill: parent
                    propagateComposedEvents: true
                    property int startX
                    property int startY
                    Drag.active: drag.active
                    Drag.hotSpot.x: 0
                    Drag.hotSpot.y: 0
                    Drag.dragType: Drag.Automatic
                    Drag.supportedActions: Qt.CopyAction
                    Drag.keys: ["text/plain","text/uri-list"]

                    onPressed:
                    {
                        if( mouse.source !== Qt.MouseEventSynthesizedByQt)
                        {
                            drag.target = _counter
                            _counter.grabToImage(function(result)
                            {
                                _mouseArea.Drag.imageSource = result.url
                            })

                            _mouseArea.Drag.mimeData = { "text/uri-list": control.uris.join("\n")}

                            startX = _counter.x
                            startY = _counter.y

                        }else mouse.accepted = false
                    }

                    onReleased :
                    {
                        _counter.x = startX
                        _counter.y = startY
                    }

                }
            }

            Repeater
            {
                model: control.actions

                ToolButton
                {
                    action: modelData
                    display: control.display
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered || pressed && action.text
                    ToolTip.text: action.text
                }
            }

            Maui.ToolButtonMenu
            {
                icon.name: "overflow-menu"
                visible: content.length > 0
                content: control.hiddenActions
            }

            Maui.CloseButton
            {
                icon.width: Maui.Style.iconSizes.medium
                icon.height: Maui.Style.iconSizes.medium

                onClicked:
                {
                    control.exitClicked()
                }
            }
        }
    }
    
    Keys.onEscapePressed:
    {
        control.exitClicked();
    }
    
    Keys.onBackPressed:
    {
        control.exitClicked();
        event.accepted = true
    }
    
    /**
     * Removes all the items from the selection.
     */
    function clear()
    {
        _private._uris = []
        _private._items = []
        _urisModel.clear()
        control.cleared()
    }
    
    /**
     * Returns an item at a given index
     */
    function itemAt(index)
    {
        if(index < 0 ||  index > control.count)
        {
            return
        }
        return _urisModel.get(index)
    }
    
    /**
     * Remove a single item at a given index
     */
    function removeAtIndex(index)
    {
        if(index < 0)
        {
            return
        }
        
        const item = _urisModel.get(index)
        const uri = item.uri
        
        if(contains(uri))
        {
            _private._uris.splice(index, 1)
            _private._items.splice(index, 1)
            _urisModel.remove(index)
            control.itemRemoved(item)
            control.uriRemoved(uri)
        }
    }
    
    /**
     * Removes an item from thge selection at a given URI
     */
    function removeAtUri(uri)
    {
        removeAtIndex(indexOf(uri))
    }
    
    /**
     *  Return the index of an item in the selection given its URI
     */
    function indexOf(uri)
    {
        return _private._uris.indexOf(uri)
    }
    
    /**
     * Append a new item to the selection associated to the given URI
     */
    function append(uri, item)
    {
        if(!contains(uri))
        {
            if(control.singleSelection)
            {
                clear()
            }
            _private._items.push(item)
            _private._uris.push(uri)
            
            item.uri = uri
            _urisModel.append(item)
            control.itemAdded(item)
            control.uriAdded(uri)
        }
    }
    
    /**
     * Returns a single string with all the URIs separated by a comma.
     */
    function getSelectedUrisString()
    {
        return String(""+_private._uris.join(","))
    }
    
    /**
     * Returns true if the selection contains an item associated to a given URI.
     */
    function contains(uri)
    {
        return _private._uris.includes(uri)
    }
    
    function open()
    {
        if(control.visible)
        {
            return;
        }
        
        control.visible = true
        _openAnimation.start()
    }
    
    function close()
    {
        if(!control.visible)
        {
            return
        }
        _closeAnimation.start()
    }
}
