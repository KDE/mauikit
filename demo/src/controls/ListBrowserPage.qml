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
                    model: 100

                    delegate: Maui.ListBrowserDelegate
                    {
                        width: ListView.view.width
                        label1.text: modelData
                    }
                }
            }
        }
    }
}
