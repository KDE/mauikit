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

/**
 * @brief A basic delagate for a label and an icon, to be used in a list browser.
 * This controls inherits from MauiKit ItemDelegate, to checkout its inherited properties refer to docs.
 * 
 * @note This is a simplified version fo the ListBrowserDelegate. The main difference is this one is not checkable.
 */
Maui.ItemDelegate
{
  id: control
  
  implicitHeight: _template.implicitHeight + topPadding + bottomPadding
  
  padding: Maui.Style.defaultPadding
  spacing: Maui.Style.space.medium
  
  /**
   * @see ListItemTemplate::labelsVisible
   */
  property alias labelVisible : _template.labelsVisible
  
  /**
   * @see ListItemTemplate::iconSizeHint
   */
  property alias iconSize : _template.iconSizeHint
  
  /**
   * @see ListItemTemplate::iconVisible
   */
  property alias iconVisible : _template.iconVisible
  
  /**
   * @see ListItemTemplate::text1
   */
  property alias label: _template.text1
  
  /**
   * @see ListItemTemplate::text2
   */
  property alias label2: _template.text2
  
  /**
   * @see ListItemTemplate::iconSource
   */
  property alias iconName: _template.iconSource
  
  /**
   * @see An alias to the template item handling the information.
   * @property ListItemTemplate ListDelegate::template
   */
  property alias template : _template
  
  isCurrentItem : ListView.isCurrentItem
  
  ToolTip.delay: 1000
  ToolTip.timeout: 5000
  ToolTip.visible: hovered
  ToolTip.text: control.label
  
  Maui.ListItemTemplate
  {
    id: _template
    spacing: control.spacing
    
    anchors.fill: parent
    hovered: control.hovered      
    isCurrentItem: control.isCurrentItem
    highlighted: control.containsPress 
  }
}
