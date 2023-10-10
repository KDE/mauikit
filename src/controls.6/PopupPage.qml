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
import QtQuick.Layouts

import org.mauikit.controls 1.3 as Maui

import Qt5Compat.GraphicalEffects

/**
 * @since org.mauikit.controls 1.0
 * @brief A QQC2 Popup with extra built-in features, such as a snapping surface, scrollable contents, and action buttons.
 * 
 *  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-popup.html">This control inherits from QQC2 Popup, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * @image html Misc/popuppage.png "The image depicts the control a floating VS snapped surface"
 * 
 * @section structure Structure
 * 
 * The inner container is handled by a MauiKit Page, and this can be accessed via the alias property `page` - which means this control can have a header and footer bar, and all the other Page features.
 * @see page
 * 
 * By default the children content is positioned into a MauiKit ScrollColumn, that's scrollable. If it's desired, this can be avoided by placing the children manually, using the property `stack`. This way any other element can be positioned manually using the Layout attached properties.
 * @see stack
 * 
 * @note The `stack` children are positioned using a ColumnLayout.
 *   
 * @section features Features
 * 
 * @subsection snapping Snapping
 * The Popup can snap to the full window area on constrained spaces. To allow this behavior there a few steps to look after, first make `hint: 1`and set `persistent: true`.
 * @ref ScrollColumn#notes Notes
 * @see persistent
 * 
 * @subsection scrollable Scrollable Layout
 * By default the children content of this element will be placed on a MauiKit ScrollColumn, which allows the content to be scrollable/flickable when its implicit height is bigger than the actual popup area.
 * To position the children content use the `implicitHeight` and the Layout attached properties, such as `Layout.fillWidth`.
 * @see content
 * @see ScrollColumn
 * 
 * @subsection actions Action Buttons
 * The regular QQC2 Popup control does not have support for setting standard action buttons like the Dialog controls does; but this control allows it. The action buttons will be styled in the same manner as the Dialog buttons, but the actions here are added differently.
 * To set the actions, use the `actions` property.
 * @see actions
 * 
 * @code
 * Maui.PopupPage
 * {
 *    id: _popupPage
 * 
 *    title: "Title"
 * 
 *    persistent: true
 *    hint: 1
 * 
 *    Rectangle
 *    {
 *        implicitHeight: 200
 *        Layout.fillWidth: true
 *        color: "purple"
 *    }
 * 
 *    Rectangle
 *    {
 *        implicitHeight: 200
 *        Layout.fillWidth: true
 *        color: "orange"
 *    }
 * 
 *    Rectangle
 *    {
 *        implicitHeight: 200
 *        Layout.fillWidth: true
 *        color: "yellow"
 *    }
 * 
 *    actions: [
 *        Action
 *        {
 *            text: "Action1"
 *        },
 * 
 *        Action
 *        {
 *            text: "Action2"
 *        }
 *    ]
 * }
 * @endcode
 * 
 * @section notes Notes
 * Some properties have been obscure by the Maui Style layer. 
 * The style layer adds some extra properties to the Popup control:
 * - `filling : bool` Whether the popup area should be style as if filling the whole window area.
 * - `maxWidth : int` The maximum width the popup area can have. If the window width space becomes smaller then the popup area, then it will be resized to fit. Or if the `hint: 1` then it will snap to fill the whole window area.
 * - `maxHeight : int` The maximum height the popup area can have. If the window height space becomes smaller then the popup area, then it will be resized to fit. Or if the `hint: 1` then it will snap to fill the whole window area.
 * -` hint : double` Determines the resizing final size of the popup area when it reaches the `maxWidth` or `maxHeight` constrains. For example a `1` value means the popup area will be resize to fill the window available space, but a `0.5` value means it will be conserving a margin when resized of 25% at left and right sides.
 * - `heightHint : double` By default this is bind to the `hint` value.
 * - `widthHint : double` By default this is bind to the `hint` value.
 * 
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/PopupPage.qml">You can find a more complete example at this link.</a>
 */
