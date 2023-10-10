import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.PageLayout
    {
        id: _page

        anchors.fill: parent
        Maui.Controls.showCSD: true

        split: width < 600
        leftContent: [Switch
            {
                text: "Hello"
            },

            Button
            {
                text: "Button"
            }
        ]

        rightContent: Rectangle
        {
            height: 40
            implicitWidth: 60
            color: "gray"
        }

        middleContent: Rectangle
        {
            implicitHeight: 40
            implicitWidth: 60
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: _page.split
            color: "yellow"
        }
    }
}

