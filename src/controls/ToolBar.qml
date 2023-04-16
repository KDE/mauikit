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
import QtQuick.Window 2.15

import org.mauikit.controls 1.3 as Maui

import QtQuick.Layouts 1.3

import "private" as Private

/**
 * ToolBar
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
ToolBar
{
    id: control    
    
    implicitHeight: preferredHeight + topPadding + bottomPadding    
  
    /**
     * content : RowLayout.data
     */
    default property alias content : leftRowContent.content
        
        /**
         * preferredHeight : int
         */
        property int preferredHeight: implicitContentHeight
        
        /**
         * forceCenterMiddleContent : bool
         */
        property bool forceCenterMiddleContent : true
        
        /**
         * leftContent : RowLayout.data
         */
        property alias leftContent : leftRowContent.content
        
        /**
         * middleContent : RowLayout.data
         */
        property alias middleContent : middleRowContent.data
        
        /**
         * rightContent : RowLayout.data
         */
        property alias rightContent : rightRowContent.content
        
        /**
         * farLeftContent : RowLayout.data
         */
        property alias farLeftContent : farLeftRowContent.content
        
        /**
         * farRightContent : RowLayout.data
         */
        property alias farRightContent : farRightRowContent.content
        
        /**
         * middleLayout : RowLayout
         */
        property alias middleLayout : middleRowContent
        
        /**
         * leftLayout : RowLayout
         */
        property alias leftLayout : leftRowContent
        
        /**
         * rightLayout : RowLayout
         */
        property alias rightLayout : rightRowContent
        
        /**
         * farRightLayout : RowLayout
         */
        property alias farRightLayout : farRightRowContent
        
        /**
         * rightLayout : RowLayout
         */
        property alias farLeftLayout : farLeftRowContent
        
        /**
         * layout : RowLayout
         */
        property alias layout : layout
        
        /**
         * fits : bool
         */
        readonly property alias fits : _scrollView.fits
        
        
        /**
         * count : int
         */
        readonly property int count : leftContent.length + middleContent.length + rightContent.length + farLeftContent.length + farRightContent.length
        
        /**
         * visibleCount: int
         */
        readonly property int visibleCount : leftRowContent.visibleChildren.length + middleRowContent.visibleChildren.length  + rightRowContent.visibleChildren.length + farLeftRowContent.visibleChildren.length  + farRightRowContent.visibleChildren.length
        
        
        property bool draggable : true
        
            Loader
            {
                asynchronous: true
                width: Maui.Style.iconSizes.medium
                height: parent.height
                active: !mainFlickable.atXEnd && !control.fits
                visible: active
                z: 999
                parent: control.background
                anchors
                {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                
                sourceComponent: Maui.EdgeShadow
                {
                    edge: Qt.RightEdge
                }
            }
            
            Loader
            {
                parent: control.background
                asynchronous: true
                width: Maui.Style.iconSizes.medium
                height: parent.height
                active: !mainFlickable.atXBeginning && !control.fits
                visible: active
                z: 999
                anchors
                {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                
                sourceComponent: Maui.EdgeShadow
                {                    
                    edge: Qt.LeftEdge                    
                }
            }
        
        contentItem: Item
        {
            implicitWidth: _mainLayout.implicitWidth 
            implicitHeight: _mainLayout.implicitHeight 
            clip: true
           
            Item
            {
                id: _container
                height: control.preferredHeight
                width: parent.width
                
                property bool isHeader: control.position === ToolBar.Header
                state: isHeader? "headerState" : "footerState"
             
                
                Loader
                {
                    asynchronous: true
                    sourceComponent: Maui.WheelHandler
                    {
                        target: mainFlickable
                        primaryOrientation : Qt.Horizontal
                    }
                }
                
                Item
                {
                    id: _dragHandler
                    anchors.fill: parent
                    DragHandler
                    {
                        acceptedDevices: PointerDevice.GenericPointer
                        grabPermissions:  PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
                        onActiveChanged: if (active) { control.Window.window.startSystemMove(); }
                    }
                }                
               
                states: [State
                {
                    name: "headerState" 
                    
                    AnchorChanges
                    {
                        target: _container
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                    }
                },
                
                State
                {
                   name: "footerState"
                    
                    AnchorChanges
                    {
                        target: _container
                        anchors.top: parent.top
                        anchors.bottom: undefined
                    }
                }
                ]
                
                RowLayout
                {
                    id: _mainLayout
                    anchors.fill: parent
                    spacing: control.spacing
                    
                    Private.ToolBarSection
                    {
                        id: farLeftRowContent
                        Layout.fillHeight: true
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumWidth: implicitWidth
                        spacing: control.spacing
                    }
                    
                    ScrollView
                    {
                        id: _scrollView
                        padding: 0
                        implicitHeight: layout.implicitHeight + topPadding + bottomPadding
                        readonly property bool fits : contentWidth < width
                        onFitsChanged: mainFlickable.returnToBounds()
                        
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        
                        contentWidth: layout.implicitWidth - (_h1.mwidth + _h2.mwidth)
                        contentHeight: availableHeight
                        
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                        
                        Flickable
                        {
                            id: mainFlickable
                            
                            flickableDirection: Flickable.HorizontalFlick
                            interactive: !control.fits && Maui.Handy.isTouch
                            
                            boundsBehavior: Flickable.StopAtBounds
                            boundsMovement :Flickable.StopAtBounds
                            
                            clip: true
                            
                            RowLayout
                            {
                                id: layout
                                
                                width: _scrollView.availableWidth
                                height: _scrollView.availableHeight
                                
                                spacing: control.spacing
                                
                                Private.ToolBarSection
                                {
                                    id: leftRowContent
                                    
                                    Layout.fillHeight: true
                                    
                                    Layout.maximumWidth: implicitWidth
                                    Layout.minimumWidth: implicitWidth
                                    Layout.preferredWidth: implicitWidth
                                    //
                                    spacing: control.spacing
                                }                            
                                
                                Item //helper to force center middle content
                                {
                                    id: _h1
                                    visible: middleRowContent.visibleChildren.length && control.forceCenterMiddleContent
                                    
                                    readonly property int mwidth : visible ? Math.max((rightRowContent.implicitWidth + farRightRowContent.implicitWidth) -( leftRowContent.implicitWidth + farLeftRowContent.implicitWidth), 0) :0
                                    
                                    Layout.minimumWidth: 0
                                    
                                    Layout.preferredWidth: mwidth
                                    Layout.maximumWidth: mwidth
                                    
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                }
                                
                                Item
                                {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumWidth:implicitWidth
                                    implicitWidth:  middleRowContent.implicitWidth
                                    implicitHeight:  middleRowContent.implicitHeight
                                    //                                color: "yellow"
                                    RowLayout
                                    {
                                        id: middleRowContent
                                        anchors.fill: parent
                                        spacing: control.spacing
                                    }
                                }
                                
                                Item //helper to force center middle content
                                {
                                    id: _h2
                                    visible: middleRowContent.visibleChildren.length && control.forceCenterMiddleContent
                                    
                                    readonly property int mwidth : visible ? Math.max(( leftRowContent.implicitWidth + farLeftRowContent.implicitWidth) - (rightRowContent.implicitWidth + farRightRowContent.implicitWidth), 0) : 0
                                    
                                    Layout.minimumWidth: 0
                                    
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    
                                    Layout.preferredWidth: mwidth
                                    Layout.maximumWidth: mwidth
                                }
                                
                                Private.ToolBarSection
                                {
                                    id: rightRowContent
                                    
                                    Layout.fillHeight: true
                                    
                                    Layout.maximumWidth: implicitWidth
                                    Layout.minimumWidth: implicitWidth
                                    Layout.preferredWidth: implicitWidth
                                    
                                    spacing: control.spacing
                                }
                            }
                        }
                    }
                    
                    Private.ToolBarSection
                    {
                        id: farRightRowContent
                        Layout.fillHeight: true
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumWidth: implicitWidth
                        spacing: control.spacing
                    }
                }
            }            
        }
}
