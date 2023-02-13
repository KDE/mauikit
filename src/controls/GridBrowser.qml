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

import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

/**
 * GridBrowser
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
     * itemSize : int
     */
    property alias itemSize: controlView.itemSize
    
    /**
     * itemWidth : int
     */
    property alias itemWidth : controlView.itemWidth
    
    /**
     * itemHeight : int
     */
    property alias itemHeight : controlView.itemHeight
    
    /**
     * cellWidth : int
     */
    property alias cellWidth: controlView.cellWidth
    
    /**
     * cellHeight : int
     */
    property alias cellHeight: controlView.cellHeight
    
    /**
     * model : var
     */
    property alias model : controlView.model
    
    /**
     * delegate : Component
     */
    property alias delegate : controlView.delegate
    
    /**
     * contentY : int
     */
    property alias contentY: controlView.contentY
    
    /**
     * currentIndex : int
     */
    property alias currentIndex : controlView.currentIndex
    
    /**
     * count : int
     */
    property alias count : controlView.count
    
    /**
     * cacheBuffer : int
     */
    property alias cacheBuffer : controlView.cacheBuffer
    
    /**
     * flickable : Flickable
     */
    property alias flickable : controlView
    
    /**
     * contentHeight : int
     */
    property alias contentHeight : controlView.contentHeight
    
    /**
     * contentWidth : int
     */
    property alias contentWidth : controlView.contentWidth
    
    property alias scrollView: _scrollView
    
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
    property int verticalScrollBarPolicy:  ScrollBar.AsNeeded
    
    /**
     * horizontalScrollBarPolicy : ScrollBar.policy
     */
    property int horizontalScrollBarPolicy: ScrollBar.AlwaysOff
    
    /**
     * holder : Holder
     */
    property alias holder : _holder
    
    /**
     * adaptContent : bool
     */
    property bool adaptContent: true
    
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
    property alias lassoRec : selectLayer
    
    /**
     * pinchEnabled : bool
     */
    property bool pinchEnabled : false
    
    property alias currentItem : controlView.currentItem
    
    property alias header : controlView.header
    property alias footer : controlView.footer
    
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
            interactive: Maui.Handy.isTouch
            onWidthChanged: if(adaptContent) control.adaptGrid()
            onCountChanged: if(adaptContent) control.adaptGrid()
            
            keyNavigationEnabled : true
            keyNavigationWraps : true
            Keys.onPressed: control.keyPress(event)
            
            Maui.Holder
            {
                id: _holder
                visible: false
                anchors.fill : parent
                anchors.topMargin: controlView.headerItem ? controlView.headerItem.height : 0
                anchors.bottomMargin: controlView.footerItem ? controlView.footerItem.height : 0
            }
            
            Loader
            {
                asynchronous: true
                active: control.pinchEnabled
                
                anchors.fill: parent
                z: -1
                
                sourceComponent: PinchArea
                {
                    onPinchFinished:
                    {
                        resizeContent(pinch.scale)
                    }
                }                
            }
            
            Loader
            {
                asynchronous: true
                z: -1
                active: !Maui.Handy.hasTransientTouchInput && !Maui.Handy.isMobile
                anchors.fill: parent
                
                sourceComponent: MouseArea
                {
                    id: _mouseArea
                    
                    propagateComposedEvents: true
                    //                 preventStealing: true
                    acceptedButtons:  Qt.RightButton | Qt.LeftButton
                    
                    onClicked:
                    {
                        control.areaClicked(mouse)
                        control.forceActiveFocus()
                        
                        if(mouse.button === Qt.RightButton)
                        {
                            control.areaRightClicked()
                            return
                        }
                    }
                    
                    onWheel:
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
                    
                    onPositionChanged:
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
                    
                    onPressed:
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
                    
                    onPressAndHold:
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
                    
                    onReleased:
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
                        
                        control.itemsSelected(lassoIndexes)
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
     * 
     */
    function resizeContent(factor)
    {
        const newSize= control.itemSize * factor
        
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
     * 
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
}
