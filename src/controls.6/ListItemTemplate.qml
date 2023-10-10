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
import QtQuick.Layouts
import QtQuick.Controls

import org.mauikit.controls 1.3 as Maui

/**
 * @brief A template for an horizontal layout of information. 
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 *   
 * The structure of this control is divided into a left side header for the image/icon and a four [4] labels for the title, message at the right side of the header, and at the far right side another two labels for complementary information.
 * 
 * The icon header section can be modified and assigned to any custom control.
 * @see iconComponent
 * 
 * For extra information checkout the ListBrowserDelegate documentation, since this template element is used as its base.
 */
Item
{
     id: control
     
     implicitHeight: _layout.implicitHeight
     
     /**
      * @brief By default all children will be positioned at the right end of the row.
      * The positioning of the elements is handled by a RowLayout, so use the attached properties.
      * @property list<QtObject> ListItemTemplate::content
      */
     default property alias content: _layout.data
          
          /**
           * @brief The spacing size between the image/icon header and the labels columns.
           * @property int ListItemTemplate::spacing
           */
          property alias spacing: _layout.spacing
          
          /**
           * @brief The text use for the main title text.
           * @property string ListItemTemplate::text1
           */
          property alias text1 : _label1.text
          
          /**
           * @brief The text use for the subtitle text.
           * @property string ListItemTemplate::text2
           */
          property alias text2 : _label2.text
          
          /**
           * @brief The text use for the left-top far side text.
           * @property string ListItemTemplate::text3
           */
          property alias text3 : _label3.text
          
          /**
           * @brief The text use for the left-bottom far side text.
           * @property string ListItemTemplate::text4
           */
          property alias text4 : _label4.text
          
          /**
           * @brief An alias for the QQC2 Label handling the title text. Exposed for fine tuning the label font properties.
           * @note See the QQC2 Label documentation for more information.
           * @property Label ListItemTemplate::label1
           */
          readonly property alias label1 : _label1
          
          /**
           * @brief An alias for the QQC2 Label handling the subtitle text. Exposed for fine tuning the label font properties.
           * @note See the QQC2 Label documentation for more information.
           * @property Label ListItemTemplate::label2
           */
          readonly property alias label2 : _label2
          
          /**
           * @brief An alias for the QQC2 Label handling the extra information text. Exposed for fine tuning the label font properties.
           * @note See the QQC2 Label documentation for more information.
           * @property Label ListItemTemplate::label3
           */
          readonly property alias label3 : _label3
          
          /**
           * @brief An alias for the QQC2 Label handling the extra information text. Exposed for fine tuning the label font properties.
           * @note See the QQC2 Label documentation for more information.
           * @property Label ListItemTemplate::label4
           */
          readonly property alias label4 : _label4
          
          /**
           * @brief The container for the icon header section. This is handled by a QQC2 Loader.
           * By default the source component will be loaded asynchronous.
           * @property Loader ListItemTemplate::iconContainer
           */
          readonly  property alias iconContainer : _iconLoader
          
          /**
           * @brief The Item loaded as the icon header section.
           * The component used as the icon header is loaded with a QQC2 Loader - this property exposes that element that was loaded.
           * By default the loaded item will be a MauiKit IconItem, but if another component is used for `iconComponent`, that will be the resulting Item.
           * @see structure
           * @property Item ListItemTemplate::iconItem
           */
          readonly property alias iconItem : _iconLoader.item
          
          /**
           * @brief Whether the icon/image header section should be visible.
           * @property bool ListItemTemplate::iconVisible
           */
          property alias iconVisible : _iconLoader.visible
          
          /**
           * @brief An alias to the column element hosting the title and message labels.
           * @property ColumnLayout ListItemTemplate::leftLabels
           * @see label1
           * @see label2
           * @property ColumnLayout ListItemTemplate::leftLabels
           */
          readonly property alias leftLabels : _leftLabels
          
          /**
           * @brief An alias to the column element hosting the far-right extra labels.
           * @property ColumnLayout ListItemTemplate::rightLabels
           * @see label3
           * @see label4
           * @property ColumnLayout ListItemTemplate::rightLabels
           */
          readonly property alias rightLabels : _rightLabels
                    
          /**
           * @brief An alias to the container layout for this control.
           * This is handled by a RowLayout.
           * @property RowLayout ListItemTemplate::layout
           */
          readonly property alias layout : _layout
          
          /**
           * @brief A size hint for the icon to be used in the header. The final size will depend on the available space.
           */
          property int iconSizeHint : Maui.Style.iconSizes.big
          
          /**
           * @brief A size hint for the image to be used in the header. The final size will depend on the available space.
           * By default this is set to `-1` which means that the image header will take the rest of the available space.
           */
          property int imageSizeHint : -1
          
          /**
           * @brief The size of the header section. This is the size the header container will take.
           * By default this is set to `-1` which means that the size of the header will be determined by the child implicit height and width.
           */
          property int headerSizeHint : -1
          
          /**
           * @see IconItem::imageSource
           */
          property string imageSource
          
          /**
           * @see IconItem::iconSource
           */
          property string iconSource
          
          /**
           * @brief Whether this element is currently on a selected or checked state. This is used to highlight the component accordingly.
           * By default this is set to `false`.
           */
          property bool isCurrentItem: false
          
          /**
           * @brief Whether the two bottom labels, for title and message, should be displayed.
           * By default this is set to `true`.
           */
          property bool labelsVisible: true          
          
          /**
           * @see IconItem::fillMode
           * By default this is set to `Image.PreserveAspectFit`.
           * @note For more options and information review the QQC2 Image documentation.
           */
          property int fillMode : Image.PreserveAspectFit
          
          /**
           * @see IconItem::maskRadius
           */
          property int maskRadius: 0
          
          /**
           * @brief The header section can be modified by changing its component to a custom one. By default the component used for the `iconComponent` is a MauiKit IconItem element.
           * @note When using a custom component for the header section, pay attention that it has an `implicitHeight` and `implicitWidth` set.
           */   
          property Component iconComponent : _iconComponent
          
          /**
           * @see IconItem::isMask
           * By default this is set to evaluate `true` for icons equal or smaller in size then 16 pixels.
           */
          property bool isMask : iconSizeHint <= Maui.Style.iconSizes.medium
          
          /**
           * @brief Whether the control should be styled as being hovered by a cursor.
           * By default his is set to `false`.
           */
          property bool hovered: false
          
          /**
           * @brief Whether the control should be styled as being highlighted by some external event.
           * By default this is set to `false`.
           */
          property bool highlighted: false
          
          Component
          {
               id: _iconComponent
               
               Maui.IconItem
               {
                    iconSource: control.iconSource
                    imageSource: control.imageSource
                    
                    highlighted: control.isCurrentItem || control.highlighted
                    hovered: control.hovered
                    
                    iconSizeHint: control.iconSizeHint
                    imageSizeHint: control.imageSizeHint
                    
                    fillMode: control.fillMode
                    maskRadius: control.maskRadius
                    
                    isMask: control.isMask
               }
          }
          
          RowLayout
          {
               id: _layout
               anchors.fill: parent
               spacing: Maui.Style.space.small
               
               readonly property color labelColor: control.isCurrentItem || control.highlighted? Maui.Theme.highlightedTextColor : Maui.Theme.textColor
               
               Loader
               {
                    id: _iconLoader
                    
                    asynchronous: true
                    
                    visible: (control.width > Maui.Style.units.gridUnit * 10) && (control.iconSource.length > 0 || control.imageSource.length > 0)
                    
                    active: visible
                    
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: !control.labelsVisible
                    Layout.fillHeight: true
                    Layout.preferredWidth: Math.max(implicitWidth, control.headerSizeHint)
                    Layout.preferredHeight: Math.max(implicitHeight, control.headerSizeHint)
                    
                    sourceComponent: control.iconComponent
               }
               
               
               ColumnLayout
               {
                    id: _leftLabels
                    clip: true
                    visible: control.labelsVisible
                    
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    
                    spacing: 0
                    
                    Label
                    {
                         id: _label1
                         visible: text.length
                         
                         Layout.fillWidth: true
                         Layout.fillHeight: true
                         
                         verticalAlignment: _label2.visible ? Qt.AlignBottom :  Qt.AlignVCenter
                         
                         elide: Text.ElideRight
                         //                wrapMode: _label2.visible ? Text.NoWrap : Text.Wrap
                         wrapMode: Text.NoWrap
                         textFormat: Text.PlainText
                         color: _layout.labelColor
                    }
                    
                    Label
                    {
                         id: _label2
                         visible: text.length
                         
                         Layout.fillWidth: true
                         Layout.fillHeight: true
                         verticalAlignment: _label1.visible ? Qt.AlignTop : Qt.AlignVCenter
                         
                         elide: Text.ElideRight
                         //                wrapMode: Text.Wrap
                         wrapMode: Text.NoWrap
                         textFormat: Text.PlainText
                         color: _layout.labelColor
                         opacity: control.isCurrentItem ? 0.8 : 0.6
                    }
               }
               
               ColumnLayout
               {
                    id: _rightLabels
                    clip: true
                    // visible: (control.width >  Maui.Style.units.gridUnit * 15) && control.labelsVisible
                    
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.maximumWidth: control.width/2
                    Layout.preferredWidth: implicitWidth
                    Layout.minimumWidth: 0
                    spacing: _leftLabels.spacing
                    
                    Label
                    {
                         id: _label3
                         visible: text.length > 0
                         
                         Layout.fillHeight: true
                         Layout.fillWidth: true
                         
                         Layout.alignment: Qt.AlignRight
                         
                         horizontalAlignment: Qt.AlignRight
                         verticalAlignment: _label4.visible ? Qt.AlignBottom :  Qt.AlignVCenter
                         
                         font.pointSize: Maui.Style.fontSizes.tiny
                         
                         wrapMode: Text.NoWrap
                         elide: Text.ElideMiddle
                         textFormat: Text.PlainText
                         color: _layout.labelColor
                         opacity: control.isCurrentItem ? 0.8 : 0.6
                    }
                    
                    Label
                    {
                         id: _label4
                         visible: text.length > 0
                         
                         Layout.fillHeight: true
                         Layout.fillWidth: true
                         
                         Layout.alignment: Qt.AlignRight
                         horizontalAlignment: Qt.AlignRight
                         verticalAlignment: _label3.visible ? Qt.AlignTop : Qt.AlignVCenter
                         
                         font.pointSize: Maui.Style.fontSizes.tiny
                         
                         wrapMode: Text.NoWrap
                         elide: Text.ElideMiddle
                         textFormat: Text.PlainText
                         color: _layout.labelColor
                         opacity: control.isCurrentItem ? 0.8 : 0.6
                    }
               }
          }
}
