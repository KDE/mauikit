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

        Maui.PieButton
        {
            Maui.Theme.inherit: false
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Maui.Style.space.big

            icon.name: "list-add"

            Action
            {
                icon.name: "love"
            }

            Action
            {
                icon.name: "folder"
            }

            Action
            {
                icon.name: "anchor"
            }
        }
    }
}

