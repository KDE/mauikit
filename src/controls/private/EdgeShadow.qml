/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.15
import QtGraphicalEffects 1.0
import org.mauikit.controls 1.3 as Maui

LinearGradient
{
    id: control
    /**
     * edge: enumeration
     * This property holds the edge of the shadow that will determine
     * the direction of the gradient.
     * The acceptable values are:
     * Qt.TopEdge: The top edge of the content item.
     * Qt.LeftEdge: The left edge of the content item (default).
     * Qt.RightEdge: The right edge of the content item.
     * Qt.BottomEdge: The bottom edge of the content item.
     */
    property int edge: Qt.LeftEdge

    /**
      *
      */
    property color color: Maui.Theme.textColor

    implicitWidth: Maui.Style.units.gridUnit
    implicitHeight: Maui.Style.units.gridUnit   
    
opacity: 0.5
    rotation: edge === Qt.RightEdge ? 180 : 0
    start: Qt.point( 0, height)
    end: Qt.point( width, height)
    
    gradient: Gradient 
    {
        GradientStop 
        {
            position: 0
            color: Qt.rgba(control.color.r, control.color.g, control.color.b, 0.4)
        }
        
        GradientStop
        {
            position: 1
            color:  "transparent"
        }
    }
}

