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
            title: i18n("ListBrowser")

            column: Pane
            {
                Layout.fillWidth: true
                implicitHeight: 500

                contentItem: Maui.ListBrowser
                {
                    model: 40
                    clip: true
                    enableLassoSelection: true
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

        DemoSection
        {
            title: i18n("Holder")

            column: Pane
            {
                Layout.fillWidth: true
                implicitHeight: 500
                padding: 100

                background :MouseArea
                {
                    preventStealing: true
                    onClicked: console.log("Fuck")

                    Rectangle
                    {
                        anchors.fill: parent
                        color: "blue"
                    }
                }

                contentItem: ScrollView
                {
                    ListView
                    {
                        model: 400
                        clip: true
                        interactive: false
                        reuseItems: true
                        spacing: Maui.Style.space.big
                        delegate: ItemDelegate
                        {
                            width: ListView.view.width
                            text: "title"

                            icon.name: "folder-music"
                        }
                    }
                }
            }
        }
    }
}
