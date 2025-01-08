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
 * @brief A browser view with a grid layout.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * This component might seem similar to QQC2 GridView - and it does uses it underneath - but this one includes a few more predefined elements, such as auto adaptable uniform cell width, a placeholder element, pinch to zoom gestures, and lasso selection support. 
 * 
 *  @section structure Structure
 * The browser has a dedicated placeholder element handled by MauiKit Holder, where a message can be set when the view is on a determined state the user should be warned about, such as if the view is empty, or not search results were found.
 * @see Holder
 * 
 * The lasso selection feature works with a mouse or a track-pad, and allows to select multiple items in the browser-view that are under the lasso rectangle area. A signal is emitted when the selection has been triggered - this is when the lasso rectangle is released - sending as an argument an array of numbers representing the indexes of the selected items.
 * @see itemsSelected 
 * 
 * @image html Browsers/gridbrowser_resize.gif "The GridBrowser with adaptable content enabled"
 * 
 * @note Notice the yellow rectangles vs the grey ones. The yellow rectangles will preserve the `itemSize` dimensions, while the cell area, represented by the gray rectangle, will vary. The example below demonstrates this behavior.
 * 
 * @section notes Notes
 * Use the `itemSize` property to set an uniform size for the cell item. At first the `cellWidth` will have the same value as the `itemSize`.
 * 
 * If the `adaptContent` is enabled, the cell width will vary, while the cell height will maintain the same value as the `itemSize`. 
 * @see adaptContent
 * 
 * When the view is resized and the `adaptContent` is enabled, the cell width - `cellWidth` - values will be updated to a value that can fill the width of the view-port uniformly. The modified values of the `cellWidth` will never be less than the value defined in the `itemSize` property.
 * @see itemSize
 * 
 * @warning Keep in mind that the `cellWidth` values will be modified when enabling the `adaptContent` property. So any binding to this property will break.
 * 
 * @code
 * Maui.Page
 * {
 *    id: _page
 *    anchors.fill: parent
 *    Maui.Controls.showCSD: true
 *    headBar.forceCenterMiddleContent: true
 * 
 *    headBar.leftContent: Switch
 *    {
 *        text: "Adapt Content"
 *        checked: _gridBrowser.adaptContent
 *        onToggled: _gridBrowser.adaptContent = !_gridBrowser.adaptContent
 *    }
 * 
 *    Maui.GridBrowser
 *    {
 *        id: _gridBrowser
 *        anchors.fill: parent
 *        model: 30
 * 
 *        itemSize: 200
 *        itemHeight: 300
 * 
 *        adaptContent: true
 * 
 *        delegate: Rectangle
 *        {
 *            width: GridView.view.cellWidth
 *            height: GridView.view.cellHeight
 *            color: "gray"
 *            border.color: "white"
 * 
 *            Rectangle
 *            {
 *                width: _gridBrowser.itemSize
 *                height: _gridBrowser.itemSize
 * 
 *                color: "yellow"
 * 
 *                anchors.centerIn: parent
 *            }
 *        }
 *    }
 * }
 * @endcode
 *  
 * @note You can use the GridView attached properties to refer to the control properties from the delegates. For example, you could use `GridView.view.itemSize` or GridView.view.cellWidth`. * 
 *  
 * @image html Browsers/gridbrowser_alt.png "The GridBrowser with adaptable content disabled"
 * 
 * @note Notice the yellow rectangles vs the grey ones. The yellow rectangles will preserve the `itemSize` dimensions, and the cell width - as the gray area- will also keep the same dimensions as `itemSize`.
 *  
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/GridBrowser.qml">You can find a more complete example at this link.</a>
 */
Item
{
    id: control
    focus: true
    clip: false
    
    implicitHeight: contentHeight + topPadding + bottomPadding
    implicitWidth: contentWidth + leftPadding + rightPadding
    
    /**
     * @brief The uniform size of the element in the cell. This value is used for the width and height. This value will stay the same even when the width of the cell changes.
     * 
     * The dimensions of the item can be changed manually for its height and its width.
     * @see itemHeight
     * @see itemWidth
     * 
     * @note This is meant to set an initial uniform size, so notice this value will be use for the `cellWidth`, `cellHeight`, `itemHeight` and `itemWidth`.
     * 
     * @property int GridBrowser::itemSize
     */
    property alias itemSize: controlView.itemSize
    
    /**
     * @brief The width of the element in the cell. This value will vary even if `adaptContent` is enabled.
     * This value is used as the `cellWidth` value by default.
     * @property int GridBrowser::itemWidth
     */
    property alias itemWidth : controlView.itemWidth
    
    /**
     * @brief The height of the element in the cell. This value will vary even if `adaptContent` is enabled.
     * This value is used as the `cellHeight` value by default. 
     * @property int GridBrowser::itemHeight
     */
    property alias itemHeight : controlView.itemHeight
    
    /**
     * @brief The width size of the cell area.
     * 
     * @warning This value will be modified when the viewport area is resized and the `adaptContent` is enabled. So any binding will be lost. To have a fixed cell width value, set `adaptContent: false`.
     * @see adaptContent
     * @property int GridBrowser::cellWidth
     */
    property alias cellWidth: controlView.cellWidth
    
    /**
     * @brief The height size of the cell area.
     * This value is set to the `itemHeight` value, or `itemSize` if the formerly one has not been set.
     * This value will not be modified by the adaptable behaviour.
     * Notice you can make the cell bigger than the itemHeight, in order to create a sense of vertical padding for each cell element.
     * @property int GridBrowser::cellHeight
     */
    property alias cellHeight: controlView.cellHeight
    
    /**
     * @brief The model to be used to populate the browsing view.
     * @property var GridBrowser::model
     */
    property alias model : controlView.model
    
    /**
     * @brief The component to be used as the delegate.
     * @note Consider using the MauiKit delegate controls, such as GridBrowserDelegate, GalleryRollItem or CollageItem.
     * @property Component GridBrowser::delegate
     */
    property alias delegate : controlView.delegate
    
    /**
     * @brief The position of the view contents on the Y axis.
     * @property double GridBrowser::contentY
     */
    property alias contentY: controlView.contentY
    
    /**
     * @brief The index number of the current element selected.
     * @property int GridBrowser::currentIndex
     */
    property alias currentIndex : controlView.currentIndex
    
    /**
     * @brief The total amount of elements listed in the view.
     * @property int GridBrowser::count
     */
    property alias count : controlView.count
    
    /**
     * @brief The cache buffer. 
     * Refer to the QQC2 GridView documentation.
     * @property int GridBrowser::cacheBuffer
     */
    property alias cacheBuffer : controlView.cacheBuffer
    
    /**
     * @brief The element controlling the layout fo element, AKA the flickable element.
     * This is an alias to the QQC2 GridView control.
     * @property GridView GridBrowser::flickable
     */
    property alias flickable : controlView
    
    /**
     * @brief The total height of all the elements listed in the view.
     * @property int GridBrowser::contentHeight
     */
    property alias contentHeight : controlView.contentHeight
    
    /**
     * @brief The total width of all the elements.
     * @property int GridBrowser::contentWidth 
     */
    property alias contentWidth : controlView.contentWidth
    
    /**
     * @brief An alias to the QQC2 ScrollView element attached to the view.
     * @property ScrollView GridBrowser::scrollView
     */
    property alias scrollView: _scrollView
    
    /**
     * @brief Top padding of the view. This padding is added to the scroll view container.
     * @see scrollView
     * @property int GridBrowser::topPadding
     */
    property alias topPadding: _scrollView.topPadding
    
    /**
     * @brief Bottom padding of the view. This padding is added to the scroll view container.
     * @see scrollView
     * @property int GridBrowser::bottomPadding
     */
    property alias bottomPadding: _scrollView.bottomPadding
    
    /**
     * @brief Right padding of the view. This padding is added to the scroll view container.
     * @see scrollView
     * @property int GridBrowser::rightPadding
     */
    property alias rightPadding: _scrollView.rightPadding
    
    /**
     * @brief Left padding of the view. This padding is added to the scroll view container.
     * @see scrollView
     * @property int GridBrowser::leftPadding
     */
    property alias leftPadding: _scrollView.leftPadding
    
    /**
     * @brief Padding of the view. This padding is added to the scroll view container.
     * @see scrollView
     * @property int GridBrowser::padding
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
    property int verticalScrollBarPolicy: switch(Maui.Style.scrollBarPolicy)
                {
                    case Maui.Style.AlwaysOn: return ScrollBar.AlwaysOn;
                    case Maui.Style.AlwaysOff: return ScrollBar.AlwaysOff;
                    case Maui.Style.AsNeeded: return ScrollBar.AsNeeded;
                    case Maui.Style.AutoHide: return ScrollBar.AsNeeded;
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
        if(control.orientation === GridView.Vertical)
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
     * @property Holder GridBrowser::holder
     */
    property alias holder : _holder
    
    /**
     * @brief Whether the width value of the cells should be recalculated when the view-port is resized. This will result in a uniform set of cells. The minimum width of the cells is constrained by the `itemSize` property.
     * By default this is set to `true`.
     */
    property bool adaptContent: true
    onAdaptContentChanged:
    {
        if(adaptContent)
            control.adaptGrid()
            else
                control.resetCellWidth()
    }
    
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
     * @property Rectangle GridBrowser::lassoRec
     */
    readonly property alias lassoRec : selectLayer
    
    /**
     * @brief Whether the pinch-to-zoom gesture is enabled.
     * By default this is set to `false`.
     */
    property bool pinchEnabled : false
    
    /**
     * @brief The current item selected.
     * @property Item GridBrowser::currentItem
     */
    property alias currentItem : controlView.currentItem
    
    /**
     * @brief The header section of the GridView element.
     * @see flickable
     * @property Component GridBrowser::header
     */
    property alias header : controlView.header
    
    /**
     * @brief The footer section of the GridView element
     * @see flickable
     * @property Component GridBrowser::footer
     */
    property alias footer : controlView.footer
    
    /**
     * @brief The actual width of the view-port. This is the actual width without any padding.
     * @property int GridBrowser::availableWidth
     */
    readonly property alias availableWidth: controlView.width
    
    /**
     * @brief The actual height of the view-port. This is the actual height without any padding.
     * @property int GridBrowser::availableHeight
     */
    readonly property alias availableHeight: controlView.height
    
    /**
     * @brief Whether the view is moving horizontally or vertically. This reacts to changes in the content Y and/or X axis.
     * @see contentY
     * @see contentX
     * @property bool GridBrowser::moving
     */
    readonly property alias moving: updateContentDelay.running
    
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
    Keys.forwardTo : controlView
    
    onItemSizeChanged :
    {
        controlView.size_ = itemSize
        control.itemWidth = itemSize
        control.cellWidth = itemWidth
        if(adaptContent)
            control.adaptGrid()
    }
    
    ScrollView
    {
        id: _scrollView
        anchors.fill: parent
        focus: true
        padding: Maui.Style.contentMargins
        
        clip: control.clip
        
        ScrollBar.horizontal.policy: control.horizontalScrollBarPolicy
        ScrollBar.vertical.policy: control.verticalScrollBarPolicy
        
        contentHeight: controlView.contentHeight
        contentWidth: availableWidth
        
        Maui.Controls.orientation: control.Maui.Controls.orientation
        
        GridView
        {
            id: controlView
            focus: true
            
            /**
             * itemSize : int
             */
            property int itemSize: 0
            
            /**
             * itemWidth : int
             */
            property int itemWidth : itemSize
            
            /**
             * itemHeight : int
             */
            property int itemHeight : itemSize
            
            
            property bool firstSelectionPress
            property var selectedIndexes : []
            
            //nasty trick
            property int size_
            Component.onCompleted:
            {
                controlView.size_ = control.itemWidth
            }
            
            flow: GridView.FlowLeftToRight
            clip: control.clip
            
            displayMarginBeginning: Maui.Style.effectsEnabled ? Maui.Style.toolBarHeight * 4 : 0
            displayMarginEnd: displayMarginBeginning
            cacheBuffer: control.itemHeight * 4
            
            cellWidth: control.itemWidth
            cellHeight: control.itemHeight
            
            boundsBehavior: Flickable.StopAtBounds
            
            flickableDirection: Flickable.AutoFlickDirection
            snapMode: GridView.NoSnap
            highlightMoveDuration: 0

            interactive: Maui.Handy.hasTransientTouchInput
            
            onWidthChanged: if(adaptContent) control.adaptGrid()
            onCountChanged: if(adaptContent) control.adaptGrid()
            
            keyNavigationEnabled : true
            keyNavigationWraps : true

            Keys.onPressed: (event) =>
            {
                control.keyPress(event)
            }
            
            Maui.Holder
            {
                id: _holder
                visible: false
                anchors.fill : parent
                anchors.topMargin: controlView.headerItem ? controlView.headerItem.height : 0
                anchors.bottomMargin: controlView.footerItem ? controlView.footerItem.height : 0
            }
            
            onContentXChanged:
            {
                updateContentDelay.restart()
            }
            
            onContentYChanged:
            {
                updateContentDelay.restart()
            }
            
            Timer
            {
                id: updateContentDelay
                interval: 500
                repeat: false
            }
            
            Loader
            {
                asynchronous: true
                active: control.pinchEnabled
                
                anchors.fill: parent
                z: -1
                
                sourceComponent: PinchArea
                {
                    onPinchFinished: (pinch) =>
                    {
                        resizeContent(pinch.scale)
                    }
                }
            }
            
            Loader
            {
                asynchronous: true
                //                active: !Maui.Handy.hasTransientTouchInput && !Maui.Handy.isMobile
                anchors.fill: parent
                z: parent.z-1
                clip: false
                
                sourceComponent: MouseArea
                {
                    id: _mouseArea
                    
                    propagateComposedEvents: true
                    preventStealing: true
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                                            scrollGestureEnabled: false

                    onClicked: (mouse) =>
                    {
                        console.log("Area clicked")
                        control.areaClicked(mouse)
                        control.forceActiveFocus()
                        
                        if(mouse.button === Qt.RightButton)
                        {
                            control.areaRightClicked()
                            return
                        }
                    }
                    
                    onWheel: (wheel) =>
                    {
                        if (wheel.modifiers & Qt.ControlModifier)
                        {
                            if (wheel.angleDelta.y != 0)
                            {
                                var factor = 1 + wheel.angleDelta.y / 600;
                                control.resizeContent(factor)
                            }
                        }else
                            wheel.accepted = false
                    }
                    
                    onPositionChanged: (mouse) =>
                    {
                        console.log("Area clicked >>> Moving")
                        
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
                                if(!controlView.atYEnd &&  mouseY > (control.y + control.height))
                                    controlView.contentY += 10
                            } else {
                                selectLayer.y = mouseY < control.y ? control.y : mouseY;
                                selectLayer.height = selectLayer.newY - selectLayer.y;
                                
                                if(!controlView.atYBeginning && selectLayer.y === 0)
                                    controlView.contentY -= 10
                            }
                        }
                    }
                    
                    onPressed: (mouse) =>
                    {
                        if (mouse.source === Qt.MouseEventNotSynthesized)
                        {
                            if(control.enableLassoSelection && mouse.button === Qt.LeftButton && control.count > 0)
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
                    }
                    
                    onPressAndHold: (mouse) =>
                    {
                        if ( mouse.source !== Qt.MouseEventNotSynthesized && control.enableLassoSelection && !selectLayer.visible )
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
                        
                        if(selectLayer.y > controlView.contentHeight)
                        {
                            return selectLayer.reset();
                        }
                        
                        var lassoIndexes = []
                        const limitX = mouse.x === lassoRec.x ? lassoRec.x+lassoRec.width : mouse.x
                        const limitY =  mouse.y === lassoRec.y ?  lassoRec.y+lassoRec.height : mouse.y
                        
                        for(var i =lassoRec.x; i < limitX; i+=(lassoRec.width/(controlView.cellWidth* 0.5)))
                        {
                            for(var y = lassoRec.y; y < limitY; y+=(lassoRec.height/(controlView.cellHeight * 0.5)))
                            {
                                const index = controlView.indexAt(i,y+controlView.contentY)
                                if(!lassoIndexes.includes(index) && index>-1 && index< controlView.count)
                                    lassoIndexes.push(index)
                            }
                        }
                        
                        if(lassoIndexes.length > 0)
                        {
                            control.itemsSelected(lassoIndexes)
                        }
                        
                        selectLayer.reset()
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
    
    /**
     * @brief Request to resize the view elements. This will result in the `itemSize` property being modified.
     * @param factor a factor for resizing.
     * The minimum size is `Style.iconSizes.small`.
     */
    function resizeContent(factor)
    {
        const newSize = control.itemSize * factor
        
        if(newSize > control.itemSize)
        {
            control.itemSize =  newSize
        }
        else
        {
            if(newSize >= Maui.Style.iconSizes.small)
                control.itemSize =  newSize
        }
    }
    
    /**
     * @brief Forces to adapt the width of the grid cells. This will result on the `cellWidth` property being modified.
     */
    function adaptGrid()
    {
        var fullWidth = controlView.width
        var realAmount = parseInt(fullWidth / controlView.size_, 0)
        var amount = parseInt(fullWidth / control.cellWidth, 0)
        
        var leftSpace = parseInt(fullWidth - ( realAmount * controlView.size_ ), 0)
        var size = Math.min(amount, realAmount) >= control.count ? Math.max(control.cellWidth, control.itemSize) : parseInt((controlView.size_) + (parseInt(leftSpace/realAmount, 0)), 0)
        
        control.cellWidth = size
    }
    
    /**
     * @brief Resets the value of the `cellWidth` back to the initial size set with `itemSize`.
     */
    function resetCellWidth()
    {
        control.cellWidth = control.itemSize
    }
}
