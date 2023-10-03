import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.AltBrowser
    {
        id: _altBrowser
        anchors.fill: parent

        Maui.Controls.showCSD: true
        viewType: Maui.AltBrowser.ViewType.Grid

        gridView.itemSize: 120

        headBar.leftContent: ToolButton
        {
            icon.name: _altBrowser.viewType === Maui.AltBrowser.ViewType.Grid ? "view-list-details" : "view-list-icons"
            onClicked: _altBrowser.toggle()
        }

        model: 20

        listDelegate: Maui.ListBrowserDelegate
        {
            width:ListView.view.width
            label1.text: index
            label2.text: "Example"
            iconSource: "folder"
        }

        gridDelegate: Maui.GridBrowserDelegate
        {
            height: GridView.view.cellHeight
            width: GridView.view.itemSize

            iconSource: "folder"
            label1.text: index
            label2.text: "Example"
        }
    }
}
