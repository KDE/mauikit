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

import org.mauikit.controls as Maui

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
    property alias title : _template.text1

    /**
   * body : string
   */
    property alias body : _template.text2

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

    property alias label1 : _template.label1
    property alias label2 : _template.label2

    /**
   * actionTriggered :
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
