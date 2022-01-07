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

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtQuick.Templates 2.15 as T

import QtGraphicalEffects 1.0

/**
 * Popup
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Popup
{
    id: control
    
    parent: ApplicationWindow.overlay
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    
    width: filling ? parent.width : mWidth
    height: filling ? parent.height : mHeight
    
    //     anchors.centerIn: Overlay.overlay
    
    Behavior on width
    {
        enabled: control.hint === 1
        
        NumberAnimation
        {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    Behavior on height
    {
        enabled: control.hint === 1
        
        NumberAnimation
        {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    readonly property int mWidth:  Math.round(Math.min(control.parent.width * widthHint, maxWidth))
    readonly property int mHeight: Math.round(Math.min(control.parent.height * heightHint, maxHeight))
    
    x: filling ? 0 : Math.round( parent.width / 2 - width / 2 )
    y: filling ? 0 : Math.round( positionY() )
    
    modal: !filling
    
    margins: 0
    padding: 0
    
    topPadding: control.padding
    bottomPadding: control.padding
    leftPadding: control.padding
    rightPadding: control.padding
    
    rightMargin: control.margins
    leftMargin: control.margins
    topMargin: control.margins
    bottomMargin: control.margins
    
    property bool filling : false
    /**
     * content : Item.data
     */
    default property alias content : _content.data

    /**
         * maxWidth : int
         */
    property int maxWidth : 700

    /**
         * maxHeight : int
         */
    property int maxHeight : 400

    /**
         * hint : double
         */
    property double hint : 0.9

    /**
         * heightHint : double
         */
    property double heightHint : hint

    /**
         * widthHint : double
         */
    property double widthHint : hint

    /**
         * verticalAlignment : int
         */
    property int verticalAlignment : Qt.AlignVCenter

    contentItem: Item
    {
        id: _content
        layer.enabled: !control.filling
        layer.effect: OpacityMask
        {
            cached: true
            maskSource: Item
            {
                width: _content.width
                height: _content.height

                Rectangle
                {
                    anchors.fill: parent
                    radius: control.background.radius
                }
            }
        }

        //            Rectangle
        //            {
        //                visible: !control.filling
        //                anchors.fill: parent
        //                color: "transparent"
        //                radius: Maui.Style.radiusV - 0.5
        //                border.color: Qt.lighter(control.Kirigami.Theme.backgroundColor, 2)
        //                opacity: 0.7
        //            }
    }

    background: Rectangle
    {
        color: control.Kirigami.Theme.backgroundColor

        radius: control.filling ? 0 : Maui.Style.radiusV
//        border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15);
        Behavior on color
        {
            ColorAnimation
            {
                easing.type: Easing.InQuad
                duration: Kirigami.Units.longDuration
            }
        }

        layer.enabled: !control.filling
        layer.effect: DropShadow
        {
            cached: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 16
            color:  "#80000000"
            smooth: true
        }
    }

    /**
         *
         */
    function positionY()
    {
        if(verticalAlignment === Qt.AlignVCenter)
        {
            return parent.height / 2 - height / 2
        }
        else if(verticalAlignment === Qt.AlignTop)
        {
            return (height + Maui.Style.space.huge)
        }
        else if(verticalAlignment === Qt.AlignBottom)
        {
            return (parent.height) - (height + Maui.Style.space.huge)

        }else
        {
            return parent.height / 2 - height / 2
        }
    }
}
