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
import QtQuick.Templates 2.15 as T

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

/**
 * Holder
 * A global sidebar for the application window that can be collapsed.
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
    implicitHeight: _layout.implicitHeight
    
    default property list<Action> actions
    
    property alias content : _layout.data

    /**
      * emoji : string
      */
    property string emoji

    /**
      * title : string
      */
    property alias title : _label1.text

    /**
      * body : string
      */
    property alias body : _label2.text

    /**
      * isMask : bool
      */
    property bool isMask : true

    /**
      * isGif : bool
      */
    property bool isGif : false

    /**
      * emojiSize : int
      */
    property int emojiSize : Maui.Style.iconSizes.big

    /**
      * enabled : bool
      */
    property bool enabled: true
    
    property alias label1 : _label1
    property alias label2 : _label2
    
    /**
      * actionTriggered :
      */
    signal actionTriggered()

    Component
    {
        id: imgComponent

        Kirigami.Icon
        {
            id: imageHolder

            color: _label1.color
            isMask: control.isMask
            opacity: isMask ? _label1.opacity : 1
            source: emoji
        }
    }

    Component
    {
        id: animComponent
        AnimatedImage
        {
            id: animation;
            source: emoji
        }
    }
    
    Column
    {
        id: _layout
        anchors.centerIn: parent
        spacing: Maui.Style.space.medium
        
        Loader
        {
            visible: active
            active: control.height > (_label1.implicitHeight + _label2.implicitHeight + emojiSize) && control.emoji
            height: control.emoji && visible ? emojiSize : 0
            width: height
            asynchronous: true
            sourceComponent: isGif ? animComponent : imgComponent
        }
/*
        Item
        {
            width: height
            height: Maui.Style.space.medium
        }
        */
        Label
        {
            id: _label1
            width: Math.min(control.width * 0.7, implicitWidth)
            opacity: 0.7
            
            font.pointSize: Maui.Style.fontSizes.enormous* 1.2            
            font.bold: true
            font.weight: Font.Bold
            elide: Text.ElideRight
            color: Kirigami.Theme.textColor
            wrapMode: Text.Wrap
        }
        
        Label
        {
            id: _label2
            width: Math.min(control.width * 0.7, implicitWidth)
            opacity: 0.5
            elide: Text.ElideRight
            color: Kirigami.Theme.textColor
            wrapMode: Text.Wrap
        }
        
            
        Repeater
        {
            model: control.actions
            
            T.Button
            {
                id: _button
                implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth) +leftPadding + rightPadding
                implicitHeight: background.implicitHeight+ topPadding + bottomPadding 
                
                leftPadding: Maui.Style.space.medium
                rightPadding: leftPadding
                topPadding: 0
                bottomPadding: 0
                
                flat: true
                action: modelData
                
                background: Rectangle
                {
                    implicitWidth:  (Maui.Style.iconSizes.medium * 3) + Maui.Style.space.big
                    implicitHeight: Maui.Style.rowHeight

                    radius: Maui.Style.radiusV
                    color: _button.hovered || _button.down || _button.pressed ? "#26c6da" : Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9)) 
                }
                
                contentItem: Label
                {
                    text: _button.text
                    opacity: 0.8
                    color:  _button.hovered || _button.down || _button.pressed ?  "#fafafa" : Kirigami.Theme.textColor
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }
    }
}
