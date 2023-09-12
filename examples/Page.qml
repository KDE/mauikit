import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        id: _page
        anchors.fill: parent
        showCSDControls: true

        headBar.rightContent: Switch
        {
            text: "Alt Header"
            checked: _page.altHeader
            onToggled: _page.altHeader = checked
        }
    }
}
