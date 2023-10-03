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
        headBar.forceCenterMiddleContent: true

        Flow
        {
            width: 400
            anchors.centerIn: parent
            spacing: Maui.Style.space.big

            Maui.Chip
            {
                text: "Chip1"
                color: "#757575"
                showCloseButton: true
            }

            Maui.Chip
            {
                text: "Chip2"
                icon.name: "actor"
                color: "#03A9F4"
                showCloseButton: true
            }

            Maui.Chip
            {
                text: "Chip3"
                icon.name: "anchor"
                color: "#4CAF50"
                showCloseButton: true
            }

            Maui.Chip
            {
                text: "Chip4"
                color: "#E1BEE7"
            }

            Maui.Chip
            {
                text: "Chip5"
                color: "#FFC107"
            }

            Maui.Chip
            {
                text: "Chip6"
                color: "#607D8B"
            }

            Maui.Chip
            {
                text: "Chip7"
                color: "#FF5722"
                icon.source: "/home/camiloh/Downloads/5911329.jpeg"
            }
        }
    }
}
