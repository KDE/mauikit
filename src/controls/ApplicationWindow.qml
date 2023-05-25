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

import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/*!
 \ since or*g.mauikit.controls 1.0
 \inqmlmodule org.mauikit.controls
 \brief A window that provides some basic features needed for all apps
 
 It's usually used as a root QML component for the application.
 By default it makes usage of the Maui Page control, so it packs a header and footer bar.
 The header can be moved to the bottom for better reachability in hand held devices.
 The Application window has some components already built in like an AboutDialog, a main application menu,
 and an optional property to add a global sidebar.
 
 The application can have client side decorations CSD by setting the attached property Maui.App.enabledCSD  to true,
 or globally by editing the configuration file located at /.config/Maui/mauiproject.conf.
 
 For more details you can refer to the Maui Page documentation for fine tweaking the application window main content.
 \code
 ApplicationWindow {
 id: root
 
 AppViews {
 anchors.fill: parent
 }
 }
 \endcode
 */
Window
{
  id: root
  
  visible: true
    
  minimumHeight: Maui.Handy.isMobile ? 0 : Math.min(300, Screen.desktopAvailableHeight)
  minimumWidth: Maui.Handy.isMobile ? 0 : Math.min(200, Screen.desktopAvailableWidth)
  
  color: "transparent"
  flags: Maui.App.controls.enableCSD ? (Qt.FramelessWindowHint | Qt.Window ): (Qt.Window & ~Qt.FramelessWindowHint)
  
  Settings 
  {
    property alias x: root.x
    property alias y: root.y
    property alias width: root.width
    property alias height: root.height
  }
  
  // Window shadows for CSD
  Loader
  {
    active: Maui.App.controls.enableCSD && !Maui.Handy.isMobile && Maui.Handy.isLinux
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
  Maui.Theme.colorSet: Maui.Theme.View
  
  /*!
   \ qm*lproperty Item ApplicationWindow::content
   
   Items to be placed inside the ApplicationWindow.
   */
  default property alias content : _content.data
    
    /***************************************************/
    /******************** ALIASES *********************/
    /*************************************************/
    
    
    /*!
     \ qm*lproperty Dialog ApplicationWindow::dialog
     
     The internal dialogs used in the ApplicationWindow are loaded dynamically, so the current loaded dialog can be accessed
     via this property.
     */
    property alias dialog: dialogLoader.item
    
    
    /*!
     I f *the application window size is wide enough.
     This property can be changed to any random condition.
     Keep in mind this property is widely used in other MauiKit components to determined if items shoudl be hidden or collapsed, etc.
     */
    property bool isWide : root.width >= Maui.Style.units.gridUnit * 30
    
    /***************************************************/
    /**************** READONLY PROPS ******************/
    /*************************************************/
    /*!
     I f *the screen where the application is drawn is in portrait mode or not,
     other wise it is in landscape mode.
     */
    readonly property bool isMaximized: root.visibility === Window.Maximized
    readonly property bool isFullScreen: root.visibility === Window.FullScreen
    readonly property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation || Screen.primaryOrientation === Qt.InvertedPortraitOrientation
        
    Item
    {
      anchors.fill: parent
 
      Item
      {
        id: _content
        anchors.fill: parent
      }
      
      
      Private.ToastArea
      {
        id: _toastArea
        anchors.fill: parent
      } 
      
      
      layer.enabled: Maui.App.controls.enableCSD && root.visibility !== Window.FullScreen && !Maui.Handy.isMobile && root.visibility !== Window.Maximized
    
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
      active: _content.layer.enabled
      visible: active
      z: ApplicationWindow.overlay.z + 9999
      anchors.fill: parent
      asynchronous: true
      
      sourceComponent: Rectangle
      {
        radius: Maui.Style.radiusV - 0.5
        color: "transparent"
        border.color: Qt.darker(Maui.Theme.backgroundColor, 2.3)
        opacity: 0.5
        
        Behavior on color
        {
          Maui.ColorTransition{}
        }
        
        Rectangle
        {
          anchors.fill: parent
          anchors.margins: 1
          color: "transparent"
          radius: parent.radius - 0.5
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
      active: Maui.App.controls.enableCSD
      visible: active
      height: 16
      width: height
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      
      sourceComponent: MouseArea
      {
        cursorShape: Qt.SizeBDiagCursor
        propagateComposedEvents: true
        preventStealing: false
        
        onPressed: mouse.accepted = false
        
        DragHandler
        {
          grabPermissions: TapHandler.TakeOverForbidden
          target: null
          onActiveChanged: if (active)
          {
            root.startSystemResize(Qt.LeftEdge | Qt.BottomEdge);
          }
        }
      }
    }
    
    Loader
    {
      asynchronous: true
      active: Maui.App.controls.enableCSD
      visible: active
      height: 16
      width: height
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      
      sourceComponent: MouseArea
      {
        
        cursorShape: Qt.SizeFDiagCursor
        propagateComposedEvents: true
        preventStealing: false
        
        onPressed: mouse.accepted = false
        
        DragHandler
        {
          grabPermissions: TapHandler.TakeOverForbidden
          target: null
          onActiveChanged: if (active)
          {
            root.startSystemResize(Qt.RightEdge | Qt.BottomEdge);
          }
        }
      }
    }    
   
    Overlay.overlay.modal: Item
    {
//       Loader
//       {
//         anchors.fill: parent
//         active: Maui.Style.enableEffects
//       sourceComponent: Item
//       {
//       ShaderEffectSource 
//       {
//         id:_shaderSource
//        anchors.fill: parent
//         sourceItem: _content   
//       }
//       
//       FastBlur
//       {
//         anchors.fill: parent
//         source: _shaderSource
//         radius: 64
//       }
//       
//       layer.enabled: true
//       layer.effect: OpacityMask
//       {
//         maskSource: Rectangle
//         {
//           width: _content.width
//           height: _content.height
//           radius: Maui.Style.radiusV
//         }            
//       }      
//       }
//       }
//       
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
      
    Loader
    {
      id: dialogLoader
    }
    
    Connections
    {
      target: Maui.Platform
      ignoreUnknownSignals: true
      function onShareFilesRequest(urls)
      {
        dialogLoader.source = "ShareDialog.qml"
        dialog.urls = urls
        dialog.open()
      }
    }
    
    /**
     * Send an inline notification.
     * icon = icon to be used
     * title = the title
     * body = message of the notification
     * callback = function to be triggered if the notification dialog is accepted
     * timeout = time in milliseconds before the notification dialog is dismissed
     * buttonText = text in the accepted button
     */
    function notify(icon, title, body, callback, buttonText)
    {
      _toastArea.add(icon, title, body, callback, buttonText)
    }
    
    /**
     * Switch from full screen to normal size.
     */
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
     * Reference to the application main page
     */
    function window()
    {
      return root.contentItem;
    }
    
    function about()
    {
      dialogLoader.source = "qrc:/maui/kit/private/AboutDialog.qml"
      dialog.open()
    }
}
