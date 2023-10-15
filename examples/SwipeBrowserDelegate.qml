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

        Column
        {
            anchors.centerIn: parent

            width: Math.min(parent.width*0.9, 600)

            Maui.SwipeBrowserDelegate
            {
                width: parent.width
                label1.text: "A Title For This"
                label2.text: "Subtitle text with more info"

                quickActions: [
                Action
                    {
                        icon.name: "list-add"
                    },

                    Action
                    {
                        icon.name: "folder-new"
                    },

                    Action
                    {
                        icon.name: "anchor"
                    }
                ]

                actionRow: ToolButton
                {
                    icon.name: "love"
                }
            }
        }
    }
}

