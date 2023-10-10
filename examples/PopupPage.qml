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
        Maui.Theme.colorSet: Maui.Theme.Complementary

        Button
        {
            anchors.centerIn: parent
            text: "PopupPage"
            onClicked: _popupPage.open()
        }

        Maui.PopupPage
        {
            id: _popupPage

            title: "Title"

            persistent: true
            hint: 1
            //            maxWidth: 800

            Rectangle
            {
                implicitHeight: 200
                Layout.fillWidth: true
                color: "purple"
            }

            Rectangle
            {
                implicitHeight: 200
                Layout.fillWidth: true
                color: "orange"
            }

            Rectangle
            {
                implicitHeight: 200
                Layout.fillWidth: true
                color: "yellow"
            }

            actions: [
                Action
                {
                    text: "Action1"
                },

                Action
                {
                    text: "Action2"
                }
            ]
        }
    }
}

