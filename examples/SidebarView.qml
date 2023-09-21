import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.SideBarView
    {
        id: _sideBar
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

            Maui.Holder
            {
                anchors.fill: parent
                title: "SideBar"
                body: "Collapsable."
                emoji: "folder"
            }
        }

        Maui.Page
        {
            anchors.fill: parent
            Maui.Controls.showCSD: true

            headBar.leftContent: ToolButton
            {
                icon.name: _sideBar.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                onClicked: _sideBar.sideBar.toggle()
            }

            Maui.Holder
            {
                anchors.fill: parent
                title: "Page"
                body: "Page main content."
                emoji: "application-x-addon-symbolic"
            }
        }
    }
}
