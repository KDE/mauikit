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
import QtQml

import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit ItemDelegate
 * @brief A MauiKit ItemDelegate with an informational row layout.
 * This controls inherits from MauiKit ItemDelegate, to checkout its inherited properties refer to docs.
 * 
 *  @image html Delegates/listbrowserdelegate.png
 * @note An example of ListBrowserDelegate in the Index -f ile manager - application.
 * 
 * @section structure Structure
 *  The ListBrowserDelegate layouts its information horizontally. It's composed of two main sections: the far left icon header, and the text labels at the right side - there are four [4] possible labels. Those sections are all handled by a MauiKit ListItemTemplate control, which is exposed by the alias property `template`.
 *  @see ListItemTemplate
 * @see template
 *  
 *  The far left icon section is handled by default by a MauiKit IconItem, which can have an image or icon. Those can be set via the `imageSource` or the `iconSource` properties. 
 *  @see IconItem
 *  
 *  The said icon header can also be replaced by any other component using the `template.iconComponent` property.
 * 
 *  @section notes Notes
 *  This control can be `checkable`, and a CheckBox element will be placed on the left side. It also supports features from the Button type, such as the `autoExclusive`, `checked` properties and the press events.
 *  
 *  By inheritance this component can be `dragable`.
 *  
 *  @note This control is usually used as the delegate component for the ListBrowser or QQC2 ListView.
 *  
 *  @subsection dnd Drag & Drop
 *  To set up the drag and drop, use the Drag attached properties.
 * The most relevant part for this control is to set the `Drag.keys` and `Drag.mimeData`
 * 
 * @code
 * Drag.keys: ["text/uri-list"]
 * Drag.mimeData: Drag.active ?
 * {
 *    "text/uri-list": "" //here a list of file separated by a comma.
 * } : {}
 * @endcode
 * 
 * @code
 * Maui.ListBrowserDelegate
 * {
 *    width: ListView.view.width
 *    label1.text: "An example delegate."
 *    label2.text: "Using the MauiKit ListBrowser."
 * 
 *    iconSource: "folder"
 * }
 * @endcode
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ListBrowser.qml">You can find a more complete example at this link.</a>
 */
