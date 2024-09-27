import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

import "private" as Private

/**
 * @inherit QtQuick.Controls.ToolButton
 * @since org.mauikit.controls 1.0
 *
 * @brief A control to host into a Menu popup, a set of MenuItem or Actions as its children.
 *
 * This control provides a quick way to have a menu attached to a tool button.
 * All child items will be positioned inside a MauiKit ContextualMenu.
 * @see ContextualMenu
 *
 * @image html Misc/toolbuttonmenu.png
 *
 * @code
 * Maui.ToolButtonMenu
 * {
 *    icon.name: "overflow-menu"
 *
 *    MenuItem
 *    {
 *        text : "Menu1"
 *    }
 *
 *    MenuItem
 *    {
 *        text : "Menu2"
 *    }
 *
 *    MenuItem
 *    {
 *        text : "Menu3"
 *    }
 * }
 * @endcode
 */
ToolButton
{
    id: control
    
    /**
     * @brief List of items, such as MenuItem, or Action, to populate the contextual menu.
     * This is the default property, so all the children will go into the menu.
     * @property list<QtObject> ToolButtonMenu::content
     */
    default property alias content : _menu.contentData

    /**
         *  @brief Alias to the actual menu component holding the menu entries.
         * This can be modified for fine tuning the menu position or look.
         * @property ContextualMenu ToolButtonMenu::menu
         */
    readonly property alias menu : _menu

    indicator: Private.DropDownIndicator
    {
        visible: _menu.count > 0
        item: control
    }

    focusPolicy: Qt.NoFocus
    checked: _menu.visible
    display: ToolButton.IconOnly

    onClicked:
    {
        if(_menu.visible)
        {
            close()
        }else
        {
            open()
        }
    }

    Maui.ContextualMenu
    {
        id: _menu
    }

    /**
         * @brief Forces to open the contextual menu.
         * The menu will be positioned under the button.
         * To open the menu at a position where it has been invoked, use the `popup` function instead.
         * @see popup
         */
    function open()
    {
        _menu.show(0, height + Maui.Style.space.medium)
        _menu.forceActiveFocus()
    }

    /**
         * @brief Forces to popup the contextual menu.
         * This means the menu will be opened and positioned at the event coordinates.
         */
    function popup()
    {
        _menu.popup()
        _menu.forceActiveFocus()
    }

    /**
         * @brief Forces to close the contextual menu.
         */
    function close()
    {
        _menu.close()
    }
}
