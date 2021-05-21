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

import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.14
import org.mauikit.controls 1.2 as Maui
import org.kde.kirigami 2.9 as Kirigami

import "private" as Private

/*!
\since org.mauikit.controls 1.2
\inqmlmodule org.mauikit.controls
\brief View switcher component

Lists the different views declared into a swipe view, that does not jump around
when resizing the application window and that takes care of different gestures for switching the views.

This component takes care of creating the app views port as buttons in the application main header
for switching the views.

By default this component is not interactive when using touch gesture, to not steal fcous from other horizontal
flickable gestures.
 */
SwipeView
{
    id: control
    //     interactive: Kirigami.Settings.hasTransientTouchInput
    interactive: false
    clip: true
    focus: true

    /*!
      Maximum number of views to be shown in the app view port in the header.
      The rest of views buttons will be collapsed into a menu button.
    */
    property int maxViews : 4

    /*!
      The toolbar where the app view buttons will be added.
    */
    property Maui.ToolBar toolbar : window().headBar

    //TODO: grouped property docs
    /*!
      Access to the view port component where the app view buttons is added.
    */

    Component
    {
        id: _viewPortComponent
        Private.ActionGroup
        {
            id: _actionGroup
            currentIndex : control.currentIndex

            Binding on currentIndex {
                value: control.currentIndex
                restoreMode: Binding.RestoreValue
            }

            onCurrentIndexChanged:
            {
                control.currentIndex = currentIndex
                //                _actionGroup.currentIndex = control.currentIndex
            }

            Component.onCompleted:
            {
                for(var i in control.contentChildren)
                {
                    const obj = control.contentChildren[i]

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


    onCurrentItemChanged:
    {
        currentItem.forceActiveFocus()
        _listView.positionViewAtIndex(control.currentIndex , ListView.SnapPosition)
        history.push(control.currentIndex)
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

    contentItem: ListView
    {
        id: _listView
        model: control.contentModel
        interactive: control.interactive
        currentIndex: control.currentIndex
        spacing: control.spacing
        orientation: control.orientation
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds

        preferredHighlightBegin: 0
        preferredHighlightEnd: width

        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 0
        highlightFollowsCurrentItem: true
        highlightResizeDuration: 0
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1

        maximumFlickVelocity: 4 * (control.orientation === Qt.Horizontal ? width : height)

        property int lastPos: 0

        onCurrentIndexChanged:
        {
            _listView.lastPos = _listView.contentX
        }

    }

    Keys.enabled: true
    Keys.onPressed:
    {
        if((event.key == Qt.Key_1) && (event.modifiers & Qt.ControlModifier))
        {
            if(control.count > -1 )
            {
                control.currentIndex = 0
            }
        }

        if((event.key == Qt.Key_2) && (event.modifiers & Qt.ControlModifier))
        {
            if(control.count > 0 )
            {
                control.currentIndex = 1
            }
        }

        if((event.key == Qt.Key_3) && (event.modifiers & Qt.ControlModifier))
        {
            if(control.count > 1 )
            {
                control.currentIndex = 2
            }
        }

        if((event.key == Qt.Key_4) && (event.modifiers & Qt.ControlModifier))
        {
            if(control.count > 2 )
            {
                control.currentIndex = 3
            }
        }
    }

    Component.onCompleted:
    {
        var object = _viewPortComponent.createObject(control.toolbar.middleContent)
        control.toolbar.middleContent.push(object)
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
        control.setCurrentIndex(history.pop())
    }
}
