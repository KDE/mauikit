import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("ImageViewer")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: "Static"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column: Pane
            {
                Layout.fillWidth: true
                implicitHeight: 500

                Maui.ImageViewer
                {
                    anchors.fill: parent
                    clip: true
                    source: "qrc:/assets/6588168.jpg"
                }
            }

        }

        DemoSection
        {
            title: "Animated"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")
            column: Pane
            {
                Layout.fillWidth: true
                implicitHeight: 500

                Maui.ImageViewer
                {
                    anchors.fill: parent
                    source: "qrc:/assets/test.gif"

                }
            }
        }
    }

}
