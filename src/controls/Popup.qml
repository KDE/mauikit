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

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami

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
    Maui.Theme.colorSet: Maui.Theme.View
    
    width: (filling ? parent.width  : mWidth) - leftMargin - rightMargin
    height: (filling ? Math.min(parent.height , implicitHeight): mHeight) - topMargin - bottomMargin
    
    //     anchors.centerIn: Overlay.overlay
    
    Behavior on width
    {
        enabled: control.hint === 1
        
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    Behavior on height
    {
        enabled: control.hint === 1
        
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InOutQuad
        }
    }
    
    readonly property int mWidth:  Math.round(Math.min(control.parent.width * widthHint, maxWidth))
    readonly property int mHeight: Math.round(Math.min(control.parent.height * heightHint, maxHeight))
    
    x: filling ? control.leftMargin : Math.round( parent.width / 2 - width / 2 )
    y: filling ? control.parent.height - control.height : Math.round( positionY() )
    
    modal: true
    
    margins:  0
    padding: 1
    
    topPadding: control.padding
    bottomPadding: control.padding + bottomInset
    leftPadding: control.padding
    rightPadding: control.padding
    
    bottomInset: control.filling ? -1 : 0
    
    rightMargin: filling ? Maui.Style.space.medium : control.margins
    leftMargin: filling ? Maui.Style.space.medium : control.margins
    topMargin: filling ? Maui.Style.space.medium : control.margins
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
        
        contentItem:  Item  
        {
            id: _content
            layer.enabled: true
            layer.effect: OpacityMask
            {
                cached: true
                maskSource:  Kirigami.ShadowedRectangle
                {
                    width: _content.width
                    height: _content.height
                    corners
                    {
                        topLeftRadius:  control.filling ? Maui.Style.radiusV : Maui.Style.radiusV
                        topRightRadius:  control.filling ? Maui.Style.radiusV : Maui.Style.radiusV
                        bottomLeftRadius:  control.filling ? 0 :  Maui.Style.radiusV
                        bottomRightRadius: control.filling ? 0 :  Maui.Style.radiusV
                    }   
                }            
            }
        }
        
        
        background: Kirigami.ShadowedRectangle
        {
            color: control.Maui.Theme.backgroundColor
            
            corners
            {
                topLeftRadius:  control.filling ? Maui.Style.radiusV : Maui.Style.radiusV
                topRightRadius:  control.filling ? Maui.Style.radiusV : Maui.Style.radiusV
                bottomLeftRadius:  control.filling ? 0 :  Maui.Style.radiusV
                bottomRightRadius: control.filling ? 0 :  Maui.Style.radiusV
            }     
            
            property color borderColor: Maui.Theme.textColor
            
            border.color:  Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.2)
            border.width: 1
            shadow.xOffset: 0
            shadow.yOffset: 0
            shadow.color: "red"
            shadow.size: 10
            Behavior on color
            {
                Maui.ColorTransition{}
            }
            
            Behavior on border.color
            {
                Maui.ColorTransition{}
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
