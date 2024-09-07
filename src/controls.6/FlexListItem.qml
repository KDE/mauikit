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
import QtQuick.Layouts 

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.ItemDelegate
 *  @since org.mauikit.controls.labs 1.0
 *  @brief A template to position information next to a flexing right-content section, that wraps into a new line under constrained space conditions.
 *  
 *  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-itemdelegate.html">This control inherits from QQC2 ItemDelegate, to checkout its inherited properties refer to the Qt Docs.</a>
 *  
 *  @image html Misc/flexlistitem.png "Expanded vs wrapped"
 *  
 * @code
 * Column
 * {
 *    anchors.centerIn: parent
 *    width: parent.width
 * 
 *    Maui.FlexListItem
 *    {
 *        id: _flexItem
 *        width: parent.width
 *        label1.text: "Flex List Item"
 *        label2.text: "This item is reposnive and will split into a column on a narrow space."
 *        iconSource: "love"
 * 
 *        Rectangle
 *        {
 *            color: "purple"
 *            radius: 4
 *            implicitHeight: 64
 *            implicitWidth: 140
 *            Layout.fillWidth: !_flexItem.wide
 *            Layout.minimumWidth: 140
 *        }
 * 
 *        Rectangle
 *        {
 *            color: "yellow"
 *            radius: 4
 *            implicitHeight: 64
 *            implicitWidth: 80
 *            Layout.fillWidth: !_flexItem.wide
 *        }
 *    }
 * }
 * @endcode
 *  
 *  @section notes Notes
 *  It is possible to manually set the number of columns to be used using the `columns` property, but this will break the auto wrapping functionality of the `wide` property. So consider using this property only if it is really needed to be forced. 
 *  
 *  <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/FlexLisItem.qml">You can find a more complete example at this link.</a>  
 */
ItemDelegate
{
  id: control
  
  /**
   * @brief The items declared as the children of this element will wrap into a new line on constrained spaces. 
   * @note The content is handled by a RowLayout, so to position items use the Layout attached properties.
   * @property list<QtObject> FlexListItem::content
   */
  default property alias content : _content.data
    
    /**
     * @brief An alias to the template element handling the information labels and image/icon. 
     * @see ListItemTemplate
     * @property ListItemTemplate FlexListItem::template
     */
    property alias template: _template
    
    /**
     * @brief The Label element for the title. 
     * @property Label FlexListItem::label1
     */
    property alias label1 : _template.label1
    
    /**
     * @brief The Label element for the message body. 
     * @property Label FlexListItem::label2
     */
    property alias label2 : _template.label2
    
    /**
     * @brief The Label element for extra information positioned on the right top side.. 
     * @property Label FlexListItem::label3
     */
    property alias label3 : _template.label3
    
    /**
     * @brief The Label element for extra information positioned on the right bottom side.. 
     * @property Label FlexListItem::label4
     */
    property alias label4 : _template.label4
    
    /**
     * @brief The icon name to be used in the information section.
     * @property string FlexListItem::iconSource
     */
    property alias iconSource : _template.iconSource
    
    /**
     * @brief The image source file to be used in the information section.
     * @property url FlexListItem::imageSource
     */
    property alias imageSource : _template.imageSource
    
    /**
     * @brief The size hint for the icon container.
     * @property int FlexListItem::iconSizeHint
     */
    property alias iconSizeHint : _template.iconSizeHint
    
    /**
     * @brief Whether the layout will be wrapped into a new line or not. If `wide: true` then a single line is used, but otherwise the layout is split into two lines, at the top the information labels and and the bottom all the children elements.
     * @see content
     */
    property bool wide : _content.implicitWidth < _layout.width*0.5 
    
    /**
     * @brief The spacing of the rows, when the layout is wrapped.
     * @property int FlexListItem::rowSpacing
     */
    property alias rowSpacing : _layout.rowSpacing
    
    /**
     * @brief The spacing of the columns, when the layout is not wrapped.
     * @property int FlexListItem::columnSpacing
     */
    property alias columnSpacing: _layout.columnSpacing    
    
    /**
     * @brief This allows to manually set the number of columns to be used.
     * By default his value is set to 2 when it is wide, and to 1 otherwise.
     * @warning Using this property will break the wrapping functionality via the `wide` property.
     */
    property alias columns: _layout.columns
    
    /**
     * @brief This allows to manually set the number of rows to be used. By default this uses maximum two [2] rows.
     * @warning Using this property will break the wrapping functionality via the `wide` property.
     */
    property alias rows: _layout.rows    
    
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    // implicitWidth: _layout.implicitWidth + topPadding + bottomPadding
    
    background: null
    
    spacing: Maui.Style.defaultSpacing
    
    contentItem: GridLayout
    {
      id: _layout
      
      rowSpacing: control.spacing
      columnSpacing: control.spacing
      
      columns: control.wide ? 2 : 1
      
      Maui.ListItemTemplate
      {
        id: _template
        Layout.fillWidth: true
        iconSizeHint: Maui.Style.iconSizes.medium
        label2.wrapMode: Text.WordWrap
        label1.font.weight: Font.Medium
      }
      
      RowLayout
      {
        id: _content 
        Layout.fillWidth: !control.wide
      }
    }
}
