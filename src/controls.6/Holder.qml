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

import org.mauikit.controls 1.3 as Maui

/**
 @brief  Holder
 A component meant to be used as a placeholder element with support for a title, message, icon image animated or not, and a set of contextual action buttons.
 */
Item
{
    id: control
    implicitHeight: _layout.implicitHeight

    /**
     * @brief
     */  
    default property list<Action> actions

    /**
     * @brief
     */  
    property alias content : _layout.data

   /**
     * @brief
     */  
    property string emoji

    /**
     * @brief
     */  
    property alias title : _template.text1

   /**
     * @brief
     */  
    property alias body : _template.text2

    /**
     * @brief
     */  
    property bool isMask : true

    /**
     * @brief
     */  
    property bool isGif : false

    /**
     * @brief
     */  
    property int emojiSize : Maui.Style.iconSizes.big

    /**
     * @brief
     */  
    property bool enabled: true

    /**
     * @brief
     */  
    property alias label1 : _template.label1
    
    /**
     * @brief
     */  
    property alias label2 : _template.label2

    /**
     * @brief
     */  
    signal actionTriggered()

    Component
    {
        id: imgComponent

        Maui.Icon
        {
            id: imageHolder

            color: isMask ? Maui.Theme.textColor : "transparent"
            isMask: control.isMask
            opacity: isMask ? _template.opacity : 1
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
        spacing: Maui.Style.defaultSpacing

        Loader
        {
            visible: active
            active: control.height > (_template.implicitHeight + emojiSize) && control.emoji
            height: control.emoji && visible ? emojiSize : 0
            width: height
            asynchronous: true
            sourceComponent: isGif ? animComponent : imgComponent
        }

        Maui.ListItemTemplate
        {
            id: _template
            width: Math.min(control.width * 0.7, layout.implicitWidth)

            label1.font: Maui.Style.h1Font
            label1.wrapMode: Text.Wrap
            label2.wrapMode: Text.Wrap
        }

        Item
        {
            height: Maui.Style.space.medium;
            width: height
        }

        Repeater
        {
            model: control.actions

            Button
            {
                id: _button
                width: Math.max(120, implicitWidth)
                action: modelData
            }
        }
    }
}
