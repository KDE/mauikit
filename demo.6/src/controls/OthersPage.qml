import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Other Widgets")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {

            Maui.FontPickerDialog
            {
                id: _dialog
            }

            title: "FontPickerDialog"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            Button
            {
                text: "Open"
                onClicked: _dialog.open()
            }
        }

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
                    enableLassoSelection: true

                    onItemsSelected: (indexes) =>
                                     {
                                         for(var i in indexes)
                                         {
                                             var item = ({image: "qrc:/assets/6588168.jpg"})
                                             _selectionBar.append(i, item)
                                         }
                                     }

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

                footer: Maui.SelectionBar
                {
                    id: _selectionBar
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)
                    maxListHeight: root.height - (Maui.Style.contentMargins*2)

                    onExitClicked:
                    {
                        clear()
                    }

                    Action
                    {
                        text: i18n("Open")
                        icon.name: "document-open"
                    }

                    Action
                    {
                        text: i18n("Share")
                        icon.name: "document-share"
                    }

                    Action
                    {
                        text: i18n("Export")
                        icon.name: "document-export"
                    }
                }
            }
        }

    }
}
