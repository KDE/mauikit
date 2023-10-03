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

        Maui.FloatingButton
        {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Maui.Style.space.big

            icon.name: "list-add"
        }

    }

}

