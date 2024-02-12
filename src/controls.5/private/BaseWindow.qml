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

import Qt5Compat.GraphicalEffects

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Window
 * @brief A base window implementation for window dialogs and the main application window.
 * For using a detached dialog window use the WindowDialog control.
 */

Window
{
    id: root
    
    visible: true
    
    minimumHeight: Maui.Handy.isMobile ? 0 : Math.min(300, Screen.desktopAvailableHeight)
    minimumWidth: Maui.Handy.isMobile ? 0 : Math.min(200, Screen.desktopAvailableWidth)
    
    color: "transparent"
    flags: Maui.CSD.enabled ? (Qt.FramelessWindowHint | Qt.Window ): (Qt.Window & ~Qt.FramelessWindowHint)
    
    // Window shadows for CSD
    Loader
    {
        active: Maui.CSD.enabled && !Maui.Handy.isMobile && Maui.Handy.isLinux
        asynchronous: true
        sourceComponent: Maui.WindowShadow
        {
            view: root
            radius: Maui.Style.radiusV
            strength: 7.8
        }
    }
    
    /***************************************************/
    /********************* COLORS *********************/
    /*************************************************/
    Maui.Theme.colorSet: Maui.Theme.Window
    
    /**
     * @brief Items to be placed inside the ApplicationWindow.
     * This is used as the default container, and it helps to correctly mask the contents when using CSD with rounded border corners.
     * @property list<QtObject> content
     **/
    default property alias content : _content.data
        
        /***************************************************/
        /**************** READONLY PROPS ******************/
        /*************************************************/      
        
        /**
         * @brief  Determines when the application window size is wide enough.
         * This property can be changed to any arbitrary condition. This will affect how some controls are positioned and displayed - as for a true wide value, it will assume there is more space to place contents, or for a `false` value it will work in the opposite way.
         * Keep in mind this property is widely used in other MauiKit components to determined if items should be hidden,  collapsed, or expanded, etc.
         **/
        property bool isWide : root.width >= Maui.Style.units.gridUnit * 30
        
        /**
         * @brief Convenient property to check if the application window surface is maximized.
         **/
        readonly property bool isMaximized: root.visibility === Window.Maximized
        
        /**
         * @brief Convenient property to check if the application window is in a full screen mode.
         **/
        readonly property bool isFullScreen: root.visibility === Window.FullScreen
        
        /**
         * @brief Convenient property to check if the application window is in portrait mode, otherwise it means it is in landscape mode.
         **/
        readonly property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation || Screen.primaryOrientation === Qt.InvertedPortraitOrientation
        
        Item
        {
            id: _container
            anchors.fill: parent
            readonly property bool showBorders: Maui.CSD.enabled && root.visibility !== Window.FullScreen && !Maui.Handy.isMobile && root.visibility !== Window.Maximized
            
            Item
            {
                id: _content
                anchors.fill: parent
            }
            
            Loader
            {
                id: _toastAreaLoader
                anchors.fill: parent                
            }
            
            layer.enabled: _container.showBorders
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: _content.width
                    height: _content.height
                    radius: Maui.Style.radiusV
                }
            }
        }
        
        Loader
        {
            active: _container.showBorders
            visible: active
            z: Overlay.overlay.z
            anchors.fill: parent
            asynchronous: true
            
            sourceComponent: Rectangle
            {
                radius: Maui.Style.radiusV
                color: "transparent"
                border.color: Qt.darker(Maui.Theme.backgroundColor, 3)
                opacity: 0.7
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }
                
                Rectangle
                {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    radius: parent.radius
                    border.color: Qt.lighter(Maui.Theme.backgroundColor, 2)
                    opacity: 0.7
                    
                    Behavior on color
                    {
                        Maui.ColorTransition{}
                    }
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            active: Maui.CSD.enabled
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
                    onActiveChanged: (active) => 
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
            active: Maui.CSD.enabled
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
                    onActiveChanged: if (active)
                    {
                        root.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                    }
                }
            }
        }
        
        Overlay.overlay.modal: Item
        {
            Rectangle
            {
                color: Maui.Theme.backgroundColor
                anchors.fill: parent
                opacity : 0.8
                radius:  Maui.Style.radiusV
            }
        }
        
        Overlay.overlay.modeless: Rectangle
        {
            radius:  Maui.Style.radiusV
            
            color: Qt.rgba( root.Maui.Theme.backgroundColor.r,  root.Maui.Theme.backgroundColor.g,  root.Maui.Theme.backgroundColor.b, 0.7)
            Behavior on opacity { NumberAnimation { duration: 150 } }
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }
        
        Component.onCompleted:
        {
            // Explicitly break the binding as we need this to be set only at startup.
            // if the bindings are active, after this the window is resized by the
            // compositor and then the bindings are reevaluated, then the window
            // size would reset ignoring what the compositor asked.
            // see BUG 433849
            root.width = root.width;
            root.height = root.height;
        }      
        
        /**
         * @brief Switch between maximized and normal state
         **/
        function toggleMaximized()
        {
            if (root.isMaximized)
            {
                root.showNormal();
            } else
            {
                root.showMaximized();
            }
        }
        
        /**
         * @brief Switch between full-screen mode and normal mode
         **/
        function toggleFullscreen()
        {
            if (root.isFullScreen)
            {
                root.showNormal();
            } else
            {
                root.showFullScreen()();
            }
        }
        
        /**
         * @brief Send an inline notification
         * @param icon icon name to be used
         * @param title the notification title
         * @param body the message body of the notification
         * @param callback a callback function to be triggered when the action button is pressed, this is represented as a button
         * @param buttonText the text associated to the previous callback function, to be used in the button
         **/
        function notify(icon, title, body, callback, buttonText)
        {
            if(!_toastAreaLoader.item)
            {
                _toastAreaLoader.setSource("ToastArea.qml")
            }
            _toastAreaLoader.item.add(icon, title, body, callback, buttonText)
        }        
}
