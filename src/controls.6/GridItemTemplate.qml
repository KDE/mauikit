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

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Item
 * @brief A template with a icon or image and a two bottom labels.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * The structure of this control is divided into a top header for the image/icon and a two labels for the title and message, at the bottom.
 * The top section can be modified and assigned to any custom control.
 * @see iconComponent
 *
 * For extra information checkout the GridBrowserDelegate documentation, since this template elementis  used as its base.
 */
Item
{
    id: control
    focus: true
    smooth: !Maui.Handy.isMobile

    implicitHeight: _layout.implicitHeight

    /**
      * @brief The spacing size between the image/icon header and the label title and message.
      * @property int GridItemTemplate::spacing
      */
    property alias spacing: _layout.spacing

    /**
   * @brief By default all children will be positioned at the bottom end of the column.
   * The positioning of the elements is handled by a ColumnLayout, so use the attached properties accordingly.
   * @property list<QtObject> GridItemTemplate::content
   */
    default property alias content: _layout.data

    /**
           * @brief The text use for the title text.
           * @property string GridItemTemplate::text1
           */
    property alias text1 : _label1.text

    /**
           * @brief The text use for the message text.
           * @property string GridItemTemplate::text2
           */
    property alias text2 : _label2.text

    /**
           * @brief An alias for the QQC2 Label handling the title text. Exposed for fine tuning the label font properties.
           * @note See the QQC2 Label documentation for more information.
           * @property Label GridItemTemplate::label1
           */
    readonly property alias label1 : _label1

    /**
           * @brief An alias for the QQC2 Label handling the message text. Exposed for fine tuning the label font properties.
           * @note See the QQC2 Label documentation for more information.
           * @property Label GridItemTemplate::label2
           */
    readonly  property alias label2 : _label2

    /**
           * @brief The Item loaded as the icon header section.
           * The component used as the icon header is loaded with a QQC2 Loader - this property exposes that element that was loaded.
           * By default the loaded item will be a MauiKit IconItem, but if another component is used for `iconComponent`, that will be the resulting Item.
           * @see structure
           * @property Item GridItemTemplate::iconItem
           */
    readonly property alias iconItem : _iconLoader.item

    /**
           * @brief The container for the icon header section. This is handled by a QQC2 Loader.
           * By default the source component will be loaded asynchronous.
           * @property Loader GridItemTemplate::iconContainer
           */
    readonly property alias iconContainer : _iconLoader

    /**
           * @brief Whether the icon/image header section should be visible.
           * @property bool GridItemTemplate::iconVisible
           */
    property alias iconVisible : _iconLoader.visible

    /**
           * @brief A size hint for the bottom labels. The final size will depend on the available space.
           * @property int GridItemTemplate::iconSizeHint
           */
    property alias labelSizeHint : _labelsContainer.labelSizeHint

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
           * By default this is set to `Image.PreserveAspectCrop`.
           * @note For more options and information review the QQC2 Image documentation.
           */
    property int fillMode : Image.PreserveAspectCrop

    /**
           * @see IconItem::maskRadius
           */
    property int maskRadius: 0

    /**
           * @see IconItem::imageWidth
           */
    property int imageWidth : -1

    /**
           * @see IconItem::imageHeight
           */
    property int imageHeight: -1

    /**
           * @see IconItem::isMask
           * By default this is set to evaluate `true` for icons equal or smaller in size then 16 pixels.
           */
    property bool isMask : iconSizeHint <= Maui.Style.iconSizes.small

    /**
           * @brief Whether the control should be styled as being hovered by a cursor.
           * By default his is set to `false`.
           */
    property bool hovered: false

    /**
           * @brief Whether the image should be auto transformed, that means auto rotated.
           * @note See the QQC2 Image documentation for further information on this property.
           * By default this is set to `false`.
           */
    property bool autoTransform: false

    /**
           * @brief Whether the control should be styled as being highlighted by some external event.
           * By default this is set to `false`.
           */
    property bool highlighted: false

    /**
           * @brief The horizontal alignment of the control elements. If the text in the labels should be aligned to the left, right or be centered. This can also affect the icon.
           * By default this is set to `Qt.AlignHCenter`.
           * Possible values are:
           * - Qt.AlignLeft
           * - Qt.AlignRight
           * - Qt.AlignHCenter
           */
    property int alignment: Qt.AlignHCenter

    /**
           * @brief The header section can be modified by changing its component to a custom one. By default the component used for the `iconComponent` is a MauiKit IconItem element.
           * @note When using a custom component for the header section, pay attention that it has an `implicitHeight` and `implicitWidth` set.
           */
    property Component iconComponent : _iconComponent

    Component
    {
        id: _iconComponent

        Maui.IconItem
        {
            iconSource: control.iconSource
            imageSource: control.imageSource

            highlighted: control.isCurrentItem || control.highlighted
            hovered: control.hovered
            smooth: control.smooth
            iconSizeHint: control.iconSizeHint
            imageSizeHint: control.imageSizeHint

            fillMode: control.fillMode
            maskRadius: control.maskRadius

            imageWidth: control.imageWidth
            imageHeight: control.imageHeight

            isMask: control.isMask
            image.autoTransform: control.autoTransform

            alignment: control.alignment
        }
    }

    ColumnLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: Maui.Style.space.medium

        Loader
        {
            id: _iconLoader

            Layout.fillWidth: true
            Layout.fillHeight: true

            asynchronous: true
            active: visible
            sourceComponent: control.iconComponent

            Behavior on scale
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.OutBack
                }
            }
        }

        Item
        {
            id: _labelsContainer
            property int labelSizeHint: Math.min(64, _labels.implicitHeight)
            visible: control.labelsVisible && ( _label1.text || _label2.text)

            Layout.preferredHeight: labelSizeHint
            Layout.fillWidth: true
            Layout.maximumHeight: control.height* 0.9
            Layout.minimumHeight: labelSizeHint

            ColumnLayout
            {
                id: _labels
                anchors.fill: parent
                spacing: Maui.Style.space.tiny

                Label
                {
                    id: _label1
                    visible: text && text.length

                    horizontalAlignment: control.alignment
                    verticalAlignment: Qt.AlignVCenter

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignCenter

                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    color: control.isCurrentItem || control.highlighted? control.Maui.Theme.highlightedTextColor : control.Maui.Theme.textColor
                }

                Label
                {
                    id: _label2
                    visible: text.length

                    horizontalAlignment: control.alignment
                    verticalAlignment: Qt.AlignVCenter

                    Layout.fillWidth: visible
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignCenter

                    elide: Qt.ElideRight
                    wrapMode: Text.NoWrap
                    color: control.isCurrentItem || control.highlighted? control.Maui.Theme.highlightedTextColor : control.Maui.Theme.textColor
                    opacity: control.isCurrentItem ? 0.8 : 0.6
                }
            }
        }
    }
}
