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
import Qt5Compat.GraphicalEffects

import org.mauikit.controls 1.3 as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Item
{
    id: control

    implicitHeight: Math.max(iconSizeHint, imageSizeHint)
    implicitWidth: Math.max(iconSizeHint, imageSizeHint)

    /**
     * iconSizeHint : int
     */
    property bool highlighted: false
    
    /**
     * iconSizeHint : int
     */
    property bool hovered: false
    
    /**
     * iconSizeHint : int
     */
    property int iconSizeHint : Maui.Style.iconSizes.big
    
    /**
     * iconSizeHint : int
     */
    property int imageSizeHint : -1
    
    
    /**
     * imageSource : string
     */
    property string imageSource
    
    /**
     * iconSource : string
     */
    property string iconSource
    
    /**
     * fillMode : Image.fillMode
     */
    property int fillMode : Image.PreserveAspectFit
    /**
     * maskRadius : int
     */
    property int maskRadius: 0
    
    property int imageWidth : -1
    property int imageHeight : -1
    
    property bool smooth: false

    property alias isMask : icon.isMask
    property alias image : img
    property alias icon: icon
    
    property int alignment: Qt.AlignHCenter
    
    Maui.Icon
    {
        id: icon
        visible: img.status === Image.Null || img.status !== Image.Ready || img.status === Image.Error
        smooth: control.smooth
        anchors.centerIn: parent
        //anchors.verticalCenter: parent.verticalCenter

        //        x: switch(control.alignment)
        //        {
        //            case Qt.AlignLeft: return 0
        //            case Qt.AlignHCenter: return control.width/2 - width/2
        //            case Qt.AlignRight: return control.width - width
        //        }

        source: control.iconSource || "folder-images"
        height: Math.floor(Math.min(parent.height, control.iconSizeHint))
        width: height
        color: isMask ? (control.highlighted ? Maui.Theme.highlightedTextColor : Maui.Theme.textColor) : "transparent"
        isMask: (height <= Maui.Style.iconSizes.medium)
        //         selected: control.highlighted
    }

    Image
    {
        id: img

        width: Math.min(imageSizeHint >=0  ? imageSizeHint : parent.width, parent.width)
        height: Math.min(imageSizeHint >= 0 ? imageSizeHint : parent.height, parent.height)

        anchors.verticalCenter: parent.verticalCenter
        x: switch(control.alignment)
           {
           case Qt.AlignLeft: return 0
           case Qt.AlignHCenter: return control.width/2 - width/2
           case Qt.AlignRight: return control.width - width
           }

        sourceSize.width: (control.imageWidth > -1 ? control.imageWidth : width)
        sourceSize.height: (control.imageHeight > -1 ? control.imageHeight : height)

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        fillMode: control.fillMode

        source: control.imageSource

        cache: true
        asynchronous: true
        smooth: control.smooth
        mipmap: false

        layer.enabled: control.maskRadius
        layer.effect: OpacityMask
        {
            maskSource: Item
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
