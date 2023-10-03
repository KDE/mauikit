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
            anchors.fill: parent
            model: 30

            itemSize: 200

            delegate: Item
            {
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                Maui.CollageItem
                {
                    anchors.fill: parent
                    anchors.margins: Maui.Style.space.small

                    label1.text: "Demo"
                    label2.text: index
                    images: index %2 === 0 ? ['/home/camiloh/Downloads/street-1234360.jpg', '/home/camiloh/Downloads/flat-coated-retriever-1339154.jpg', '/home/camiloh/Downloads/5911329.jpeg'] : ['/home/camiloh/Downloads/street-1234360.jpg', '/home/camiloh/Downloads/flat-coated-retriever-1339154.jpg', '/home/camiloh/Downloads/5911329.jpeg', '/home/camiloh/Pictures/LastLights_by_Mushcube/LastLightsScreenPreview.png']
                }
            }
        }
    }
}

