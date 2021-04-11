import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

import "private" as Private

/*!
\since org.kde.mauikit 1.0
\inqmlmodule org.kde.mauikit
\brief A tool button that triggers a contextual menu.

This provides a quick way to have a menu attached to a tool button.
All child items will be positioned in a menu.
*/
ToolButton
{
    id: control

    /*!
      \qmlproperty list<QtObject> ToolButtonMenu::content
      List of items, such as MenuItems to populate the contextual menu.
      This is the default property, so declaring the menu entries is straight forward.
    */
    default property alias content : _menu.contentData

    /*!
      \qmlproperty Menu ToolButtonMenu::menu

      Alias to the actual menu component holding the menu entries.
      This can be modified for fine tuning the menu position or look.
    */
    property alias menu : _menu
    
    focusPolicy: Qt.NoFocus
    checked: _menu.visible
    display: ToolButton.IconOnly
    
    onClicked: _menu.open(0, height + Maui.Style.space.medium)

    Maui.ContextualMenu
    {
        id: _menu
    }
    
    //Component.onCompleted: control.background.showMenuArrow = true    
}
