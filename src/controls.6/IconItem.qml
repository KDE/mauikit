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
import QtQuick.Effects

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Item
 *    @since org.mauikit.controls 1.0
 *    @brief An element to display an icon from the icon theme or file asset; or an image from a local file or a remote URL.
 *
 *    <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 *    @note The image can be masked to have a rounded borders.
 *    @see maskRadius
 *
 *    @image html Misc/iconitem.png
 *
 *    @code
 *    Row
 *    {
 *        anchors.centerIn: parent
 *        spacing: Maui.Style.space.big
 *
 *        Maui.IconItem
 *        {
 *            imageSource: "file:///home/camiloh/Downloads/premium_photo-1664203068007-52240d0ca48f.avif"
 *            imageSizeHint: 200
 *            maskRadius: 100
 *            fillMode: Image.PreserveAspectCrop
 *
 *        }
 *
 *        Maui.IconItem
 *        {
 *            iconSource: "vvave"
 *            iconSizeHint: 94
 *        }
 *    }
 *    @endcode
 *
 *    @section notes Notes
 *
 *    By default this item is only visible if the image source is ready or if the icon is valid. You can make it always visible, but would be a better idea to set a fallback icon with `icon.fallback: "icon-name"`.
 *
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SideBarView.qml">You can find a more complete example at this link.</a>
 */
Item
{
    id: control

    // visible: icon.valid || img.status === Image.Ready

    implicitHeight: img.visible ? Math.max(imageSizeHint, iconSizeHint) : iconSizeHint
    implicitWidth: img.visible ? Math.max(imageSizeHint, iconSizeHint) : iconSizeHint

    smooth: !Maui.Handy.isMobile

    /**
     * @brief Whether the control should be styled as being highlighted by some external event.
     * By default this is set to `false`.
     * @note When highlighted a monochromatic icon will take the color fo the accent color.
     */
    property bool highlighted: false

    /**
     * @brief Whether the control should be styled as being hovered by a cursor.
     * By default his is set to `false`.
     */
    property bool hovered: false

    /**
     * @brief A hint for the size of the icon. It will never be larger than the actual container size.
     * @note If the container size is 200x200, and the icon size hint has been set to 64, then the icon will be centered. If the icon size hint is larger, then the maximum value will be the container size.
     *
     * By default this is set to `Style.iconSizes.big`.
     */
    property int iconSizeHint : Maui.Style.iconSizes.big

    /**
     * @brief A hint for the size of the image. It will never be larger than the actual container size.
     * @note If the container size is 200x200, and the image size hint has been set to 140, then the image will be aligned following the `alignment` property. If the image size hint is larger, then the maximum value will be the container size.
     * @see alignment
     *
     * By default this is set to `-1`.
     */
    property int imageSizeHint :  -1

    /**
     * @brief The local or remote file URL of the image to be used.
     * @property string IconItem::imageSource
     */
    property alias imageSource : img.source

    /**
     * @brief The name of the icon to be used.
     * @property string IconItem::iconSource
     */
    property alias iconSource : icon.source

    /**
     * @brief The preferred fill mode for the image.
     * By default this is set to `Image.PreserveAspectFit`.
     * @note For more options and information review the QQC2 Image documentation.
     * @property enum IconItem::fillMode
     */
    property alias fillMode : img.fillMode

    /**
     * @brief The border radius to mask the icon/image header section.
     * By default this is set to `0`.
     */
    property int maskRadius: 0

    /**
     * @brief The painted width size of the image. This will make the image resolution fit this size.
     * By default this is set to `-1`, which means that the image will be loaded with its original resolution size.
     */
    property int imageWidth : -1

    /**
     * @brief The painted height size of the image. This will make the image resolution fit this size.
     * By default this is set to `-1`, which means that the image will be loaded with its original resolution size.
     */
    property int imageHeight : -1

    /**
     * @brief Whether the icon should be masked and tinted with the text color, this is used for monochromatic icons. If you plan to use a colorful icon, consider setting this property to `false`.
     */
    property alias isMask : icon.isMask

    /**
     * @brief An alias to the QQC2 Image control for displaying the image.
     * @note Review the control own properties on Qt documentation.
     * @property Image IconItem::image
     */
    readonly property alias image : img

    /**
     * @brief An alias to the MauiKit Icon control for displaying the icon.
     * @see Icon
     * @property Icon IconItem::icon
     */
    readonly property alias icon: icon

    /**
     * @brief The desired color for tinting the monochromatic icons.
     * By default this is set to check the `isMask` property, and then decide base on the `highlighted` property is use the text color or accent color.
     */
    property color color : isMask ? (control.highlighted ? Maui.Theme.highlightedTextColor : Maui.Theme.textColor) : "transparent"

    /**
     * @brief The aligment of the image in the container.
     * If the `imageSizeHint` has been set to a smaller size than the container, then its alignment will be dtermined by this property. Otherwise the image will fill the container size.
     * By default this is set to `Qt.AlignHCenter`.
     * Possible values are:
     * - Qt.AlignLeft
     * - Qt.AlignRight
     * - Qt.AlignHCenter
     */
    property int alignment: Qt.AlignHCenter

    Maui.Icon
    {
        id: icon
        visible: (img.status === Image.Null || img.status !== Image.Ready || img.status === Image.Error) && valid

        smooth: control.smooth
        anchors.centerIn: parent
        height: visible ? Math.min(parent.height, control.iconSizeHint) : 0
        width: height
        color: control.color
        isMask: (height <= Maui.Style.iconSizes.medium)
    }

    Image
    {
        id: img

        width: imageSizeHint >=0 ? Math.min(parent.width, imageSizeHint) : parent.width
        height: imageSizeHint >= 0 ? Math.min(parent.height, imageSizeHint) : parent.height
//
        visible: status == Image.Ready
        // height: visible ? (control.imageSizeHint > parent.height ? parent.height : control.imageSizeHint) : 0
        // width: visible ? (control.imageSizeHint > parent.width ? parent.width : control.imageSizeHint) : 0

        anchors.verticalCenter: parent.verticalCenter
        x: switch(control.alignment)
        {
            case Qt.AlignLeft: return 0
            case Qt.AlignHCenter: return control.width/2 - width/2
            case Qt.AlignRight: return control.width - width
        }

        sourceSize.width: control.imageWidth > 0 ? control.imageWidth : width
        sourceSize.height: control.imageHeight > 0 ? control.imageHeight : height

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        cache: !Maui.Handy.isMobile
        asynchronous: true
        smooth: control.smooth
        mipmap: false

        layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software && control.maskRadius
        layer.effect: MultiEffect
        {
            maskEnabled: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
            maskSpreadAtMax: 0.0
            maskThresholdMax: 1.0
            maskSource: ShaderEffectSource
            {
                sourceItem:  Item
                {
                    width: img.width
                    height: img.height

                    Rectangle
                    {
                        anchors.centerIn: parent
                        width: Math.min(parent.width, img.paintedWidth)
                        height: Math.min(parent.height, img.paintedHeight)
                        radius: control.maskRadius
                    }
                }
            }
        }
    }
}
