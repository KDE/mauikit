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

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Rectangle
{
    id: control
    
    color: "transparent"
    
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
    property alias maskRadius: control.radius
    
    property int imageWidth : -1
    property int imageHeight : -1

    Kirigami.Icon
    {
        id: icon
        visible: img.status === Image.Null || img.status !== Image.Ready || img.status === Image.Error

        anchors.centerIn: parent
        source: control.iconSource || "folder-images"
        height: Math.floor(Math.min(parent.height, control.iconSizeHint))
        width: height
        color: control.highlighted ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
        isMask: height <= Maui.Style.iconSizes.medium
    }

    Image
    {
        id: img

        width:  imageSizeHint >=0  ? imageSizeHint : parent.width
        height:  imageSizeHint >= 0 ? imageSizeHint : parent.height

        anchors.centerIn: parent

        sourceSize.width:  (control.imageWidth > -1 ? control.imageWidth : width)
        sourceSize.height:  (control.imageHeight > -1 ? control.imageHeight : height)

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        fillMode: control.fillMode

        source: control.imageSource

        cache: false
        asynchronous: true
        smooth: true

        layer.enabled: control.radius
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
                    radius: control.radius
                }
            }
        }
    }
}
