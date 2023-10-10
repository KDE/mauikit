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

        Button
        {
            text: "Open Dialog"
            onClicked: _dialog.open()

            anchors.centerIn: parent
        }

        Maui.InfoDialog
        {
            id: _dialog
            title: "Hello"
            message: "Information about some important action to be reviewed, or just plain information."

            template.iconSource: "dialog-warning"

            standardButtons: Dialog.Close | Dialog.Apply

            onRejected: close()
            onApplied: alert("Are you sure? Alert example.", 2)

            Rectangle //an extra child element
            {
                color: "yellow"
                Layout.fillWidth: true
                implicitHeight: 68
            }
        }
    }
}

