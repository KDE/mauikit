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

        Maui.GridBrowser
        {
            id: _gridBrowser
            anchors.fill: parent
            model: 30

            itemSize: 120
            itemHeight: 120

            adaptContent: true

            delegate: Item
            {
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                Maui.GridBrowserDelegate
                {
                    width: _gridBrowser.itemSize
                    height: width

                    iconSource: "folder"
                    iconSizeHint: Maui.Style.iconSizes.big
                    label1.text: "Title"
                    label2.text: "Message"

                    anchors.centerIn: parent
                }
            }
        }
    }
}

