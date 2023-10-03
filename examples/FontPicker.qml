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

        Maui.FontPicker
        {
            height: Math.min(implicitHeight, 800)

            width: Math.min(parent.width, 800)

            anchors.centerIn: parent
        }
    }

}

