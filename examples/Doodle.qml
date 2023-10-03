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
            text: "Doodle Me!"
            onClicked: _doodle.open()
        }
    }

    Maui.Doodle
    {
        id: _doodle
        sourceItem: _page
    }
}

