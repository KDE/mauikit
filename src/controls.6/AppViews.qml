/*
 *   Copyright 2020 Camilo Higuita <milo.h@aol.com>
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

import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/**
 @since org.mauikit.controls 1.2
 
 @brief Views switcher component.
 
 This controls inherits from MauiKit Page, to checkout its inherited properties refer to docs.
 
 The AppViews control presents a set of children items as views - into an horizontal swipe view, that does not jump around when resizing the application window and that takes care of different gestures and keyboard shortcuts for switching/navigating between the views.
 
 This component takes care of creating the button view-ports in its page header.
 
 Each child element represents a view - and each one should have the AppView attached properties to give a title and icon to the view - so that it can be used as the text and icon  for the view-port buttons. Some of the supported attached properties to be used are:
 - AppView.title
 - AppView.iconName
 - AppView.badgeText
 
 @see AppView
 
  @image html AppViews/viewports.png
  @note An AppViews in action. The view ports as buttons in the header - the title is expanded for the current view on a wide mode, but compacted in a narrow space.
 
 @code
AppViews
{
    id: _page
    anchors.fill: parent
    Controls.showCSD: true
    headBar.forceCenterMiddleContent: true

    Rectangle
    {
        AppView.title: "View1"
        AppView.iconName: "love"

        color: "blue"
    }

    Rectangle
    {
        AppView.title: "View2"
        AppView.iconName: "folder"
        AppView.badgeText: "30"
        color: "pink"
    }

    Rectangle
    {
        AppView.title: "View3"
        AppView.iconName: "tag"

        color: "blue"
    }
}
 @endcode
 
 @section notes Notes 
 
 @subsection positioning Positioning & Behaviours
 There is not need to set the size or position of the child elements aka "views" - this component will take care of positioning them in the order they have been declared.
 
 If a child-item or a "view" is hidden via the visible property, then it is also hidden for the view port buttons.
 
  By default this component is not interactive with touch gestures, in order to not steal focus from other horizontal flickable elements - however you can enable it manually.
 @see interactive
 
 @subsection performance Performance
 Ideally do not add too many views, that are loaded simultaneously, since it will affect the application startup time. Instead you can load the views dinamically by using a Loader or the friend control AppViewLoader, which will take care of much of the loading task.
 @see AppViewLoader
 
 Besides taking longer to load - too many views - will also make the header bar too busy with the view-port buttons. This can also be tweaked by setting the maximum number of views visible - the other ones will be tucked away into an overflow menu.
 @see maxViews
 
 @subsection inheritance Inheritance & Shortcuts
 This component inherits for the MauiKit Page control, so you can customize it by using the same properties that can be applied to a Page, such as moving the header to the bottom, adding extra toolbars, enabling the pull-back behaviours, etc.
 @see Page
 
 The first four [4] views can be navigated by using keyboard shortcuts: [Ctrl + 1] [Ctrl + 2] [Ctrl + 3] [Ctrl + 4]
 */
