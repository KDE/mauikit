import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.SideBarView
    {
        anchors.fill: parent

        sideBarContent: Maui.Page
        {
            Maui.Theme.colorSet: Maui.Theme.Window
            anchors.fill: parent

            headBar.leftContent: Maui.ToolButtonMenu
            {
                icon.name: "application-menu"
                MenuItem
                {
                    text: "About"
                    icon.name: "info-dialog"
                    onTriggered: root.about()
                }
            }

            headBar.rightContent: ToolButton
            {
                icon.name: "love"
            }
        }

        Maui.Page
        {
            anchors.fill: parent
            showCSDControls: true
        }
    }
}
