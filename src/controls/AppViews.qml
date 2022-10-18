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

import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.2 as Maui

import "private" as Private

/*!
 * \since org.mauikit.controls 1.2
 * \inqmlmodule org.mauikit.controls
 * \brief View switcher component
 *
 * Lists the different views declared into a swipe view, that does not jump around
 * when resizing the application window and that takes care of different gestures for switching the views.
 *
 * This component takes care of creating the app views port as buttons in the application main header
 * for switching the views.
 *
 * By default this component is not interactive when using touch gesture, to not steal fcous from other horizontal
 * flickable gestures.
 */
Maui.Page
{
    id: control
    
    default property alias content: _swipeView.contentData

    property alias currentIndex : _swipeView.currentIndex
    property alias currentItem : _swipeView.currentItem
    property alias count : _swipeView.count
    property alias interactive : _swipeView.interactive
    
    focus: true
    
    /*!
     *     Maximum number of views to be shown in the app* view port in the header.
     *     The rest of views buttons will be collapsed into a menu button.
     */
    property int maxViews : 4
    
    /*!
     *     The toolbar where the app view buttons will be* added.
     */
    headBar.forceCenterMiddleContent: false
    headBar.middleContent: Loader
    {
        asynchronous: true
        Layout.alignment: Qt.AlignLeft

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
    
    T.SwipeView
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
     * 
     */
    function goBack()
    {
        _swipeView.setCurrentIndex(history.pop())
    }
    
}
