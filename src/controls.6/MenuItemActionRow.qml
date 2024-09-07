// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.MenuItem
 * @brief A menu item entry for placing a set of actions as the children.
 * The actions will be represented as row of QQC2 ToolButton.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-menuitem.html">This controls inherits from QQC2 MenuItem, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 * This is mean tot be used inside a Menu, where a group of similar actions can be placed together to save vertical sspace and make the UI a bit less cluttered.
 * 
 * @image html Misc/menuitemactionrow.png
 * 
 * @code
 * Maui.ContextualMenu
{
    id: _contextualMenu

    title: "Menu Title"
    titleIconSource: "folder"

    Maui.MenuItemActionRow
    {
        Action
        {
            text: "Action1"
            icon.name: "love"
        }

        Action
        {
            text: "Action2"
            icon.name: "folder"
        }

        Action
        {
            text: "Action3"
            icon.name: "anchor"
        }
    }

    MenuSeparator {}

    MenuItem
    {
        text: "Action3"
        icon.name: "actor"
    }

    MenuItem
    {
        text: "Action4"
        icon.name: "anchor"
    }
}
 * @endcode
 
 @attention When an action here defined has been triggered, then the `triggered` signal fo the actual container -aka MenuItem - will also be emitted. This is done to support the auto-closing of the menu after a menu entry has been triggered.
 */
MenuItem
{
    id: control
    
    /**
     * @brief The list of actions to be represented.
     * The children of this element should be a group of QQC2 Action.
     * @note Checkout Qt documentation on the Action element.
     */
    default property list<Action> actions
    
    opacity: control.enabled ? 1 : 0.5
    
    hoverEnabled: !Maui.Handy.isMobile
    
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    implicitWidth: ListView.view ? ListView.view.width : Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    
    background: null
    
    padding: 0
    spacing: Maui.Style.space.small   
    font: Maui.Style.defaultFont
        
    display : width > Maui.Style.units.gridUnit * 28 && control.actions.length <= 3 ?  ToolButton.TextBesideIcon : (Maui.Handy.isMobile ? ToolButton.TextUnderIcon : ToolButton.IconOnly)
    
    contentItem: Flow
    {
        id: _layout
        spacing: control.spacing
        
        Repeater
        {
            id: _repeater
            model: control.actions
            
            delegate: ToolButton
            {
                id: _delegate
                Maui.Theme.inherit: true
                
                action: modelData
                display: control.display
                
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: ( _delegate.hovered ) && _delegate.text.length
                ToolTip.text: modelData.text
                
                background: Rectangle
                {
                    radius: Maui.Style.radiusV
                    color: _delegate.checked || _delegate.pressed || _delegate.down ? Maui.Theme.highlightColor : _delegate.highlighted || _delegate.hovered ? Maui.Theme.hoverColor : Maui.Theme.alternateBackgroundColor                    
                }
                
                Connections
                {
                    target: _delegate.action
                    ignoreUnknownSignals: true
                    function onTriggered()
                    {
                        control.triggered()
                    }
                }
            }
        }
    }    
}