Popup
{
    id: control
    
    focus: true
    
    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false
    
    closePolicy: control.persistent ? Popup.NoAutoClose | Popup.CloseOnEscape : Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    maxWidth: 300
    maxHeight: implicitHeight
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding + topMargin + bottomMargin
    
    hint: 0.9
    heightHint: 0.9
    spacing: Maui.Style.space.big
    
    margins: 0
    
    filling: persistent && mWidth === control.parent.width
    
    /**
     * @brief Default children content will be added to a scrollable ColumnLayout.
     * When adding a item keep on mind that to correctly have the scrollable behavior the item must have an implicit height set. And the positioning should be handled via the Layout attached properties.
     * @property list<Item> PopupPage::scrollable
     */
    default property alias scrollable : _scrollView.content
        
        /**
         * @brief To skip the scrollable behavior there is a stacked component to which items can be added, this is also controlled by a ColumnLayout.
         * @code
         * Maui.PopupPage
         * {
         *  stack: Rectangle
         *  { 
         *      Layout.fillWidth: true
         *      Layout.fillHeight: true
         *      Layout.preferredHeight: 800
         *  }
         * }
         * @endcode
         * @property list<QtObject> PopupPage::stack
         */
        property alias stack : _stack.data
        
        /**
         * @see Page::title
         */
        property alias title : _page.title
        
        /**
         * @brief Whether the dialog should be closed when it loses focus or not.
         * If it is marked as persistent a close button is shown in the header bar, other wise the header bar is  hidden if there is not more elements on it.
         * By default this is set to `true`.
         */
        property bool persistent : true
        
        /**
         * @brief An alias to the MauiKit Page, which is the main container of this control.
         * It is exposed to allow access to the Page properties.
         * @see Page
         * @property Page PopupPage::page
         */
        readonly property alias page : _page
        
        /**
         * @see Page::footBar
         */
        property alias footBar : _page.footBar
        
        /**
         * @see Page::headBar
         */
        property alias headBar: _page.headBar
        
        /**
         * @brief Whether the close button is visible.
         * By default this is bind to the `persistent` value.
         * @see persistent.
         */
        property bool closeButtonVisible: control.persistent
        
        /**
         * @see ScrollColumn::flickable
         */
        readonly property alias flickable : _scrollView.flickable
        
        /**
         * @brief An alias to the MauiKit ScrollColumn handling the scrollable content.
         * @property ScrollView PopupPage::scrollView
         */
        readonly property alias scrollView : _scrollView
        
        /**
         * @brief The policy for the scroll view vertical scroll bar.
         * By default this is set to `ScrollBar.AsNeeded`.
         */
        property int verticalScrollBarPolicy: ScrollBar.AsNeeded        
        
        /**
         * @brief The policy for the scroll view horizontal scroll bar.
         * By default this is set to `ScrollBar.AlwaysOff`.
         */
        property int horizontalScrollBarPolicy: ScrollBar.AlwaysOff
        
        /**
         * @brief Whether the control should be closed automatically after the close button is pressed.
         * If this is set to `false`, then the `closeTriggered` will be emitted instead.
         * This is useful if a conformation action needs to take place before closing the control.
         * By default this is set to `true`.
         */
        property bool autoClose : true
        
        /**
         * @brief List of actions to be added to the bottom section as buttons.
         */
        property list<Action> actions
        
        /**
         * @brief The GridLayout handling the bottom part of action buttons added via the `actions` property.
         * @property GridLayout PopupPage:: actionBar
         */
        readonly property alias actionBar : _defaultButtonsLayout        
        
        /**
         * @brief Emitted when the close button has been clicked and the `autoClose` property has been disabled.
         * @see autoClose
         * @see closeButtonVisible
         */
        signal closeTriggered()
        
        ColumnLayout
        {
            id: _layout
            anchors.fill: parent
            spacing: 0
            
            Maui.Page
            {
                id: _page
                
                clip: true
                
                Maui.Theme.colorSet: control.Maui.Theme.colorSet
                
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                implicitHeight: Math.max(_scrollView.contentHeight + _scrollView.topPadding + _scrollView.bottomPadding, _stack.implicitHeight) + _page.footerContainer.implicitHeight + (_page.topPadding + _page.bottomPadding) + _page.headerContainer.implicitHeight + (_page.topMargin + _page.bottomMargin)
                
                headerPositioning: ListView.InlineHeader
                
                padding: 0
                margins: 0
                
                headBar.visible: control.persistent
                headBar.borderVisible: false
                
                background: null
                
                headBar.farRightContent: Loader
                {
                    asynchronous: true
                    visible: active
                    active: control.persistent && closeButtonVisible
                    
                    sourceComponent: Maui.CloseButton
                    {
                        onClicked:
                        {
                            if(control.autoClose)
                            {
                                control.close()
                            }else
                            {
                                control.closeTriggered()
                            }
                        }
                    }
                }
                
                ColumnLayout
                {
                    id: _stack
                    
                    anchors.fill: parent
                    spacing: control.spacing
                }
                
                Maui.ScrollColumn
                {
                    id: _scrollView
                    
                    anchors.fill: parent
                    
                    visible: _stack.children.length === 0
                    
                    spacing: control.spacing
                    padding: Maui.Style.space.big
                    
                    ScrollBar.horizontal.policy: control.horizontalScrollBarPolicy
                    ScrollBar.vertical.policy: control.verticalScrollBarPolicy
                }
            }
            
            GridLayout
            {
                id: _defaultButtonsLayout
                
                rowSpacing: Maui.Style.space.small
                columnSpacing: Maui.Style.space.small
                
                Layout.fillWidth: true
                Layout.margins: Maui.Style.contentMargins
                
                property bool isWide : control.width > Maui.Style.units.gridUnit*10
                
                visible: control.actions.length
                
                rows: isWide? 1 : _defaultButtonsLayout.children.length
                columns: isWide ? _defaultButtonsLayout.children.length : 1
                
                Repeater
                {
                    model: control.actions
                    
                    Button
                    {
                        id: _actionButton
                        focus: true
                        Layout.fillWidth: true
                        
                        action: modelData
                    }
                }
            }
        }
}
