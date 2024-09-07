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

import org.mauikit.controls as Maui

/**
 * @inherit SwipeItemDelegate
 * @brief A control used to display information in a horizontal layout, and with a set of actions placed underneath that is revealed by swiping to the left. 
 * 
 * This control inherits from MauiKit SwipeItemDelegate, to checkout its inherited properties refer to the docs.
 * 
 * @image html Misc/swipebrowserdelegate1.gif "Revealing the actions in the compact mode"
 *
 * @image html Misc/swipebrowserdelegate2.gif "Revealing the actions in the expanded mode"
 * 
 * @note The compact/expanded modes are controlled by using the `SwipeItemDelegate::collapse` property.
 * @see SwipeItemDelegate::collapse
 * 
 * @code
 * Maui.SwipeBrowserDelegate
 * {
 *    width: parent.width
 *    label1.text: "A Title For This"
 *    label2.text: "Subtitle text with more info"
 * 
 *    quickActions: [
 *    Action
 *        {
 *            icon.name: "list-add"
 *        },
 * 
 *        Action
 *        {
 *            icon.name: "folder-new"
 *        },
 * 
 *        Action
 *        {
 *            icon.name: "anchor"
 *        }
 * 
 *    ]
 * 
 *    actionRow: ToolButton
 *    {
 *        icon.name: "love"
 *    }
 * }
 * @endcode
 */
Maui.SwipeItemDelegate
{
  id: control
  
  implicitHeight: Math.max(_template.implicitHeight, buttonsHeight) + topPadding + bottomPadding
  
  /**
   * @see ListItemTemplate::label1
   */
  property alias label1 : _template.label1
  
  /**
   * @see ListItemTemplate::label2
   */
  property alias label2 : _template.label2
  
  /**
   * @see ListItemTemplate::label3
   */
  property alias label3 : _template.label3
  
  /**
   * @see ListItemTemplate::label4
   */
  property alias label4 : _template.label4
  
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
   * @brief An alias to the information container handled by a MauiKit ListItemTemplate.
   * Exposed here for allowing access to its properties.
   * @property LisItemTemplate SwipeBrowserDelegate::template
   */
  property alias template : _template
  
  Maui.ListItemTemplate
  {
    id: _template
    anchors.fill: parent
  }
}
