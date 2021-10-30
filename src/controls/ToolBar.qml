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

import org.kde.kirigami 2.9 as Kirigami
import org.mauikit.controls 1.2 as Maui

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
    implicitHeight: preferredHeight
    implicitWidth: _scrollView.contentWidth
    spacing: Maui.Style.space.small
    padding: 0
    
    /**
     * content : RowLayout.data
     */
    default property alias content : leftRowContent.content
        
        /**
         * preferredHeight : int
         */
        property int preferredHeight: Math.max(Maui.Style.toolBarHeight, layout.implicitHeight)
        
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
         * margins : int
         */
        property int margins: control.spacing
        
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
            anchors
            {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Private.EdgeShadow
            {
                
                opacity: 0.7
                edge: Qt.RightEdge
            }
        }
        
        Loader
        {
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
            
            sourceComponent: Private.EdgeShadow
            {
                
                opacity: 0.7
                edge: Qt.LeftEdge
                
            }
        }
        
        Loader
        {
            asynchronous: true
            sourceComponent: Kirigami.WheelHandler
            {
                target: mainFlickable
            }
        }
        
        Loader
        {
            anchors.fill: parent
            active: control.draggable
            
            sourceComponent: Item
            {
                DragHandler
                {
                    acceptedDevices: PointerDevice.GenericPointer
                    grabPermissions:  PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
                    onActiveChanged: if (active) { root.startSystemMove(); }
                }
            }
        }
        
        Item
        {
            id: _container
            height: control.implicitHeight
            width: control.width
            
            //              Label{
            //                  anchors.left: parent.left
            //                  z: parent.z + 9999
            //                  color: "orange"
            //                  text: farLeftRowContent.implicitWidth + " / " + leftRowContent.implicitWidth + " / " + _scrollView.width
            //              }
            
            //             Label{
            //                 anchors.centerIn: parent
            
            //                 z: parent.z + 9999
            //                 color: "orange"
            //                 text: _helper1.width + " / " + middleRowContent.implicitWidth + " / " + _helper2.width
            //             }
            
            //Label{
            //anchors.right: parent.right
            //z: parent.z + 9999
            //color: "orange"
            //text: farRightRowContent.implicitWidth + " / " + rightRowContent.implicitWidth  + " / " + control.width
            //}
            states: [State
            {
                when: control.position === ToolBar.Header
                
                AnchorChanges
                {
                    target: _container
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            
            State
            {
                when: control.position === ToolBar.Footer
                
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
                anchors.fill: parent
                anchors.leftMargin: control.margins
                anchors.rightMargin: control.margins
                
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
                        interactive: !fits && Maui.Handy.isTouch
                        
                        boundsBehavior: Flickable.StopAtBounds
                        boundsMovement :Flickable.StopAtBounds
                        
                        clip: true
                        
                        RowLayout
                        {
                            id: layout
                            
                            width: _scrollView.width
                            height: _scrollView.height
                            
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
                            
                            
                            Private.ToolBarSection
                            {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumWidth: implicitWidth
                                
                                RowLayout
                                {
                                    id: middleRowContent
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: implicitWidth
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
