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

        Maui.ScrollColumn
        {
            anchors.fill: parent

            Rectangle
            {
                implicitHeight: 600
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
                implicitHeight: 300
                Layout.fillWidth: true
                color: "yellow"
            }
        }
    }
}

