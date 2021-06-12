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

import org.kde.kirigami 2.14 as Kirigami
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
        property int maskRadius: Maui.Style.radiusV
        
        /**
         * hovered : bool
         */
        property bool hovered: false
        
        /**
         * iconComponent : Component
         */
        property Component iconComponent :  _iconLoader.visible ? _iconComponent : null
        
        Component
        {
            id: _iconComponent
            
            Maui.IconItem
            {
                iconSource: control.iconSource
                imageSource: control.imageSource
                
                highlighted: control.isCurrentItem
                hovered: control.hovered
                
                iconSizeHint: control.iconSizeHint
                
                fillMode: control.fillMode
                maskRadius: control.maskRadius
            }
        }
        
        ColumnLayout
        {
            id: _layout
            anchors.fill: parent
            spacing: 0
            
            Loader
            {
                id: _iconLoader
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 1
                
                asynchronous: true
                sourceComponent: control.iconComponent
                
                Kirigami.Icon
                {
                    visible: _iconLoader.status !== Loader.Ready
                    anchors.centerIn: parent
                    height: Maui.Style.iconSizes.small
                    width: height
                    source:  control.iconSource || "folder-images"
                    isMask: true
                    color: Kirigami.Theme.textColor
                    opacity: 0.5
                }
            }
            
            Kirigami.ShadowedRectangle
            {
                id: _labelsContainer
                property int labelSizeHint: Math.min(64, _labels.implicitHeight)
                visible: control.labelsVisible &&( _label1.text || _label2.text)
                
                Layout.preferredHeight: labelSizeHint
                Layout.margins: 2
                
                Layout.fillWidth: true
                Layout.maximumHeight: control.height* 0.9
                Layout.minimumHeight: labelSizeHint + Maui.Style.space.small
                color: Kirigami.Theme.backgroundColor
                
                corners
                {
                    topLeftRadius: 0
                    topRightRadius: 0
                    bottomLeftRadius: Maui.Style.radiusV
                    bottomRightRadius: Maui.Style.radiusV
                }
                
                ColumnLayout
                {
                    id: _labels
                    anchors.fill: parent
                    anchors.margins: Maui.Style.space.tiny
                    spacing: 0
                    
                    Label
                    {
                        id: _label1
                        visible: text && text.length
                        
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignCenter
                        
                        elide: Qt.ElideRight
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                    }
                    
                    Label
                    {
                        id: _label2
                        visible: text && text.length
                        
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignCenter
                        
                        elide: Qt.ElideRight
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                        opacity: control.isCurrentItem ? 0.8 : 0.6
                        
                    }
                }
                
                Rectangle
                {
                    visible: (control.hovered ) && _label1.implicitHeight > _label1.height
                    height: Math.min(_label2D.implicitHeight, control.height) + Maui.Style.space.medium
                    width: parent.width
                    color: Kirigami.Theme.backgroundColor
                    anchors.bottom: parent.bottom
                    radius: Maui.Style.radiusV
                    clip: true
                    
                    Label
                    {
                        id: _label2D
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        text: _label1.text
                        width: parent.width
                        height: implicitHeight
                        elide: Qt.ElideRight
                        wrapMode: Text.Wrap
                        font: _label1.font
                        color: _label1.color
                    }
                }
            }
        }
}
