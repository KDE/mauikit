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
 * @inherit QtQuick.Item
 *    @brief  Holder
 *    A component meant to be used as a placeholder element with support for a title, message body, icon image - animated or not -, and a set of contextual actions.
 * 
 *    <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 *    This control is meant to display messages, such as warning messages with a title and icon, and with a set of possible actions.
 *    The default content children of this component are QQC2 Actions.
 * 
 *    @image html Holder/holder_actions.png "Placeholder message using a colorful icon image"
 * 
 *    @section notes Notes
 *    By default the icon is supossed to be symbolic and will be colored - if a colorful icon is to be used, the coloring mask should toggle off.
 *    @see isMask
 *    @see emoji
 * 
 *    It is possible to add an animated image source as the icon. To enable the animation toggle on the animation property.
 *    @see isGif
 * 
 *    @code
 *    Holder
 *    {
 *        title: "Holder"
 *        body: "Placeholder message."
 * 
 *        emoji: "dialog-warning"
 *        isMask: false
 * 
 *        QQC2.Action
 *        {
 *            text: "Action1"
 *        }
 * 
 *        QQC2.Action
 *        {
 *            text: "Action2"
 *        }
 * 
 *        QQC2.Action
 *        {
 *            text: "Action3"
 *        }
 *    }
 *    @endcode
 * 
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/Holder.qml">You can find a more complete example at this link.</a>
 * 
 */
Item
{
    id: control
    implicitHeight: _layout.implicitHeight
    
    /**
     * @brief A list of contextual actions. By default this control takes a list of QQC2 Actions as the children.
     * The actions will be represented as a column of button under the title and message.
     */  
    default property list<Action> actions
    
    /**
     * @brief An alias to add children elements to the bottom of the default layout container.
     * @property list<QtObject> Holder::content
     * 
     * @code
     * Holder
     * {
     *  title: "Example"
     *  emoji: "actor"
     *  body: "Test of the holder"
     * 
     *  content: Chip
     *  {   
     *      text: "Hello World!"
     *  }
     * }
     * @endcode
     */  
    property alias content : _layout.data
    
    /**
     * @brief The icon source to be used as the heading.
     */  
    property string emoji
    
    /**
     * @brief The image to be used as the heading.
     */
    property string imageSource
    
    /**
     * @brief The title of the place holder element.
     * @property string Holder::title
     */  
    property alias title : _template.text1
    
    /**
     * @brief The body message of the place holder element.
     * @property string Holder::body
     */  
    property alias body : _template.text2
    
    /**
     * @brief Whether the image/icon should be masked and tinted with the text color. If the `emoji` is set to a colorful source, then this should be set to `false`.
     */  
    property bool isMask : true
    
    /**
     * @brief Whether the `emoji` source is an animated image file.
     * By default this is set to `false`.
     */  
    property bool isGif : false
    
    /**
     * @brief The size of the icon/image used as the emoji.
     * By default this value is set to `Style.iconSizes.big`.
     */  
    property int emojiSize : Maui.Style.iconSizes.big
    
    /**
     * @brief The Label element used as the title.
     * This is exposed so the title label properties can be tweaked, such as making the font bolder, lighter or changing its color or size.
     * @property Label Holder::label1
     * @see title
     */  
    property alias label1 : _template.label1
    
    /**
     * @brief The Label element used as the message body.
     * This is exposed so the body message label properties can be tweaked, such as making the font bolder, lighter or changing its color or size.
     * @property Label Holder::label2
     * @see body
     */  
    property alias label2 : _template.label2
    
    Component
    {
        id: imgComponent
        
        Maui.IconItem
        {
            id: imageHolder
            
            isMask: control.isMask
            opacity: isMask ? _template.opacity : 1
            iconSource: control.emoji
            imageSource: control.imageSource
            fillMode: Image.PreserveAspectFit
        }
    }
    
    Component
    {
        id: animComponent
        AnimatedImage
        {
            id: animation
            source: control.emoji
        }
    }
    
    Column
    {
        id: _layout
        anchors.centerIn: parent
        spacing: Maui.Style.defaultSpacing
        
        Loader
        {
            visible: active && (control.emoji || control.imageSource)
            active: control.height > (_template.implicitHeight + control.emojiSize)
            height: visible ? control.emojiSize : 0
            width: height
            asynchronous: true
            sourceComponent: control.isGif ? animComponent : imgComponent
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
