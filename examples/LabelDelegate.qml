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

        Column
        {
            width: Math.min(600, parent.width)
            anchors.centerIn: parent

            Maui.LabelDelegate
            {
                width: parent.width
                text: "Hola!"
                icon.name: "love"
            }

            Maui.LabelDelegate
            {
                width: parent.width
                text: "Section Header"
                icon.name: "anchor"
                isSection: true
            }


            Maui.LabelDelegate
            {
                width: parent.width
                text: "Regular label thingy."
            }

            Maui.LabelDelegate
            {
                width: parent.width
                text: "Hola!"
                icon.name: "folder"
            }
        }
    }
}

