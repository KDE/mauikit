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

        title: "IconLabel"

        ColumnLayout
        {
            anchors.centerIn: parent
            spacing: Maui.Style.space.big

            Maui.IconLabel
            {
                icon: ({name: "folder", height: "22", width: "22", color: "yellow"})
                text: "Testing"
                display: ToolButton.TextBesideIcon
                alignment: Qt.AlignLeft
                color: "yellow"
            }

            Maui.IconLabel
            {
                icon: ({name: "vvave", height: "64", width: "64"})
                text: "Vvave"
                display: ToolButton.TextUnderIcon
                alignment: Qt.AlignHCenter
            }
        }
    }
}

