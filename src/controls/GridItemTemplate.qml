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

import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

/**
 * GridItemTemplate
 * A template with a icon or image and a bottom label..
 *
 *
 *
 *
 *
 *
 */
Item
{
    id: control
    focus: true
    property alias spacing: _layout.spacing
    //property int padding: Maui.Style.space.tiny
    //property int topPadding: padding
    //property int  bottomPadding: padding
    //property int rightPadding: padding
    //property int leftPadding: padding
    
    implicitHeight: _layout.implicitHeight /*+ control.topPadding + control.bottomPadding*/
    
    /**
     * content : data
     */
    default property alias content: _layout.data
        
        /**
         * text1 : string
         */
        property alias text1 : _label1.text
        
        /**
         * label1 : Label
         */
        property alias label1 : _label1
        
        /**
         * label1 : Label
         */
        property alias label2 : _label2
        
        /**
         * iconItem : Item
         */
        property alias iconItem : _iconLoader.item
        
        /**
         * iconItemContainer : Item
         */
        property alias iconContainer : _iconLoader
        
        /**
         * iconVisible : bool
         */
        property alias iconVisible : _iconLoader.visible
        
        /**
         * labelSizeHint : int
         */
        property alias labelSizeHint : _labelsContainer.labelSizeHint
        
        /**
         * iconSizeHint : int
         */
        property int iconSizeHint : Maui.Style.iconSizes.big
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
         * isCurrentItem : bool
         */
        property bool isCurrentItem: false
        
        /**
         * labelsVisible : bool
         */
        property bool labelsVisible: true
        
        /**
         * fillMode : Image.fillMode
         */
        property int fillMode : Image.PreserveAspectCrop
        
        /**
         * maskRadius : int
         */
        property int maskRadius: 0
        
        
        property int imageWidth : -1
        
        property int imageHeight: -1
        
        property bool smooth : false
        
        property bool isMask : iconSizeHint <= Maui.Style.iconSizes.small
        
        property bool hovered: false
        
        property bool autoTransform: false
        
        property bool highlighted: false
        
        property int alignment: Qt.AlignHCenter
        /**
         * iconComponent : Component
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
                //                 Layout.margins: Maui.Style.space.small
                Layout.maximumHeight: control.height* 0.9
                Layout.minimumHeight: labelSizeHint
                
                ColumnLayout
                {
                    id: _labels
                    anchors.fill: parent
                    spacing: 0
                    
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
                
                //Rectangle
                //{
                //visible: (control.hovered ) && _label1.implicitHeight > _label1.height
                //height: Math.max(_labelsContainer.height, Math.min(_label2D.implicitHeight, control.height) + Maui.Style.space.medium)
                //width: parent.width
                //color: Maui.Theme.backgroundColor
                //anchors.bottom: parent.bottom
                //radius: Maui.Style.radiusV
                //clip: true
                
                //Label
                //{
                //id: _label2D
                //horizontalAlignment: Qt.AlignHCenter
                //verticalAlignment: Qt.AlignVCenter
                //text: _label1.text
                //width: parent.width
                //height: implicitHeight
                //anchors.centerIn: parent
                //elide: Qt.ElideRight
                //wrapMode: Text.Wrap
                //font: _label1.font
                //color: _label1.color
                //}
                //}
            }
        }
}
