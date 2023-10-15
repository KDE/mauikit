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

        headBar.leftContent: Maui.ToolButtonMenu
        {
            icon.name: "overflow-menu"

            MenuItem
            {
                text : "Menu1"
            }

            MenuItem
            {
                text : "Menu2"
            }

            MenuItem
            {
                text : "Menu3"
            }
        }
    }
}

