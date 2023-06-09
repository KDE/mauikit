import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("ListBrowser")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("Holder")

            column: Pane
            {
                Layout.fillWidth: true
                implicitHeight: 500

                Maui.GridBrowser
                {
                    anchors.fill: parent
                    clip: true
                    model: 100

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
                        }
                    }
                }
            }
        }
    }
}
