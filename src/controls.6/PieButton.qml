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

import org.mauikit.controls 1.3 as Maui

import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

/**
 * @inherit QtQuick.Controls.Control
 * @brief A group of actions positioned in a plegable ribbon that fold/unfolds from a big floating colored button.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-control.html">This control inherits from QQC2 Control, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 *  @image html Misc/piebutton.gif
 *  
 *  @code
 *  Maui.PieButton
 *  {
 *      Maui.Theme.inherit: false
 *      anchors.right: parent.right
 *      anchors.bottom: parent.bottom
 *      anchors.margins: Maui.Style.space.big
 * 
 *      icon.name: "list-add"
 * 
 *      Action
 *      {
 *          icon.name: "love"
 *      }
 * 
 *      Action
 *      {
 *          icon.name: "folder"
 *      }
 * 
 *      Action
 *      {
 *          icon.name: "anchor"
 *      }
 *  }
 *  @endcode
 *  
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/PieButton.qml">You can find a more complete example at this link.</a>
 * 
 */
Control
{
  id: control
  
  /**
   * @brief The action children of this control.
   */
  default property list<Action> actions
  
  /**
   * @brief The icon group property alias to set the icon name, color, and size.
   * @note See Qt documentation on the icon group.
   * @property icon PieButton::icon
   */
  property alias icon : _button.icon
  
  /**
   * @brief The text to be use in the main floating button.
   * @property string PieButton::text
   */
  property alias text: _button.text
  
  /**
   * @brief How to display the text and the icon of the main floating button.
   * By default this is set to `ToolButton.IconOnly`
   * @property enum PieButton::display
   */
  property alias display: _button.display
  
  implicitWidth: implicitContentWidth + leftPadding + rightPadding
  implicitHeight: implicitContentHeight + topPadding + bottomPadding
  
  // Behavior on implicitWidth
  // {
  //     NumberAnimation
  //     {
  //         duration: Maui.Style.units.longDuration
  //         easing.type: Easing.InOutQuad
  //     }
  // }
  
  background: Rectangle
  {
    id: _background
    visible: control.implicitWidth > height
    
    color: Maui.Theme.backgroundColor
    radius: Maui.Style.radiusV
    layer.enabled: true
    
    layer.effect: DropShadow
    {
      cached: true
      horizontalOffset: 0
      verticalOffset: 0
      radius: 8.0
      samples: 16
      color: "#333"
      opacity: 0.5
      smooth: true
      source: _background
    }
  }
  
  contentItem: RowLayout
  {
    id: _layout
    
    Maui.ToolBar
    {
      id: _actionsBar
      visible: false
      
      background: null
      
      middleContent: Repeater
      {
        model: control.actions
        
        ToolButton
        {
          Layout.fillHeight: true
          action: modelData
          display: ToolButton.TextUnderIcon
          onClicked: control.close()
        }
      }
    }
    
    Maui.FloatingButton
    {
      id: _button
      Layout.alignment:Qt.AlignRight
      
      onClicked: _actionsBar.visible = !_actionsBar.visible
    }
  }
  
  /**
   * @brief Forces to open the ribbon containing the action buttons.
   */
  function open()
  {
    _actionsBar.visible = true
  }
  
  /**
   * @brief Forces to close the ribbon containing the action buttons.
   */
  function close()
  {
    _actionsBar.visible = false
  }
}




