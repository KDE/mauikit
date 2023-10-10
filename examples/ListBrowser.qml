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

        Maui.ListBrowser
        {
            anchors.fill: parent
            model: 60

            enableLassoSelection: true
            onItemsSelected: (indexes) => console.log(indexes)

            delegate: Maui.ListBrowserDelegate
            {
                width: ListView.view.width
                label1.text: "An example delegate."
                label2.text: "Using the MauiKit ListBrowser."

                iconSource: "folder"
            }
        }
    }
}

