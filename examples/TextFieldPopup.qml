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
        Maui.Theme.colorSet: Maui.Theme.Window

        footBar.middleContent: Maui.TextFieldPopup
        {
            position: ToolBar.Footer

            Layout.fillWidth: true
            Layout.maximumWidth: 500
            Layout.alignment: Qt.AlignHCenter

            placeholderText: "Search for Something."

            Maui.Holder
            {
                anchors.fill: parent

                visible: true
                title: "Something Here"
                body: "List whatever in here."
                emoji: "edit-find"
            }
        }
    }
}

