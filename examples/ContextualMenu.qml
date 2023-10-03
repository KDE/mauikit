import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        id: _page

        anchors.fill: parent
        Maui.Controls.showCSD: true
        Maui.Theme.colorSet: Maui.Theme.Window
        headBar.forceCenterMiddleContent: true

        Button
        {
            anchors.centerIn: parent
            text: "Click Me!"
            onClicked: _contextualMenu.show()

            Maui.ContextualMenu
            {
                id: _contextualMenu

                title: "Menu Title"
                titleIconSource: "folder"

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
        }
    }
}

