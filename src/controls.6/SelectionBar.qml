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
import QtQuick.Layouts
import QtQuick.Window

import org.mauikit.controls as Maui

import QtQuick.Effects

/**
 * @inherit QtQuick.Item
 * @brief A bar to group selected items and a list of actions to perform to such selection.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * The list of actions is represented by a set of buttons in a horizontal row layout.
 * @see actions
 *
 * This control provides methods to append and query elements added to it. To add elements, it is necesary to map them,
 * so each item has an unique ID referred here as an URI.
 * @see append
 *
 *
 * @image html Misc/selectionbar.png
 *
 * @section notes Notes
 *
 * By default it is hidden when the selection is empty.
 * @see count
 *
 * The SelectionBar is usually placed as the `footer` element of a Page.
 * This control is styled as a floating bar, so it can be placed on top of its parent contents; due to this behavior it is a good idea to pair it with a MauiKit Page as its footer, and set the Page property `floatingFooter: true`.
 *
 * Most of the times this will be uses along with a browsing view, such as a ListBrowser or GridBrowser, which will list the items to be added or removed from the selection.
 *
 * Here we have three components that can be intertwined: Page, ListBrowser and the SelectionBar.
 * For the floating selection bar to not get on the way of the contents, the Page property `flickable` needs to be set to the flickable element of the browsing view, such as the ListBrowser::flickable.
 * @see ListBrowser::flickable
 * @see Page::flickable
 *
 * Below you will find a more complete example of the functionality of these three controls out together.
 *
 * @code
 * Maui.Page
 * {
 *    anchors.fill: parent
 *
 *    Maui.Controls.showCSD: true
 *
 *    floatingFooter: true
 *    flickable: _listBrowser.flickable //helps to keep the content from under the selection bar at the end.
 *
 *    headBar.leftContent: Switch
 *    {
 *        text: "Single selection"
 *        checked: _selectionBar.singleSelection
 *        onToggled: _selectionBar.singleSelection = !_selectionBar.singleSelection
 *    }
 *
 *    Maui.ListBrowser
 *    {
 *        id: _listBrowser
 *
 *        anchors.fill: parent
 *
 *        model: 60
 *
 *        delegate: Maui.ListBrowserDelegate
 *        {
 *            id: _delegate
 *
 *            property string id : index // we need an unique ID for the selectio nbar
 *
 *            width: ListView.view.width
 *
 *            label1.text: "An example delegate."
 *            label2.text: "The ID of this element is " + id
 *
 *            iconSource: "folder"
 *
 *            checkable: true
 *
 *            Connections
 *            {
 *                target: _selectionBar
 *                function onUriRemoved(uri) //watch when a uri is removed from the selection bar
 *                {
 *                    if(uri == _delegate.id)
 *                    {
 *                        _delegate.checked = false
 *                    }
 *                }
 *
 *                function onUriAdded(uri) //watch when an uri is successfully added and mark the delegate as checked
 *                {
 *                    if(uri == _delegate.id)
 *                    {
 *                        _delegate.checked = true
 *                    }
 *                }
 *
 *                function onCleared() //watch when the selection has been cleared and uncheck all the delegates
 *                {
 *                    _delegate.checked = false
 *                }
 *            }
 *
 *            onToggled: (state) =>
 *                        {
 *                            if(state)
 *                            {
 *                                _selectionBar.append(_delegate.id, ({'title': "Testing"}))
 *                            }else
 *                            {
 *                                _selectionBar.removeAtUri(_delegate.id)
 *                            }
 *                        } // when the item is toggled, we mark it as checked and add it to the selection bar, otherwise we unchecked it and remove it from selection.
 *        }
 *    }
 *
 *    footer: Maui.SelectionBar
 *    {
 *        id: _selectionBar
 *
 *        anchors.horizontalCenter: parent.horizontalCenter
 *        width: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)
 *        maxListHeight: root.height - (Maui.Style.contentMargins*2)
 *
 *        Action
 *        {
 *            icon.name: "love"
 *            onTriggered: console.log(_selectionBar.getSelectedUrisString())
 *        }
 *
 *        Action
 *        {
 *            icon.name: "folder"
 *            onTriggered: console.log(_selectionBar.contains("0"))
 *        }
 *
 *        Action
 *        {
 *            icon.name: "list-add"
 *        }
 *
 *        onExitClicked: clear()
 *    }
 * }
 *    @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SelectionBar.qml">You can find a more complete example at this link.</a>
 *
 */