Maui.ItemDelegate
{
  id: control
  
  focus: true
  
  radius: Maui.Style.radiusV
  
  flat : !Maui.Handy.isMobile
  
  implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
  
  isCurrentItem : ListView.isCurrentItem || checked
  
  padding: Maui.Style.defaultPadding
  spacing: Maui.Style.space.small
  
  /**
   * @see ListItemTemplate::content
   */
  default property alias content : _template.content
    
    /**
     * @see ListItemTemplate::label1
     */
    readonly property alias label1 : _template.label1
    
    /**
     * @see ListItemTemplate::label2
     */
    readonly property alias label2 : _template.label2
    
    /**
     * @see ListItemTemplate::label3
     */
    readonly property alias label3 : _template.label3
    
    /**
     * @see ListItemTemplate::label4
     */
    readonly property alias label4 : _template.label4
    
    /**
     * @see ListItemTemplate::iconItem
     */
    property alias iconItem : _template.iconItem
    
    /**
     * @see ListItemTemplate::iconVisible
     */
    property alias iconVisible : _template.iconVisible
    
    /**
     * @see ListItemTemplate::iconSizeHint
     */
    property alias iconSizeHint : _template.iconSizeHint
    
    /**
     * @see ListItemTemplate::imageSource
     */
    property alias imageSource : _template.imageSource
    
    /**
     * @see ListItemTemplate::iconSource
     */
    property alias iconSource : _template.iconSource
    
    /**
     * @see ListItemTemplate::labelsVisible
     */
    property alias showLabel : _template.labelsVisible
    
    /**
     * @brief Whether the control is checked or not.
     * By default this is set to `false`.
     */
    property bool checked : false
    
    /**
     * @brief Whether the control should become checkable. If it is checkable a CheckBox element  will become visible to allow to toggle between the checked states.
     * By default this is set to `false`.
     */
    property bool checkable: false
    
    /**
     * @brief Whether the control should be auto exclusive, this means that among other related elements - sharing the same parent - only one can be selected/checked at the time.
     * By default this is set to `false`.
     */
    property bool autoExclusive: false
    
    /**
     * @see ListItemTemplate::leftLabels
     */
    readonly property alias leftLabels: _template.leftLabels
    
    /**
     * @see ListItemTemplate::rightLabels
     */
    readonly property alias rightLabels: _template.rightLabels
    
    /**
     * @brief An alias to access the ListItemTemplate control properties. This is the template element that layouts all the information: labels and icon/image.
     * @see ListItemTemplate
     * @property GridItemTemplate ListBrowserDelegate::template.
     */
    readonly property alias template : _template
    
    /**
     * @see ListItemTemplate::maskRadius
     */
    property alias maskRadius : _template.maskRadius
    
    /**
     * @brief Whether this element currently contains any item being dragged on top of it.
     * @property bool ListBrowserDelegate::containsDrag
     */
    readonly property alias containsDrag : _dropArea.containsDrag
    
    /**
     * @brief An alias to expose the DropArea component in charge of the drag&drop events.
     * @see contentDropped
     */
    readonly property alias dropArea : _dropArea
    
    /**
     * @brief An alias to access the layout fo this control handled by a RowLayout.
     * @property RowLayout ListBrowserDelegate::layout
     */
    readonly property alias layout : _layout
    
    /**
     * @brief Emitted when a drop event has been triggered on this control.
     * @param drop The object with information about the event.
     */
    signal contentDropped(var drop)
    
    /**
     * @brief Emitted when a drop event has entered the area of this control.
     * @param drop The object with information about the event.
     */
    signal contentEntered(var drag)
    
     /**
     * @brief Emitted when the control checked state has been changed.
     * @param state The checked state value. 
     */
    signal toggled(bool state)
    
    
    background: Rectangle
    {
      color: (control.isCurrentItem || control.containsPress ? Maui.Theme.highlightColor : ( control.hovered ? Maui.Theme.hoverColor : (control.flat ? "transparent" : Maui.Theme.alternateBackgroundColor)))
      
      radius: control.radius
      
      Rectangle
      {
        width: parent.width
        height: parent.height
        radius: control.radius
        visible: control.containsDrag
        color:  control.Maui.Theme.backgroundColor
        border.color: control.Maui.Theme.highlightColor
        
        Behavior on color
        {
          Maui.ColorTransition{}
        }
      }
      
      Behavior on color
      {
        enabled: !control.flat
        Maui.ColorTransition{}
      }
    }
    
    DropArea
    {
      id: _dropArea
      width: parent.width
      height: parent.height
      enabled: control.draggable
      
      onDropped: (drop) =>
      {
        control.contentDropped(drop)
      }
      
      onEntered: (drop) =>
      {
        control.contentEntered(drag)
      }
    }
    
    RowLayout
    {
      id: _layout
      anchors.fill: parent
      spacing: _template.spacing
      
      Loader
      {
        asynchronous: true
        active: control.checkable || control.checked
        visible: active
        
        Layout.alignment: Qt.AlignCenter
        
        scale: active? 1 : 0
        
        Behavior on scale
        {
          NumberAnimation
          {
            duration: Maui.Style.units.longDuration
            easing.type: Easing.InOutQuad
          }
        }
        
        sourceComponent: CheckBox
        {
          checkable: control.checkable
          autoExclusive: control.autoExclusive
          
          Binding on checked
          {
            value: control.checked
            restoreMode: Binding.RestoreBinding
          }
          
          onToggled: control.toggled(checked)
        }
      }
      
      Maui.ListItemTemplate
      {
        id: _template
        Layout.fillHeight: true
        Layout.fillWidth: true
        
        spacing: control.spacing
        
        hovered: control.hovered
        isCurrentItem : control.isCurrentItem
        highlighted: control.containsPress
      }
    }
}
