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

        Maui.SplitView
        {
            anchors.fill: parent

            Maui.SplitViewItem
            {
                Rectangle
                {
                    color: "orange"
                    anchors.fill: parent
                }
            }

            Maui.SplitViewItem
            {
                Rectangle
                {
                    color: "yellow"
                    anchors.fill: parent
                }
            }
        }
    }
}

