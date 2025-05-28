/*
 *   Copyright 2023 Camilo Higuita <milo.h@aol.com>
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
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Window

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.AbstractButton
 * @brief A TextField control with an attached popup surface.
 * 
 * @image html Misc/textfieldpopup.gif
 * 
 * This control groups a text field box and a popup page together - the popup surface can be used to display any data content that might be related to the text field input.
 * 
 * The text field control is handled by a QQC2 TextField control, which is exposed as `textField`, and the popup surface is hanlded by a QQC2 Popup control, also exposed as an alias `popup`. With those alias you can fine tune the properties of said controls.
 * @see textField
 * @see popup
 * 
 * @code
 * Maui.Page
 * {
 *    anchors.fill: parent
 * 
 *    Maui.Controls.showCSD: true
 *    Maui.Theme.colorSet: Maui.Theme.Window
 * 
 *    footBar.middleContent: Maui.TextFieldPopup
 *    {
 *        position: ToolBar.Footer
 * 
 *        Layout.fillWidth: true
 *        Layout.maximumWidth: 500
 *        Layout.alignment: Qt.AlignHCenter
 * 
 *        placeholderText: "Search for Something."
 * 
 *        Maui.Holder
 *        {
 *            anchors.fill: parent
 * 
 *            visible: true
 *            title: "Something Here"
 *            body: "List whatever in here."
 *            emoji: "edit-find"
 *        }
 *    }
 * }
 * @endcode
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/TextFieldPopup.qml">You can find a more complete example at this link.</a>
 */
