import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true

        Button
        {
            anchors.centerIn: parent
            text: "Font Picker"
            onClicked: _fontPickerDialog.open()
        }

        Maui.FontPickerDialog
        {
            id: _fontPickerDialog
        }
    }

}

