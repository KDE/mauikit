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

        headBar.leftContent: Switch
        {
            text: "Adapt Content"
            checked: _gridBrowser.adaptContent
            onToggled: _gridBrowser.adaptContent = !_gridBrowser.adaptContent
        }

        Maui.GridBrowser
        {
            id: _gridBrowser
            anchors.fill: parent
            model: 30

            itemSize: 200
            itemHeight: 200
            cellHeight: 300

            adaptContent: true

            delegate: Rectangle
            {
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                color: "gray"
                border.color: "white"

                Rectangle
                {
                    width: _gridBrowser.itemSize
                    height: _gridBrowser.itemSize

                    color: "yellow"

                    anchors.centerIn: parent
                }
            }
        }
    }
}