AbstractButton
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    property int minimumWidth: 400
    property int minimumHeight: 500
    
    implicitWidth: 200
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    
    hoverEnabled: true
    
    /**
     * @brief The children elements are placed inside the popup surface. The elements have to be positioned manually.
     * The popup surface is open once the text field bar is focused.
     * @property list<QtObject> TextFieldPopup::content
     */
    default property alias content: _page.content
        
        /**
         * @brief An alias to the QQC2 control handling the popup surface.
         * Exposed to access its properties. See Qt documentation on the Popup control.
         * @property Popup TextFieldPopup::popup
         */
        readonly property alias popup: _popup
        
        /**
         * @brief An alias to the TextField control handling the text field box.
         * Exposed to access its properties. See Qt documentation on the TextField control.
         * @property TextField TextFieldPopup::popup
         */
        readonly property alias textField : _textField
        
        /**
         * @brief Whether the popup surface is currently visible
         * @property bool TextFieldPopup::popupVisible
         */
        readonly property alias popupVisible: _popup.visible
        
        /**
         * @brief The Popup close policy.
         * by default this is set to ` Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent`
         * @property enum TextFieldPopup::closePolicy
         */
        property alias closePolicy: _popup.closePolicy
        
        /**
         * @brief The position of the control. This will make the popup go in either of the picked position: top or bottom.
         * By default this is set to `ToolBar.Header`
         * Possible values are:
         * - ToolBar.Header
         * - ToolBar.Footer 
         */
        property int position: ToolBar.Header
        
        /**
         * @brief The text to be used as the placeholder in the text field box.
         * @property string TextFieldPopup::placeholderText
         */
        property alias placeholderText: _textField.placeholderText
        
        /**
         * @brief The input method hints for the text field.
         * refer to the Qt TextField documentation for further information.
         * @property enum TextFieldPopup::inputMethodHints
         */
        property alias inputMethodHints: _textField.inputMethodHints
        
        /**
         * @brief Whether the text field box gets focused on pressed.
         * By default this is set to `true`
         * @property bool TextFieldPopup::activeFocusOnPress
         */
        property alias activeFocusOnPress: _textField.activeFocusOnPress
        
        /**
         * @brief The wrap mode for the text in the text field box.
         * By default this is set to `Text.NoWrap`.
         * @property enum TextFieldPopup::wrapMode
         */
        property alias wrapMode :_textField.wrapMode
        
        /**
         * @brief The color fo the text in the text field.
         * @property color TextFieldPopup::color
         */
        property alias color: _textField.color
        
        /**
         * @brief The vertical alignment of the text in the text field box.
         * By default his is set to `Qt.AlignVCenter`
         * @property enum TextFieldPopup::verticalAlignment
         */
        property alias verticalAlignment: _textField.verticalAlignment
                
        onClicked:
        {
            _popup.open()
        }
        
        text: _textField.text
        icon.name: "edit-find"
        
        Keys.onEscapePressed: control.close()
        
        /**
         * @brief Emitted when the text entered has been accepted, either by pressing Enter, or manually accepted.
         */
        signal accepted()
        
        /**
         * @brief Emitted when the text in the text field box has been cleared using the clear button or clear action.
         */
        signal cleared()
        
        /**
         * @brief Emitted when the popup surface has been activated and is visible.
         */
        signal opened()
        
        /**
         * @brief Emitted when the popup surfaced has been dismissed.
         */
        signal closed()
        
        /**
         * @brief Forces to open the popup surface.
         */
        function open()
        {
            _popup.open()
        }
        
        /**
         * @brief Forces to close the popup surface.
         */
        function close()
        {
            _popup.close()
        }
        
        /**
         * @brief Forces to clear the text in the text field box.
         */
        function clear()
        {
            _textField.clear()
        }
        
        padding: Maui.Style.defaultPadding
        spacing: Maui.Style.space.small
        
        contentItem: Item
        {
            RowLayout
            {
                id: _layout
                anchors.fill: parent
                spacing: control.spacing
                
                Maui.Icon
                {
                    visible: source ? true : false
                    source: control.icon.name
                    implicitHeight: visible ? 16 : 0
                    implicitWidth: height
                    color: control.color
                }
                
                Item
                {
                    Layout.fillWidth: true
                    visible: !placeholder.visible
                }
                
                Label
                {
                    id: placeholder
                    Layout.fillWidth: true
                    text: control.text.length > 0 ? control.text : control.placeholderText
                    font: control.font
                    color: control.color
                    verticalAlignment: control.verticalAlignment
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                    
                    opacity: control.text.length > 0  ? 1 : 0.5
                    
                    Behavior on opacity
                    {
                        NumberAnimation
                        {
                            duration: Maui.Style.units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
            
            Loader
            {
                asynchronous: true
                anchors.fill: parent
                sourceComponent: DropArea
                {
                    onDropped: (drop) =>
                    {
                        if (drop.hasText)
                        {
                            control.text += drop.text
                            
                        }else if(drop.hasUrls)
                        {
                            control.text = drop.urls
                        }
                    }
                }
            }            
        }
        
        data: Maui.Popup
        {
            id: _popup
            
            parent: control
            
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            modal: false
            
            y: control.position === ToolBar.Header ? 0 : (0 - (height) + control.height)
            x: width === control.width ? 0 : 0 - ((width - control.width)/2)
            
            width: Math.min(Math.max(control.minimumWidth, parent.width), control.Window.window.width - Maui.Style.defaultPadding*2)
            height: Math.min(control.Window.window.height- Maui.Style.defaultPadding*2, control.minimumHeight)
            
            anchors.centerIn: undefined
            
            margins: 0
            padding: 0
            
            onClosed:
            {
                //            _textField.clear()
                control.closed()
            }
            
            onOpened:
            {
                _textField.forceActiveFocus()
                _textField.selectAll()
                control.opened()
            }
            
            Maui.Page
            {
                id:_page
                anchors.fill: parent
                altHeader: control.position === ToolBar.Footer
                
                headBar.visible: false
                headerColumn: Maui.TextField
                {
                    implicitHeight: control.height
                    width: parent.width
                    
                    id: _textField
                    text: control.text
                    
                    icon.source: control.icon.name
                    
                    onTextChanged: control.text = text
                    onAccepted:
                    {
                        control.text = text
                        control.accepted()
                    }
                    
                    onCleared:
                    {
                        control.cleared()
                    }
                    
                    Keys.enabled: true
                    Keys.forwardTo: control
                    Keys.onEscapePressed: control.close()
                    
                    background: Rectangle
                    {
                        color: Maui.Theme.backgroundColor
                        
                        
                        Maui.Separator
                        {
                            id: _border
                            anchors.left: parent.left
                            anchors.right: parent.right
                            weight: Maui.Separator.Weight.Light
                            opacity: 0.4
                            
                            Behavior on color
                            {
                                Maui.ColorTransition{}
                            }
                        }
                        
                        states: [  State
                        {
                            when: control.position === ToolBar.Header
                            
                            AnchorChanges
                            {
                                target: _border
                                anchors.top: undefined
                                anchors.bottom: parent.bottom
                            }
                        },
                        
                        State
                        {
                            when: control.position === ToolBar.Footer
                            
                            AnchorChanges
                            {
                                target: _border
                                anchors.top: parent.top
                                anchors.bottom: undefined
                            }
                        }
                        ]
                    }
                }
            }
            
            background: Rectangle
            {
                color: Maui.Theme.backgroundColor
                
                radius: Maui.Style.radiusV
                layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
                layer.effect: MultiEffect
                {
                    autoPaddingEnabled: true
                    shadowEnabled: true
                    shadowColor: "#80000000"
                }
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }
            }
        }
        
        background: Rectangle
        {
            color: control.enabled ? (control.hovered ? Maui.Theme.hoverColor :  Maui.Theme.backgroundColor) : "transparent"
            
            radius: Maui.Style.radiusV
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }
        
        /**
         * @brief Force the focus to go on the text field box and open up the popup surface.
         */
        function forceActiveFocus()
        {
            control.open()            
        }
}
