import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control

    Maui.SectionGroup
    {
        title: i18n("SplitView")
        spacing: control.spacing

        DemoSection
        {

            title: "Horizontal"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column: Maui.SplitView
            {
                Layout.fillWidth: true
                implicitHeight: 500

                Maui.SplitViewItem
                {
                    Maui.Controls.title: "Blue split view"
                    Maui.Controls.badgeText: "VI"
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "blue"
                    }
                }

                Maui.SplitViewItem
                {
                    Maui.Controls.title: "Blue split view"
                    Maui.Controls.badgeText: "VII"
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "yellow"
                    }
                }
            }
        }

        DemoSection
        {

            title: "Vertical"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column:  Maui.SplitView
            {
                Layout.fillWidth: true
                implicitHeight: 500
                orientation: Qt.Vertical

                Maui.SplitViewItem
                {
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "blue"
                    }
                }

                Maui.SplitViewItem
                {
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "yellow"
                    }
                }
            }
        }
    }
}
