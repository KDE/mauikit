import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("AltBrowser")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: "Buttons"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column: Maui.AltBrowser
            {
                id: _browser
                Layout.fillWidth: true
                implicitHeight: 500
                model: 40
                clip: true
                gridView.itemSize: 160

                headBar.leftContent: Maui.ToolActions
                {
                   autoExclusive: true
                   expanded: true

                   Action
                   {
                       icon.name: "view-list-icons"
                       checked: _browser.viewType === Maui.AltBrowser.ViewType.Grid
                       onTriggered:  _browser.viewType = Maui.AltBrowser.ViewType.Grid
                   }


                   Action
                   {
                       icon.name: "view-list-details"
                       checked: _browser.viewType === Maui.AltBrowser.ViewType.List
                       onTriggered:  _browser.viewType = Maui.AltBrowser.ViewType.List
                   }
                }

                listDelegate: Maui.ListBrowserDelegate
                {
                    width: ListView.view.width
                    label1.text: i18n("Title %1", modelData)
                    label2.text: "Subtitle"
                    label3.text: "+300"
                    label4.text: "Info"
                    imageSource: "qrc:/assets/6588168.jpg"
                }

                gridDelegate: Item
                {
                    width: GridView.view.cellWidth
                    height: GridView.view.cellHeight
                    Maui.GridBrowserDelegate
                    {
                        anchors.fill: parent
                        anchors.margins: Maui.Style.space.small
                        label1.text: i18n("Title %1", modelData)
                        label2.text: "Subtitle"
                        imageSource: "qrc:/assets/6588168.jpg"
                    }
                }
            }
        }
    }
}
