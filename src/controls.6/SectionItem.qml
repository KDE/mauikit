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
 * @since org.mauikit.controls
 * @brief An item used for holding information in a vertical column layout.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-itemdelegate.html">This control inherits from QQC2 ItemDelegate, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * Although it is similar to the SectionGroup (an information header with the children in a vertical layout) this control has some functionality differences, like being interactive and a different styling of the information labels. It is commonly use as the children elements of the SectionGroup.
 *
 * @note There is also the FlexSectionItem, which uses a dynamic layout for wrapping the content that does not fit.
 * @see FlexSectionItem
 *
 * @image html Misc/sectionitem.png "Three types of sections inside a SectionGroup"
 *
 * If the first and single child element of this control is `checkable`, then the state of such control will be toggled by clicking on the area of the SectionItem.
 *
 * @code
 * Maui.SectionGroup
 * {
 *    title: "Section with Children"
 *    description: "The description label can be a bit longer explaining something important. Maybe?"
 *
 *    Maui.SectionItem
 *    {
 *        label1.text: "Checkable section item"
 *        iconSource: "folder"
 *
 *        Switch
 *        {
 *            onToggled: checked = !checked
 *        }
 *    }
 *
 *    Maui.SectionItem
 *    {
 *        label1.text: "Single section item"
 *        iconSource: "anchor"
 *    }
 *
 *    Maui.SectionItem
 *    {
 *        label1.text: "Hello this is a two line section item"
 *        label2.text : "Subtitle text"
 *
 *        TextArea
 *        {
 *            Layout.fillWidth: true
 *        }
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SectionItem.qml">You can find a more complete example at this link.</a>
 */
ItemDelegate
{
  id: control

  padding: Maui.Style.defaultPadding
  spacing: Maui.Style.space.small

  Layout.fillWidth: true
  implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
  implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

  /**
   * @brief The items declared as the children of this element will wrap into a new line on constrained spaces.
   * @note The content is handled by a RowLayout, so to position items use the Layout attached properties.
   * @property list<QtObject> FlexListItem::content
   */
  default property alias content : _layout.data

    /**
     * @brief An alias to the template element handling the information labels and image/icon.
     * @see ListItemTemplate
     * @property ListItemTemplate FlexListItem::template
     */
    property alias template: _template

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
     * @see ListItemTemplate::iconSource
     */
    property alias iconSource : _template.iconSource

    /**
     * @see ListItemTemplate::imageSource
     */
    property alias imageSource : _template.imageSource

    /**
     * @see ListItemTemplate::iconSizeHint
     */
    property alias iconSizeHint : _template.iconSizeHint

    /**
     * @brief Whether the control should be styled as flat, as in not having a background or hover/pressed visual effect hints.
     * By default this is set to `!Handy.isMobile`
     * @see Handy::isMobile
     */
    property bool flat : !Maui.Handy.isMobile

    /**
     * @brief Whether the first children element from the `content` is checkable.
     * If it is the the control will have a hover effect to hint about the item being checkable.
     */
    readonly property bool childCheckable : control.content.length >= 2 && control.content[1].hasOwnProperty("checkable") ? control.content[1].checkable : false

    hoverEnabled: !Maui.Handy.isMobile

    background: Rectangle
    {
      color: control.enabled ? ( control.childCheckable && control.hovered ? Maui.Theme.hoverColor : (control.flat ? "transparent" : Maui.Theme.alternateBackgroundColor)) : "transparent"
      radius: Maui.Style.radiusV

      Behavior on color
      {
        enabled: !control.flat
        Maui.ColorTransition{}
      }
    }

    contentItem: ColumnLayout
    {
      id: _layout

      spacing: control.spacing

      Maui.ListItemTemplate
      {
        id: _template
        Layout.fillWidth: true
        iconSizeHint: Maui.Style.iconSizes.medium
        label2.wrapMode: Text.WordWrap
        label1.text: control.text
        label2.font.pointSize: Maui.Style.fontSizes.small
        iconSource: control.icon.name
      }
    }

    onClicked:
    {
      if(control.childCheckable)
      {
        console.log("Trying to toggle")
        control.content[1].toggled()
      }
    }
}
