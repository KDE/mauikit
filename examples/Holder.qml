import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        anchors.fill: parent

        Maui.Controls.showCSD: true

        Maui.Holder
        {
            anchors.fill: parent

            title: "Holder"
            body: "Placeholder message."

            emoji: "dialog-warning"
            isMask: false

            Action
            {
                text: "Action1"
            }

            Action
            {
                text: "Action2"
            }

            Action
            {
                text: "Action3"
            }
        }
    }
}
