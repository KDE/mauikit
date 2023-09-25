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

import org.mauikit.controls as Maui

/**
 * ListBrowser
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Item
{
    id: control
    focus: true
    clip: false
    
    implicitHeight: contentHeight + topPadding + bottomPadding
    implicitWidth: contentWidth + leftPadding + rightPadding
    
    /**
     * model : var
     */
    property alias model : _listView.model
    
    /**
     * delegate : Component
     */
    property alias delegate : _listView.delegate
    
    /**
     * section : ListView.section
     */
    property alias section : _listView.section
    
    /**
     * contentY : int
     */
    property alias contentY: _listView.contentY
    
    /**
     * contentX : int
     */
    property alias contentX: _listView.contentX
    
    
    /**
     * currentIndex : int
     */
    property alias currentIndex : _listView.currentIndex
    
    /**
     * currentItem : Item
     */
    property alias currentItem : _listView.currentItem
    
    /**
     * count : int
     */
    property alias count : _listView.count
    
    /**
     * cacheBuffer : int
     */
    property alias cacheBuffer : _listView.cacheBuffer
    
    /**
     * orientation : ListView.orientation
     */
    property alias orientation: _listView.orientation
    
    /**
     * snapMode : ListView.snapMode
     */
    property alias snapMode: _listView.snapMode
    
    /**
     * spacing : int
     */
    property alias spacing: _listView.spacing
    
    /**
     * flickable : Flickable
     */
    property alias flickable : _listView
    
    /**
     * scrollView : ScrollView
     */
    property alias scrollView : _scrollView
    
    /**
     * contentHeight : int
     */
    property alias contentHeight : _listView.contentHeight
    
    /**
     * contentWidth : int
     */
    property alias contentWidth : _listView.contentWidth
    
    /**
     * atYEnd : bool
     */
    property alias atYEnd : _listView.atYEnd
    
    /**
     * atYBeginning : bool
     */
    property alias atYBeginning : _listView.atYBeginning
    
    /**
     * topPadding : int
     */
    property alias topPadding: _scrollView.topPadding
    
    /**
     * bottomPadding : int
     */
    property alias bottomPadding: _scrollView.bottomPadding
    
    /**
     * rightPadding : int
     */
    property alias rightPadding: _scrollView.rightPadding
    
    /**
     * leftPadding : int
     */
    property alias leftPadding: _scrollView.leftPadding
    
    /**
     * padding : int
     */
    property alias padding: _scrollView.padding
    
    /**
     * leftMargin : int
     */
    property int verticalScrollBarPolicy:
    {
        if(control.orientation === ListView.Horizontal)
            return ScrollBar.AlwaysOff

        switch(Maui.Style.scrollBarPolicy)
        {
        case Maui.Style.AlwaysOn: return ScrollBar.AlwaysOn;
        case Maui.Style.AlwaysOff: return ScrollBar.AlwaysOff;
        case Maui.Style.AsNeeded: return ScrollBar.AsNeeded;
        case Maui.Style.AutoHide: return ScrollBar.AsNeeded;
        }
    }
    
    /**
     * horizontalScrollBarPolicy : ScrollBar.policy
     */
    property int horizontalScrollBarPolicy:
    {
        if(control.orientation === ListView.Vertical)
            return ScrollBar.AlwaysOff

        switch(Maui.Style.scrollBarPolicy)
        {
        case Maui.Style.AlwaysOn: return ScrollBar.AlwaysOn;
        case Maui.Style.AlwaysOff: return ScrollBar.AlwaysOff;
        case Maui.Style.AsNeeded: return ScrollBar.AsNeeded;
        case Maui.Style.AutoHide: return ScrollBar.AsNeeded;
        }
    }
    
    /**
     * holder : Holder
     */
    property alias holder : _holder
    
    /**
     * enableLassoSelection : bool
     */
    property bool enableLassoSelection : false
    
    /**
     * selectionMode : bool
     */
    property bool selectionMode: false
    
    /**
     * lassoRec : Rectangle
     */
    property bool lassoRec
    
    property alias header : _listView.header
    property alias footer : _listView.footer
    
    property alias availableWidth: _listView.width
    
    property alias availableHeight: _listView.height
    
    /**
     * itemsSelected :
     */
    signal itemsSelected(var indexes)
    
    /**
     * areaClicked :
     */
    signal areaClicked(var mouse)
    
    /**
     * areaRightClicked :
     */
    signal areaRightClicked()
    
    /**
     * keyPress :
     */
    signal keyPress(var event)
    
    Keys.enabled : true
    Keys.forwardTo : _listView
    
    ScrollView
    {
        id: _scrollView
        anchors.fill: parent
        clip: control.clip
        // visible: !_holder.visible
        focus: true
        padding: Maui.Style.contentMargins
        orientation: _listView.orientation
        
        ScrollBar.horizontal.policy: control.horizontalScrollBarPolicy
        ScrollBar.vertical.policy: control.verticalScrollBarPolicy

        contentHeight: _listView.contentHeight
        contentWidth: availableWidth

      
            ListView
            {
                id: _listView
                focus: true
                clip: control.cip

                property var selectedIndexes : []


                spacing: Maui.Style.defaultSpacing

                snapMode: ListView.NoSnap

                displayMarginBeginning: Maui.Style.toolBarHeight * 4
                displayMarginEnd: Maui.Style.toolBarHeight * 4

                boundsBehavior: Flickable.StopAtBounds
                boundsMovement: Flickable.StopAtBounds

//                interactive: Maui.Handy.isTouch
                interactive: false
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 0
                highlightResizeDuration : 0

                keyNavigationEnabled : true
                keyNavigationWraps : true
                Keys.onPressed: control.keyPress(event)

                Maui.Holder
                {
                    id: _holder
                    visible: false
                    anchors.fill : parent

                    anchors.topMargin: _listView.headerItem ? _listView.headerItem.height : 0
                    anchors.bottomMargin: _listView.footerItem ?  _listView.footerItem.height : 0
                }
            }
        
    }
}


