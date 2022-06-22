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
import QtQml 2.15
import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

/**
 * SideBar
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Control
{
  id: control
  
  Maui.Theme.colorSet: Maui.Theme.Window
  Maui.Theme.inherit: false
  
  readonly property alias position : _private.position
  readonly property bool peeking : control.collapsed && control.position > 0
  readonly property bool resizing: _dragHandler.active
  
  visible: position > 0
  
  width: position * preferredWidth
  
  /*!
   *      \qmlproperty Item AbstractSideBar::content
   * 
   *      The main content is added to an Item contents, it can anchored or sized normally.
   */
  default property alias content : _content.data
    
    
    /*!
     *      If the sidebar should be collapsed or not, this property can be used to dynamically collapse
     *      the sidebar on constrained spaces.
     */
    property bool collapsed: false
    
    property bool resizeable : !Maui.Handy.isMobile
    
    
    /*!
     *      preferredWidth : int
     *      The preferred width of the sidebar in the expanded state.
     */
    property int preferredWidth : Maui.Style.units.gridUnit * 12
    property int maximumWidth:  Maui.Style.units.gridUnit * 20
    property int minimumWidth:  Maui.Style.units.gridUnit * 4
    /*!
     *      \qmlproperty MouseArea AbstractSideBar::overlay
     * 
     *      When the application has a constrained width to fit the sidebar and main contain,
     *      the sidebar is in a constrained state, and the app main content gets dimmed by an overlay.
     *      This property gives access to such ovelay element drawn on top of the app contents.
     */
    //readonly property alias overlay : _overlayLoader.item
    
    clip: true
    
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    
    
    signal opened()
    signal closed()    
    
    background: Rectangle
    {
      color: Maui.Theme.backgroundColor
      Behavior on color
      {
        Maui.ColorTransition{}
      }
    }
    
    QtObject
    {
      id: _private
      property double position       
      property int resizeValue
      property int finalWidth : control.preferredWidth + _dragHandler.centroid.position.x
      
      //       Binding on resizeValue
      //       {
      //         //delayed: true
      // //         when: _dragHandler.active
      //         value: 
      //         restoreMode: Binding.RestoreBindingOrValue
      //       }      
      //       
      Binding on position
      {
        value: control.enabled ? (control.collapsed ? 0 : 1) : 0
        restoreMode: Binding.RestoreBindingOrValue
      }
      
      Behavior on position
      {
        enabled: Maui.Style.enableEffects
        
        NumberAnimation
        {
          duration: Maui.Style.units.longDuration
          easing.type: Easing.InOutQuad
        }
      }
    }   
    
    onCollapsedChanged:
    {
      if(control.collapsed || !control.enabled)
      {
        control.close()
      }
      else
      {
        control.open()
      }
    }
    
    contentItem: Item
    {
      Item
      {
        visible: !control.resizing
        id: _content
        width: control.preferredWidth
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right        
      }     
      
      MouseArea
      {
        id: _overlayMouseArea
        
        parent: control.parent
        anchors.leftMargin: control.width
        anchors.fill: parent
        visible: control.collapsed && control.position > 0
        
        onClicked: control.close()
        
        Rectangle
        {
          anchors.fill: parent
          color: "#333"
          opacity : 0.5
        }
      }
      
      Rectangle
      {
        parent: control.parent
        id: _resizeTarget
        width: Math.max(Math.min(_private.finalWidth, control.maximumWidth), control.minimumWidth)
        height: parent.height
        color: Maui.Theme.alternateBackgroundColor
        visible: control.resizing
        
        Label
        {
          text:  _dragHandler.centroid.position.x
          color: "orange"
        }
        
        Maui.Separator
        {
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.right: parent.right  
          
        }
      }
      
      Rectangle
      {
        parent: control.parent
        id: _resizeTarget2
        anchors.leftMargin:  _resizeTarget.width
        width: parent.width
        height: parent.height
        color: Maui.Theme.backgroundColor
        visible: control.resizing
      }
      
      
      Rectangle
      {
        visible: control.resizeable
        height: parent.height
        width : 20
        anchors.right: parent.right
        color:  _dragHandler.active ? Maui.Theme.highlightColor : "transparent"
        DragHandler
        {
          id: _dragHandler
          yAxis.enabled: false
          xAxis.enabled: true
          xAxis.minimum: control.minimumWidth - control.preferredWidth
          xAxis.maximum: control.maximumWidth - control.preferredWidth
          target: null
          
          onActiveChanged:
          {
            let value = control.preferredWidth + _dragHandler.centroid.position.x 
            if(!active)
            {
              if(value > control.maximumWidth)
              {
                control.preferredWidth = control.maximumWidth
                return
              }
              
              if( value < control.minimumWidth)
              {
                control.preferredWidth = control.minimumWidth
                return
              }
              control.preferredWidth = value      
            }
          }
          
        }
      }
      
      Maui.Separator
      {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right  
        
      }           
    }
    
    
    
    function open()
    {
      _private.position = 1
    }
    
    function close()
    {
      _private.position = 0
    }
    
    function toggle()
    {
      if(_private.position === 0)
      {
        control.open()
      }else
      {
        control.close()
      }
    }
}

