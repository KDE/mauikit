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

import QtQuick.Window 
import QtQuick.Controls

Item
{
    Loader
    {
        active: canResizeH
        asynchronous: true
        visible: active
        height: parent.height
        width: 6
        anchors.right: parent.right
        
        sourceComponent: Item
        {
            MouseArea
            {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                acceptedButtons: Qt.NoButton // don't handle actual events
            }
            
            DragHandler
            {
                grabPermissions: TapHandler.TakeOverForbidden
                target: null
                onActiveChanged:
                {
                    if (active)
                    {
                        root.startSystemResize(Qt.RightEdge)
                    }
                }
            }
        }
    }
    
    Loader
    {
        active: canResizeH
        
        asynchronous: true
        visible: active
        height: parent.height
        width: 6
        anchors.left: parent.left
        
        sourceComponent: Item
        {
            MouseArea
            {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                acceptedButtons: Qt.NoButton // don't handle actual events
            }
            
            DragHandler
            {
                grabPermissions: TapHandler.TakeOverForbidden
                target: null
                onActiveChanged:
                {
                    if (active)
                    {
                        root.startSystemResize(Qt.LeftEdge)
                    }
                }
            }
        }
    }
    
    Loader
    {
        active: canResizeV
        
        asynchronous: true
        visible: active
        height: 6
        width: parent.width
        anchors.bottom: parent.bottom
        
        sourceComponent: Item
        {
            MouseArea
            {
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
                acceptedButtons: Qt.NoButton // don't handle actual events
            }
            
            DragHandler
            {
                grabPermissions: TapHandler.TakeOverForbidden
                target: null
                onActiveChanged:
                {
                    if (active)
                    {
                        root.startSystemResize(Qt.BottomEdge)
                    }
                }
            }
        }
    }
    
    
    Loader
    {
        active: canResizeV || canResizeH        
        
        asynchronous: true
        visible: active
        height: 16
        width: height
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        
        sourceComponent: Item
        {
            MouseArea
            {
                anchors.fill: parent
                cursorShape: Qt.SizeBDiagCursor
                acceptedButtons: Qt.NoButton // don't handle actual events
            }
            
            DragHandler
            {
                grabPermissions: TapHandler.TakeOverForbidden
                target: null
                onActiveChanged:
                {
                    if (active)
                    {
                        root.startSystemResize(Qt.LeftEdge | Qt.BottomEdge);
                    }
                }
            }
        }
    }
    
    Loader
    {
        asynchronous: true
        visible: active
        height: 16
        width: height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        
        sourceComponent: Item
        {
            MouseArea
            {
                anchors.fill: parent
                cursorShape: Qt.SizeFDiagCursor
                acceptedButtons: Qt.NoButton // don't handle actual events
            }
            
            DragHandler
            {
                grabPermissions: TapHandler.TakeOverForbidden
                target: null
                onActiveChanged:
                {
                    if (active)
                    {
                        root.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                    }
                }
            }
        }
    }
    
}
