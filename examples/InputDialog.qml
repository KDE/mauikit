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

        Maui.InputDialog
        {
            id: _dialog
            title: "Hello"
            message: "An input dialog that request some information ot be entered."

            template.iconSource: "dialog-question"
            textEntry.placeholderText: "Give me a name."

            onRejected: close()
            onFinished: (text) => console.log(text)
        }
    }
}

