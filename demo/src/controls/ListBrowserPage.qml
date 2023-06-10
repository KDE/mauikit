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

                Maui.ListBrowser
                {
                    anchors.fill: parent
                    model: 40
                    clip: true

                    delegate: Maui.ListBrowserDelegate
                    {
                        width: ListView.view.width
                        label1.text: i18n("Title %1", modelData)
                        label2.text: "Subtitle"
                        label3.text: "+300"
                        label4.text: "Info"
                        iconSource: "folder-music"
                    }
                }
            }
        }
    }
}
