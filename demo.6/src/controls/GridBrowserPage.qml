import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("GridBrowser")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("Grid View")
            body: i18n("Grid view layout with an uniform cell width. This is optional.")

            column: Maui.Page
            {
                Layout.fillWidth: true
                implicitHeight: 500

                headBar.leftContent: Switch
                {
                    checked:  _grid.adaptContent
                    onToggled: _grid.adaptContent = !_grid.adaptContent
                    text: i18n("Adaptive")
                }

                Maui.GridBrowser
                {
                    id: _grid
                    anchors.fill: parent
                    clip: true
                    model: 30

                    itemSize: 160

                    delegate: Item
                    {
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        Maui.GridBrowserDelegate
                        {
                            anchors.fill: parent
                            anchors.margins: Maui.Style.space.small
                            label1.text: modelData
                            iconSource: "folder"
                            imageSource: "qrc:/assets/6588168.jpg"
                        }
                    }
                }
            }
        }
    }
}