Item
{
    id: control
    
    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary
    
    implicitHeight: _layout.implicitHeight + Maui.Style.space.big
    implicitWidth: _layout.implicitWidth
    
    /**
     * @brief Whether the bar is currently hidden. This is not the same as `visible`.
     * It is hidden when there is not items in the selection.
     */
    readonly property bool hidden : count === 0
    
    onHiddenChanged:
    {
        if(hidden && !singleSelection)
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
     * @brief Default list of QQC2 Action; the actions are represented as buttons.
     * All of the actions listed in here will be visible, to hide some use the `hiddenActions` property.
     * @see hiddenActions
     */
    default property list<Action> actions
    
    /**
     * @brief List of action that won't be shown inside of the bar, but instead will always be hidden and listed in a dedicated overflow menu button.
     */
    property list<Action> hiddenActions
    
    /**
     * @brief The preferred display mode for the visible action buttons.
     * By default this is set to `ToolButton.TextBesideIcon`.
     */
    property int display : ToolButton.TextBesideIcon
    
    /**
     * @brief The list of items can be displayed in a popup. This property defines the maximum height the popup list.
     * By default this is set to `400`.
     */
    property int maxListHeight : 400
    
    /**
     * @brief By default the selection bar was designed to be floating and thus has rounded border corners.
     * This property allows to change the border radius.
     * By default this is set to `Style.radiusV`.
     */
    property int radius: Maui.Style.radiusV
    
    /**
     * @brief Whether the control only accepts a single item.
     * If single selection is set to true then only a single item can be appended, if another item is added then it replaces the previous one.
     * By default this is set to `false`.
     **/
    property bool singleSelection: false
    
    /**
     * @brief The array list of the URIs associated to the selected items.
     * @see items
     * @property var SelectionBar::uris
     */
    readonly property alias uris: _private._uris
    
    /**
     * @brief The array list of the items selected.
     * @property var SelectionBar::items
     */
    readonly property alias items: _private._items
    
    /**
     * @brief Total amount of items selected.
     * @property int SelectionBar::count
     */
    readonly property alias count : _urisModel.count
    
    /**
     * @brief Delegate to be used in popup list.
     * By default this is set to use a MauiKit ListBrowserDelegate.
     * The model use to feed the popup list is a QQC2 ListModel, populated by the `item` passed as the argument to the `append` method.
     * @see append
     */
    property Component listDelegate: Maui.ListBrowserDelegate
    {
        id: delegate
        
        width: ListView.view.width
        
        Maui.Theme.backgroundColor: "transparent"
        Maui.Theme.textColor: control.Maui.Theme.textColor
        
        iconVisible: false
        label1.text: model.uri
        
        checkable: true
        checked: true
        onToggled: control.removeAtIndex(index)
        
        onClicked: control.itemClicked(index)
        onPressAndHold: control.itemPressAndHold(index)
    }
    
    /**
     * @brief Emitted when the selection is cleared either by the constrain of the single selection or by manually calling the clear method.
     */
    signal cleared()
    
    /**
     * @brief Emitted when close button is pressed or the Escape keyboard shortcut invoked.
     */
    signal exitClicked()
    
    /**
     * @brief Emitted when an item in the popup list view is clicked.
     * @paran index the index number of the item clicked.  Use the `itemAt` function to get to the item.
     * @see itemAt
     */
    signal itemClicked(int index)
    
    /**
     * @brief Emitted when an item in the popup list view is pressed for a long time.
     * @paran index the index number of the item clicked.  Use the `itemAt` function to get to the item.
     * @see itemAt
     */
    signal itemPressAndHold(int index)
    
    /**
     * @brief Emitted when an item is newly added to the selection.
     * @param item the item map passed to the `append` function.
     */
    signal itemAdded(var item)
    
    /**
     * @brief Emitted when an item has been removed from the selection.
     * @param item the item map passed to the `append` function.
     */
    signal itemRemoved(var item)
    
    /**
     * @brief Emitted when an item is newly added to the selection. This signal only sends the URI of the item.
     * @param uri the URI identifier
     */
    signal uriAdded(string uri)
    
    /**
     * @brief Emitted when an item has been removed from the selection. This signal only sends the URI of the item.
     * @param uri the URI identifier
     */
    signal uriRemoved(string uri)
    
    /**
     * @brief Emitted when an empty area of the selection bar has been clicked.
     * @param mouse the object with information of the event
     */
    signal clicked(var mouse)
    
    /**
     * @brief Emitted when an empty area of the selection bar has been right clicked.
     * @param mouse the object with information of the event
     */
    signal rightClicked(var mouse)
    
    /**
     * @brief Emitted when a group of URLs has been dropped onto the selection bar area.
     * @param uris the list of urls
     */
    signal urisDropped(var uris)
    
    QtObject
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
        
        Maui.PopupPage
        {
            persistent: false
            
           stack: Maui.ListBrowser
            {
                id: selectionList
                
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: _urisModel
                
                delegate: control.listDelegate
            }
            
            actions: control.actions
        }
    }
    
    ParallelAnimation
    {
        id: _openAnimation
        NumberAnimation
        {
            target: _layout
            property: "y"
            from: _layout.height
            to: Maui.Style.space.big/2
            duration: Maui.Style.units.longDuration*1
            easing.type: Easing.OutBack
        }
        
        NumberAnimation
        {
            target: _layout
            property: "scale"
            from: 0.5
            to: 1
            duration: Maui.Style.units.longDuration*1
            easing.type: Easing.OutQuad
        }
    }
    
    ParallelAnimation
    {
        id: _closeAnimation
        NumberAnimation
        {
            target: _layout
            property: "y"
            from: Maui.Style.space.big/2
            to: _layout.height
            duration: Maui.Style.units.longDuration*1
            easing.type: Easing.InBack
            
        }
        
        NumberAnimation
        {
            target: _layout
            property: "scale"
            from: 1
            to: 0.5
            duration: Maui.Style.units.longDuration*1
            easing.type: Easing.InQuad
            
        }
        
        onFinished: control.visible = false
    }
    
    Maui.ToolBar
    {
        id: _layout
        width: control.width
        padding: Maui.Style.space.medium
        
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.Complementary
        
        forceCenterMiddleContent: false
        position: ToolBar.Footer

        leftContent: Loader
        {
            asynchronous: true
             active: !control.singleSelection && control.count > 1
             visible: active
             
            sourceComponent: ToolButton
        {
            id: _counter
           
            text: control.count
            font.bold: true
            font.weight: Font.Black
            Maui.Theme.colorSet: control.Maui.Theme.colorSet
            Maui.Theme.backgroundColor: _loader.item && _loader.item.visible ?
                                            Maui.Theme.highlightColor : Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))

           flat: false

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

                onPressed: (mouse) =>
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

                               }else
                               {
                                   mouse.accepted = false
                               }
                           }

                onReleased :
                {
                    _counter.x = startX
                    _counter.y = startY
                }

                onClicked:
                {
                    if(!_loader.item)
                    {
                        _loader.sourceComponent = _listContainerComponent
                    }
                    _loader.item.open()
                    console.log("Opening list")
                }
            }
        }
        }

        Repeater
        {
            model: control.actions

            ToolButton
            {
                Maui.Theme.inherit: false
                Maui.Theme.colorSet: Maui.Theme.Complementary

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
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.Complementary

            icon.name: "overflow-menu"
            visible: control.hiddenActions.length > 0
            Repeater
            {
                model:  control.hiddenActions
                delegate: MenuItem
                {
                    action: modelData
                    Maui.Controls.status: modelData.Maui.Controls.status
                }
            }
        }

        rightContent: Maui.CloseButton
        {
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.Complementary

            onClicked:
            {
                control.exitClicked()
            }
        }

        background: Rectangle
        {
            id: bg
            color: Maui.Theme.backgroundColor
            radius: control.radius

            Behavior on color
            {
                Maui.ColorTransition {}
            }

            MouseArea
            {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                propagateComposedEvents: false
                preventStealing: true

                onClicked: (mouse) =>
                           {
                               if(!Maui.Handy.isMobile && mouse.button === Qt.RightButton)
                               control.rightClicked(mouse)
                               else
                               control.clicked(mouse)
                           }

                onPressAndHold : (mouse) =>
                                 {
                                     if(Maui.Handy.isMobile)
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
                borderColor: Maui.Theme.textColor
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
            layer.effect: MultiEffect
            {
                autoPaddingEnabled: true
                shadowEnabled: true
                shadowColor: "#80000000"
            }
        }
    }
    
    Keys.onEscapePressed:
    {
        control.exitClicked();
    }
    
    Keys.onBackPressed: (event) =>
    {
        control.exitClicked();
        event.accepted = true
    }
    
    /**
     * @brief Removes all the items from the selection.
     * Triggers the `cleared` signal.
     * @see cleared
     */
    function clear()
    {
        _private._uris = []
        _private._items = []
        _urisModel.clear()
        control.cleared()
    }
    
    /**
     * @brief Returns an item at the given index
     * @param index the index number of the item.
     * @note Note that this is the index of the internal list on how items were added, and not the original index of the source list used to make the selection.
     * @return the requested item/map if it is found, otherwise null.
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
     * @brief Remove a single item at the given index
     * @param index index of the item in the selection list
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
     * @brief Removes an item from the selection at the given URI
     * @param uri the URI used to append the item
     */
    function removeAtUri(uri)
    {
        removeAtIndex(indexOf(uri))
    }
    
    /**
     * @brief Returns the index of an item in the selection given its URI
     * @param uri the URI used to append the item
     * @return the index number of the found item, otherwise `-1`
     *
     */
    function indexOf(uri)
    {
        return _private._uris.indexOf(uri)
    }
    
    /**
     * @brief Appends a new item to the selection associated to the given URI
     * @param uri the URI to be associated with the item
     * @param item a map to be used to represent the item in the model. For example a valid item map would be: `({'title': "A title", 'icon': "love"})`
     */
    function append(uri, item)
    {
        if(control.singleSelection)
        {
            clear()
        }
        
        if(!contains(uri) || control.singleSelection)
        {
            _private._items.push(item)
            _private._uris.push(uri)
            
            item.uri = uri
            _urisModel.append(item)
            control.itemAdded(item)
            control.uriAdded(uri)
        }
    }
    
    /**
     * @brief Returns a single string with all the URIs separated by a comma.
     */
    function getSelectedUrisString()
    {
        return String(""+_private._uris.join(","))
    }
    
    /**
     * @brief Returns whether the selection contains an item associated to the given URI.
     * @param uri the URI used to append the item
     */
    function contains(uri)
    {
        return _private._uris.includes(uri)
    }
    
    /**
     * @brief Forces to open the selection bar, if hidden.
     */
    function open()
    {
        if(control.visible)
        {
            return;
        }
        
        control.visible = true
        _openAnimation.start()
    }
    
    /**
     * @brief Forces to close the selection bar, if visible.
     */
    function close()
    {
        if(!control.visible)
        {
            return
        }
        _closeAnimation.start()
    }
}
