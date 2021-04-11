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
import QtGraphicalEffects 1.0

import "private"

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
    implicitWidth: mainFlickable.contentWidth
    spacing: Maui.Style.space.small
    padding: 0
    
    /**
     * content : RowLayout.data
     */
    default property alias content : leftRowContent.data
        
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
        property alias leftContent : leftRowContent.data
        
        /**
         * middleContent : RowLayout.data
         */
        property alias middleContent : middleRowContent.data
        
        /**
         * rightContent : RowLayout.data
         */
        property alias rightContent : rightRowContent.data
        
        /**
         * farLeftContent : RowLayout.data
         */
        property alias farLeftContent : farLeftRowContent.data
        
        /**
         * farRightContent : RowLayout.data
         */
        property alias farRightContent : farRightRowContent.data
        
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
        property int margins: Maui.Style.space.medium
        
        /**
         * count : int
         */
        readonly property int count : leftContent.length + middleContent.length + rightContent.length + farLeftContent.length + farRightContent.length
        
        /**
         * visibleCount: int
         */
        readonly property int visibleCount : leftRowContent.visibleChildren.length + middleRowContent.visibleChildren.length  + rightRowContent.visibleChildren.length + farLeftRowContent.visibleChildren.length  + farRightRowContent.visibleChildren.length
                
        EdgeShadow
        {
            width: Maui.Style.iconSizes.medium
            height: parent.height
            visible: !mainFlickable.atXEnd && !control.fits 
            opacity: 0.7
            z: 999
            edge: Qt.RightEdge
            anchors
            {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
        }
        
        EdgeShadow
        {
            width: Maui.Style.iconSizes.medium
            height: parent.height
            visible: !mainFlickable.atXBeginning && !control.fits 
            opacity: 0.7
            z: 999
            edge: Qt.LeftEdge
            anchors
            {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
        }
        
        Kirigami.WheelHandler
        {
            id: wheelHandler
            target: mainFlickable
        }
        
        Item
        {
            anchors.fill: parent
            
            DragHandler
            {
                acceptedDevices: PointerDevice.GenericPointer
                grabPermissions:  PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
                onActiveChanged: if (active) { root.startSystemMove(); }
            }
            //
            /*  TapHandler
             *            {
             *                grabPermissions:  PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
             *                onTapped: if (tapCount === 2) root.toggleMaximized()
             *                gesturePolicy: TapHandler.DragThreshold
        } */
        }
        
        Item
        {
            id: _container
            height: control.implicitHeight
            width: control.width
            
//             Label{
//                 z: parent.z + 9999
//                 color: "orange"
//                 text: farLeftRowContent.implicitWidth + " / " + control.width + " / " + _scrollView.width
//             }
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
                spacing: control.spacing
                anchors.fill: parent
                anchors.leftMargin: control.margins
                anchors.rightMargin: control.margins
                
                Row
                {
                    id: farLeftRowContent
                    Layout.preferredWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumWidth: implicitWidth
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    spacing: control.spacing
                }   
                
                ToolSeparator
                {
                    visible: farLeftRowContent.visibleChildren.length && (leftRowContent.visibleChildren.length || middleRowContent.visibleChildren.length)
                    implicitHeight: Maui.Style.iconSizes.tiny
                    Layout.alignment: Qt.AlignCenter
                }
                
                ScrollView
                {
                    id: _scrollView
                    readonly property bool fits : mainFlickable.contentWidth < width
                    onFitsChanged: mainFlickable.returnToBounds()
                    
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    contentWidth: mainFlickable.contentWidth
                    contentHeight: height  
                    
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                    
                    Flickable
                    {
                        id: mainFlickable
                        
                        anchors.fill: parent
                        
                        flickableDirection: Flickable.HorizontalFlick
                        interactive: !fits && Maui.Handy.isTouch
                        contentWidth: layout.implicitWidth
                        
                        boundsBehavior: Flickable.StopAtBounds
                        boundsMovement :Flickable.StopAtBounds

                        clip: true
                        
                        RowLayout
                        {
                            id: layout
                            width: mainFlickable.width
                            height: mainFlickable.height
                            spacing: control.spacing
                            
                            Row
                            {
                                id: leftRowContent
                                spacing: control.spacing
                                Layout.preferredWidth: implicitWidth
                                Layout.maximumWidth: implicitWidth
                                Layout.minimumWidth: implicitWidth
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            }
                            
                            
                            Item //helper to force center middle content
                            {
                                visible: control.forceCenterMiddleContent
                                Layout.minimumWidth: 0
                                Layout.fillWidth: visible
                                Layout.maximumWidth: visible ? Math.max((rightRowContent.implicitWidth + farRightRowContent.implicitWidth) -( leftRowContent.implicitWidth + farLeftRowContent.implicitWidth), 0) : 0
                            }
                            
                            RowLayout
                            {
                                id: middleRowContent
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.fillWidth: true
//                                 Layout.minimumWidth: implicitWidth
                                spacing: visibleChildren.length > 1 ? control.spacing : 0
                            }
                            
                            Item //helper to force center middle content
                            {
                                visible: control.forceCenterMiddleContent
                                Layout.minimumWidth: 0
                                Layout.fillWidth: visible
                                Layout.maximumWidth: visible ? Math.max(( leftRowContent.implicitWidth + farLeftRowContent.implicitWidth) - (rightRowContent.implicitWidth + farRightRowContent.implicitWidth), 0) : 0
                            }
                            
                            Row
                            {
                                id: rightRowContent
                                spacing: control.spacing
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                Layout.preferredWidth: implicitWidth
                                Layout.maximumWidth: implicitWidth
                                Layout.minimumWidth: implicitWidth
                            }                                
                        }
                    }
                }
                
                
                ToolSeparator
                {
                    visible: farRightRowContent.visibleChildren.length && (rightRowContent.visibleChildren.length || middleRowContent.visibleChildren.length)
                    implicitHeight: Maui.Style.iconSizes.tiny
                    Layout.alignment: Qt.AlignCenter
                }
                
                Row
                {
                    id: farRightRowContent
                    spacing: control.spacing
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    Layout.preferredWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumWidth: implicitWidth
                }
            }            
        }        
}
