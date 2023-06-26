import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Indicators")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("Holder")
            body: i18n("MauiKit control for a place holder message with optional list of actions.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.ToolActions
{
    Maui.Holder
    {
        anchors.fill: parent
        title: i18n("Holder")
        body: i18n("Holder body message with quick info.")
        emoji: "folder"
        isMask: false

        Action
        {
            text: "Action1"
        }

        Action
        {
            text: "Action2"
        }
    }
}'

            column: Pane
            {
                Layout.fillWidth: true
                implicitHeight: 500

                Maui.Holder
                {
                    anchors.fill: parent
                    title: i18n("Holder")
                    body: i18n("Holder body message with quick info.")
                    emoji: "folder"
                    isMask: false

                    Action
                    {
                        text: "Action1"
                    }

                    Action
                    {
                        text: "Action2"
                    }
                }
            }
        }

        DemoSection
        {
            title: i18n("Badge")
            body: i18n("MauiKit control for small indicators to be place on the corner to other controls to indicate a pending state.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.ToolActions
{
    Maui.Badge
    {
        text: "+5"
    }
}'
            Maui.Badge
            {
                text: "+5"
            }

            Maui.Badge
            {
                icon.name: "love"
            }

            Maui.Badge
            {
                text: "longer text"
            }
        }

        DemoSection
        {
            title: i18n("Progress")
            body: i18n("MauiKit control for small indicators to be place on the corner to other controls to indicate a pending state.")

            Maui.ProgressIndicator
            {
            }

            BusyIndicator
            {
                visible: true
            }
        }
    }
}
