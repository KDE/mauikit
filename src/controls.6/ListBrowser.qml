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
 * @inherit QtQuick.Item
 *  @brief A browser view with a list layout.
 *  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * This component might seem similar to QQC2 ListView - and it does uses it underneath - but this one includes a few more predefined elements, such as a placeholder element, pinch to zoom gestures, lasso selection support, and some predefined behaviour.
 *
 * @section structure Structure
 * The browser has a dedicated placeholder element handled by MauiKit Holder, where a message can be set when the view is on a determined state the user should be warned about, such as if the view is empty, or not search results were found.
 * @see Holder
 *
 * The lasso selection feature works with a mouse or a track-pad, and allows to select multiple items in the browser-view that are under the lasso rectangle area. A signal is emitted when the selection has been triggered - this is when the lasso rectangle is released - sending as an argument an array of numbers representing the indexes of the selected items.
 * @see itemsSelected
 *
 * @note Consider using as the delegate elements the MauiKit ListBrowserDelegate.
 *
 * To position the delegates you can use the ListView attached properties, such as `ListView.view.width` to set the width of the delegate correctly.
 *
 * @image html Browsers/listbrowser.png
 *
 * @code
 * Maui.ListBrowser
 * {
 *    anchors.fill: parent
 *    model: 60
 *
 *    enableLassoSelection: true
 *    onItemsSelected: (indexes) => console.log(indexes)
 *
 *    delegate: Maui.ListBrowserDelegate
 *    {
 *        width: ListView.view.width
 *        label1.text: "An example delegate."
 *        label2.text: "Using the MauiKit ListBrowser."
 *
 *        iconSource: "folder"
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ListBrowser.qml">You can find a more complete example at this link.</a>
 */
Item
{
    id: control
    focus: true
    clip: false
    
    implicitHeight: contentHeight + topPadding + bottomPadding
    implicitWidth: contentWidth + leftPadding + rightPadding
    
    /**
     * @brief The model to be used to populate the browsing view.
     * @property var ListBrowser::model
     */
    property alias model : _listView.model
    
    /**
     * @brief The component to be used as the delegate.
     * @note Consider using the MauiKit delegate controls, such as ListBrowserDelegate, ListDelegate or LabelDelegate.
     * @property Component ListBrowser::delegate
     */
    property alias delegate : _listView.delegate
    
    /**
     * @brief The section group property to set the ListView sections.
     * Refer to the Qt documentation on the ListView section.
     * @property section ListBrowser::section
     */
    property alias section : _listView.section
    
    /**
     * @brief The position of the view contents on the Y axis.
     * @property double ListBrowser::contentY
     */
    property alias contentY: _listView.contentY
    
    /**
     * @brief The position of the view contents on the X axis.
     * @property double ListBrowser::contentY
     */
    property alias contentX: _listView.contentX

    /**
     * @brief The index number of the current element selected.
     * @note To no break any binding, use the `setCurrentIndex` function.
     * @property int ListBrowser::currentIndex
     */
    property alias currentIndex : _listView.currentIndex
    
    /**
     * @brief The current item selected.
     * @property Item ListBrowser::currentItem
     */
    property alias currentItem : _listView.currentItem
    
    /**
     * @brief The total amount of elements listed in the view.
     * @property int ListBrowser::count
     */
    property alias count : _listView.count
    
    /**
     * @brief The cache buffer.
     * Refer to the QQC2 ListView for proper documentation.
     * @property int ListBrowser::cacheBuffer
     */
    property alias cacheBuffer : _listView.cacheBuffer
    
    /**
     * @brief The orientation of the list view.
     * By default this is set to `ListView.Vertical`.
     * @property enum ListBrowser::orientation
     */
    property alias orientation: _listView.orientation
    
    /**
     * @brief How to snap the elements of the list view while scrolling.
     * @note See Qt documentation.
     * @property enum ListBrowser::snapMode
     */
    property alias snapMode: _listView.snapMode
    
    /**
     * @brief The spacing between the elements in the list view.
     * By default this is set to `Style.defaultSpacing`
     * @property int ListBrowser::spacing
     */
    property alias spacing: _listView.spacing
    
    /**
     * @brief An alias to access the QQC2 ListView.
     * @property ListView ListBrowser::flickable
     */
    readonly property alias flickable : _listView
    
    /**
     * @brief An alias to access the QQC2 ScrollView.
     * @property ScrollView ListBrowser::scrollView
     */
    readonly property alias scrollView : _scrollView
    
    /**
     * @brief The total height of all the elements listed in the view.
     * @property int ListBrowser::contentHeight
     */
    property alias contentHeight : _listView.contentHeight
    
    /**
     * @brief The total width of all the elements.
     * @property int ListBrowser::contentWidth
     */
    property alias contentWidth : _listView.contentWidth
    
    /**
     * @brief Whether the view is positioned at the end on the Y axis.
     * Meant to be used if the view `orientation` has been set to vertical.
     * @property bool ListBrowser::atYEnd
     */
    readonly property alias atYEnd : _listView.atYEnd
    
    /**
     * @brief Whether the view is positioned at the beginning on the Y axis.
    * Meant to be used if the view `orientation` has been set to vertical.
     * @property bool ListBrowser::atYBeginning
     */
    readonly property alias atYBeginning : _listView.atYBeginning
    
    /**
     * @brief The top padding.
     * @see padding
     * @property int ListBrowser::topPadding
     */
    property alias topPadding: _scrollView.topPadding
    
    /**
     * @brief The bottom padding.
     * @see padding
     * @property int ListBrowser::bottomPadding
     */
    property alias bottomPadding: _scrollView.bottomPadding
    
    /**
     * @brief The right padding.
     * @see padding
     * @property int ListBrowser::rightPadding
     */
    property alias rightPadding: _scrollView.rightPadding
    
    /**
     * @brief The left padding.
     * @see padding
     * @property int ListBrowser::leftPadding
     */
    property alias leftPadding: _scrollView.leftPadding
    
    /**
     * @brief The total padding all around the list view. The padding is added to the ScrollView.
     * This is the same as setting `scrollView.padding`.
     * @property int ListBrowser::padding
     */
    property alias padding: _scrollView.padding
    
    /**
     * @brief The policy of the vertical scroll bar from the scroll view.
     * @see scrollView
     * The default value of this is picked based on the Style property `Style.scrollBarPolicy`, unless the orientation of the view is set to horizontal, in which case this is set to 'ScrollBar.AlwaysOff`.
     * Possible values are:
     * - ScrollBar.AlwaysOff
     * - ScrollBar.AlwaysOn
     * - ScrollBar.AsNeeded
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
     * @brief The policy of the horizontal scroll bar from the scroll view.
     * @see scrollView
     * The default value of this is picked based on the Style property `Style.scrollBarPolicy`, unless the orientation of the view is set to vertical, in which case this is set to 'ScrollBar.AlwaysOff`.
     * Possible values are:
     * - ScrollBar.AlwaysOff
     * - ScrollBar.AlwaysOn
     * - ScrollBar.AsNeeded
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
     * @brief An alias to access the placeholder properties. This is handled by a MauiKit Holder.
     * @see Holder::title
     * @see Holder::body
     *
     * @property Holder ListBrowser::holder
     */
    property alias holder : _holder
    
    /**
     * @brief Whether to enable the lasso selection, to select multiple items.
     * By default this is set to `false`.
     * @see itemsSelected
     */
    property bool enableLassoSelection : false
    
    /**
     * @brief
     */
    property bool selectionMode: false

    /**
     * @brief An alias to the lasso rectangle.
     * @property Rectangle ListBrowser::lassoRec
     */
    readonly property alias lassoRec : selectLayer
    
    /**
     * @brief The header section of the ListView element.
     * @see flickable
     * @property Component ListBrowser::header
     */
    property alias header : _listView.header
    
    /**
     * @brief The footer section of the ListView element
     * @see flickable
     * @property Component ListBrowser::footer
     */
    property alias footer : _listView.footer
    
    /**
     * @brief The actual width of the view-port. This is the actual width without any padding.
     * @property int ListBrowser::availableWidth
     */
    readonly property alias availableWidth: _listView.width
    
    /**
     * @brief The actual height of the view-port. This is the actual height without any padding.
     * @property int ListBrowser::availableHeight
     */
    readonly property alias availableHeight: _listView.height
    
    /**
     * @brief Emitted when the lasso selection has been released.
     * @param indexes A array of index numbers is sent as the argument, representing the index value of the items under the lasso rectangle area.
     */
    signal itemsSelected(var indexes)
    
    /**
     * @brief Emitted when an empty space of the background area has been clicked.
     * @param mouse Object with information about the click event.
     */
    signal areaClicked(var mouse)
    
    /**
     * @brief Emitted when an empty space of the area area background has been right clicked.
     */
    signal areaRightClicked()
    
    /**
     * @brief Emitted when a physical key from the device has been pressed.
     * @param event The object with information about the event.
     */
    signal keyPress(var event)
    
    Keys.enabled : true
    Keys.forwardTo : _listView
    
    ScrollView
    {
        id: _scrollView
        anchors.fill: parent
        clip: control.clip
        focus: true
        padding: Maui.Style.contentMargins
        Maui.Controls.orientation: _listView.orientation
        
        ScrollBar.horizontal.policy: control.horizontalScrollBarPolicy
        ScrollBar.vertical.policy: control.verticalScrollBarPolicy
        
        contentHeight: _listView.contentHeight
        contentWidth: availableWidth
        
        ListView
        {
            id: _listView
            focus: true
            clip: control.clip
            
            property var selectedIndexes : []

            spacing: Maui.Style.defaultSpacing
            
            snapMode: ListView.NoSnap
            
            displayMarginBeginning: Maui.Style.toolBarHeight * 4
            displayMarginEnd: Maui.Style.toolBarHeight * 4
            
            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds
            
            interactive: Maui.Handy.hasTransientTouchInput
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration : 0
            
            keyNavigationEnabled : true
            keyNavigationWraps : true

            Keys.onPressed: (event) => control.keyPress(event)
            
            Maui.Holder
            {
                id: _holder
                visible: false
                anchors.fill : parent
                
                anchors.topMargin: _listView.headerItem ? _listView.headerItem.height : 0
                anchors.bottomMargin: _listView.footerItem ?  _listView.footerItem.height : 0
            }
            
            Item
            {
                anchors.fill: parent
                z: parent.z-1
                clip: false

                Loader
                {
                    asynchronous: true
                    anchors.fill: parent
                    //                active: !Maui.Handy.hasTransientTouchInput && !Maui.Handy.isMobile
                    
                    sourceComponent: MouseArea
                    {
                        id: _mouseArea
                        
                        propagateComposedEvents: true
                        preventStealing: true
                        scrollGestureEnabled: false
                        acceptedButtons: Qt.RightButton | Qt.LeftButton
                        
                        onClicked: (mouse) =>
                                   {
                                       console.log("Area clicked")

                                       control.areaClicked(mouse)
                                       control.forceActiveFocus()

                                       if(mouse.button === Qt.RightButton)
                                       {
                                           control.areaRightClicked()
                                           mouse.accepted = true
                                           return
                                       }
                                   }
                        
                        onPositionChanged: (mouse) =>
                                           {
                                               if(_mouseArea.pressed && control.enableLassoSelection && selectLayer.visible)
                                               {
                                                   if(mouseX >= selectLayer.newX)
                                                   {
                                                       selectLayer.width = (mouseX + 10) < (control.x + control.width) ? (mouseX - selectLayer.x) : selectLayer.width;
                                                   } else {
                                                       selectLayer.x = mouseX < control.x ? control.x : mouseX;
                                                       selectLayer.width = selectLayer.newX - selectLayer.x;
                                                   }

                                                   if(mouseY >= selectLayer.newY) {
                                                       selectLayer.height = (mouseY + 10) < (control.y + control.height) ? (mouseY - selectLayer.y) : selectLayer.height;
                                                       if(!_listView.atYEnd &&  mouseY > (control.y + control.height))
                                                       _listView.contentY += 10
                                                   } else {
                                                       selectLayer.y = mouseY < control.y ? control.y : mouseY;
                                                       selectLayer.height = selectLayer.newY - selectLayer.y;

                                                       if(!_listView.atYBeginning && selectLayer.y === 0)
                                                       _listView.contentY -= 10
                                                   }
                                               }
                                           }
                        
                        onPressed: (mouse) =>
                                   {
                                       console.log("MOUSE EVENT SOURCE", mouse.source)
                                       if (mouse.source === Qt.MouseEventNotSynthesized && control.enableLassoSelection && mouse.button === Qt.LeftButton && control.count > 0)
                                       {
                                           selectLayer.visible = true;
                                           selectLayer.x = mouseX;
                                           selectLayer.y = mouseY;
                                           selectLayer.newX = mouseX;
                                           selectLayer.newY = mouseY;
                                           selectLayer.width = 0
                                           selectLayer.height = 0;
                                       }
                                   }
                        
                        onPressAndHold: (mouse) =>
                                        {
                                            if ( mouse.source !== Qt.MouseEventNotSynthesized && control.enableLassoSelection && !selectLayer.visible && !Maui.Handy.hasTransientTouchInput && !Maui.Handy.isAndroid)
                                            {
                                                selectLayer.visible = true;
                                                selectLayer.x = mouseX;
                                                selectLayer.y = mouseY;
                                                selectLayer.newX = mouseX;
                                                selectLayer.newY = mouseY;
                                                selectLayer.width = 0
                                                selectLayer.height = 0;
                                                mouse.accepted = true
                                            }else
                                            {
                                                mouse.accepted = false
                                            }
                                        }
                        
                        onReleased: (mouse) =>
                                    {
                                        if(mouse.button !== Qt.LeftButton || !control.enableLassoSelection || !selectLayer.visible)
                                        {
                                            mouse.accepted = false
                                            return;
                                        }

                                        if(selectLayer.y > _listView.contentHeight)
                                        {
                                            return selectLayer.reset();
                                        }

                                        var lassoIndexes = []
                                        var limitY =  mouse.y === lassoRec.y ?  lassoRec.y+lassoRec.height : mouse.y
                                        var y = lassoRec.y
                                        for(y; y < limitY; y+=10)
                                        {
                                            const index = _listView.indexAt(_listView.width/2,y+_listView.contentY)
                                            if(!lassoIndexes.includes(index) && index>-1 && index< _listView.count)
                                            lassoIndexes.push(index)
                                        }

                                        control.itemsSelected(lassoIndexes)
                                        console.log("INDEXES << " , lassoIndexes, lassoRec.y, limitY)
                                        selectLayer.reset()
                                    }
                    }
                }
            }
            
            Maui.Rectangle
            {
                id: selectLayer
                property int newX: 0
                property int newY: 0
                height: 0
                width: 0
                x: 0
                y: 0
                visible: false
                color: Qt.rgba(control.Maui.Theme.highlightColor.r,control.Maui.Theme.highlightColor.g, control.Maui.Theme.highlightColor.b, 0.2)
                opacity: 0.7
                
                borderColor: control.Maui.Theme.highlightColor
                borderWidth: 2
                solidBorder: false
                
                function reset()
                {
                    selectLayer.x = 0;
                    selectLayer.y = 0;
                    selectLayer.newX = 0;
                    selectLayer.newY = 0;
                    selectLayer.visible = false;
                    selectLayer.width = 0;
                    selectLayer.height = 0;
                }
            }
        }
    }
}