Maui.Page
{
    id: control
    
    /**
     * @brief All the child items declared will become part of the views. For each child element to be visible in the view port buttons, you need to use the AppView attached properties.
     * @see AppView
     * The content layout is handled by a swipe view.
     */
    default property alias content: _swipeView.contentData

    /**
     * @brief The index number of the current view.
     * @property int AppViews::currentIndex
     */
    property alias currentIndex : _swipeView.currentIndex
    
    /**
     * @brief The current item in the view.
     * @property Item AppViews::currentItem
     */
    property alias currentItem : _swipeView.currentItem
    
    /**
     * @brief The total amount of items/views. 
     * @property int AppViews::count
     */
    property alias count : _swipeView.count
    
    /**
     * @brief Sets the views to be interactive by using touch gestures to flick between them.
     * @property bool AppViews::interactive
     */
    property alias interactive : _swipeView.interactive
    
    focus: true
    
    /**
     * @brief Maximum number of views to be shown in the view port buttons at the header bar.
     * The rest of views buttons will be collapsed into a menu button.
     * By default the maximum number is set to 4.
     */
    property int maxViews : 4
    
    headBar.forceCenterMiddleContent: !isWide
    headBar.middleContent: Loader
    {
        asynchronous: true
        Layout.alignment: Qt.AlignCenter

        sourceComponent: Private.ActionGroup
        {
            id: _actionGroup
            currentIndex : _swipeView.currentIndex
            display: ToolButton.TextUnderIcon
            Binding on currentIndex 
            {
                value: _swipeView.currentIndex
                restoreMode: Binding.RestoreValue
            }
            
            onCurrentIndexChanged:
            {
                _swipeView.currentIndex = currentIndex
                //                _actionGroup.currentIndex = control.currentIndex
            }
            
            Component.onCompleted:
            {
                for(var i in _swipeView.contentChildren)
                {
                    const obj = _swipeView.contentChildren[i]
                    
                    if(obj.Maui.AppView.title || obj.Maui.AppView.iconName)
                    {
                        if(_actionGroup.items.length < control.maxViews)
                        {
                            _actionGroup.items.push(obj)
                        }else
                        {
                            _actionGroup.hiddenItems.push(obj)
                        }
                    }
                }
            }
        }
    }
    
    SwipeView
    {
        id:_swipeView   
        anchors.fill: parent
        interactive: false
        
        onCurrentItemChanged:
        {
            currentItem.forceActiveFocus()
            _listView.positionViewAtIndex(control.currentIndex , ListView.SnapPosition)
            history.push(_swipeView.currentIndex)
        }
        
        Keys.onBackPressed:
        {
            control.goBack()
        }
        
        Shortcut
        {
            sequence: StandardKey.Back
            onActivated: control.goBack()
        }
        
        background: null
        padding: 0
        
        contentItem: ListView
        {
            id: _listView
            model: _swipeView.contentModel
            interactive: _swipeView.interactive
            currentIndex: _swipeView.currentIndex
            spacing: _swipeView.spacing
            orientation: _swipeView.orientation
            snapMode: ListView.SnapOneItem
            boundsBehavior: Flickable.StopAtBounds
            clip: _swipeView.clip
            
            preferredHighlightBegin: 0
            preferredHighlightEnd: width
            
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 0
            highlightFollowsCurrentItem: true
            highlightResizeDuration: 0
            highlightMoveVelocity: -1
            highlightResizeVelocity: -1
            
            maximumFlickVelocity: 4 * (_swipeView.orientation === Qt.Horizontal ? width : height)
            
            property int lastPos: 0
            
            onCurrentIndexChanged:
            {
                _listView.lastPos = _listView.contentX
            }            
        }
        
        Keys.enabled: true
        //     Keys.forwardTo:_listView
        Keys.onPressed:
        {
            if((event.key == Qt.Key_1) && (event.modifiers & Qt.ControlModifier))
            {
                if(_swipeView.count > -1 )
                {
                    _swipeView.currentIndex = 0
                }
            }
            
            if((event.key == Qt.Key_2) && (event.modifiers & Qt.ControlModifier))
            {
                if(_swipeView.count > 0 )
                {
                    _swipeView.currentIndex = 1
                }
            }
            
            if((event.key == Qt.Key_3) && (event.modifiers & Qt.ControlModifier))
            {
                if(_swipeView.count > 1 )
                {
                    _swipeView.currentIndex = 2
                }
            }
            
            if((event.key == Qt.Key_4) && (event.modifiers & Qt.ControlModifier))
            {
                if(_swipeView.count > 2 )
                {
                    _swipeView.currentIndex = 3
                }
            }
        }        
    }
    
    
    property QtObject history : QtObject
    {
        property var historyIndexes : []
        
        function pop()
        {
            historyIndexes.pop()
            return historyIndexes.pop()
        }
        
        function push(index)
        {
            historyIndexes.push(index)
        }
        
        function indexes()
        {
            return historyIndexes
        }
    }
    
    /**
     * @brief A quick function to request the control to go back to the previously visited view.
     * A history of visited views is kept, and invoking this method will pop the history one by one .
     */
    function goBack()
    {
        _swipeView.setCurrentIndex(history.pop())
    }
    
}
