import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.3 as Maui

import "private" as Private

/**
 * ToolButtonMenu
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
ToolButton
{
    id: control

    /**
      * content : list<Item>
      */
    default property alias content : _menu.contentData

    /**
      * menu : Menu
      */
    property alias menu : _menu
    
    focusPolicy: Qt.NoFocus
    checked: _menu.visible
    display: ToolButton.IconOnly
    
    onClicked: _menu.open(0, height)    

    Maui.ContextualMenu
    {
        id: _menu
    }
    
    //Component.onCompleted: control.background.showMenuArrow = true    
}
