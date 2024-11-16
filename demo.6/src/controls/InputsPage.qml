import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Inputs")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: "MauiKit TextField"
            body: i18n("Alternative attached properties that can be used within a text field, such as actions, title, subtitle and/or badge indicators.")

            Maui.TextField
            {
                placeholderText: "TextField"
                Maui.Controls.badgeText: "@"
            }

            Maui.TextField
            {
                placeholderText: "TextField"
                actions: [
                Action
                    {
                        icon.name: "love"
                        checkable: true
                    },
                    Action
                        {
                            icon.name: "folder"
                            checkable: true
                        }
                ]
            }

            Maui.TextField
            {
                placeholderText: "TextField"
                Maui.Controls.badgeText: "@"

                actions: [
                Action
                    {
                        icon.name: "love"
                    },
                    Action
                        {
                            icon.name: "folder"
                        }
                ]
            }

            Maui.TextField
            {
                Maui.Controls.title: "Title"
                Maui.Controls.subtitle: "Subtitle information needed"
                placeholderText: "TextField"
            }

            Maui.TextField
            {
                Maui.Controls.title: "Title"
                placeholderText: "TextField"
            }


            Maui.TextField
            {
                Maui.Controls.subtitle: "Subtitle information needed"
                placeholderText: "TextField"
            }

            Maui.TextField
            {
                Maui.Controls.title: "Title"
                Maui.Controls.subtitle: "Subtitle information needed"
                Maui.Controls.status: Maui.Controls.Negative
            }

            Maui.TextField
            {
                Maui.Controls.title: "Title"
                Maui.Controls.subtitle: "Subtitle information needed"
                Maui.Controls.status: Maui.Controls.Positive
            }

            Maui.TextField
            {
                Maui.Controls.title: "Title"
                Maui.Controls.subtitle: "Subtitle information needed"
                Maui.Controls.status: Maui.Controls.Neutral
            }
        }

        DemoSection
        {
            title: "SearchField"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            Maui.SearchField
            {
                placeholderText: "SearchField"
                Maui.Controls.badgeText: text.length > 3 ? "!!" : ""

            }

        }

        DemoSection
        {
            title: "QQC2 TextField"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            TextField
            {
                placeholderText: "QQC2 TextField"
            }
        }

        DemoSection
        {
            title: "PasswordField"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            Maui.PasswordField
            {
                placeholderText: "PasswordField"
            }
        }

        DemoSection
        {
            title: "TextFieldPopup"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column: Maui.TextFieldPopup
            {
                Layout.fillWidth: true
                Layout.minimumWidth: 500
                placeholderText: "PasswordField"
            }
        }

        DemoSection
        {
            title: "TextArea"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column: TextArea
            {
                Layout.fillWidth: true
                implicitHeight: 250
                placeholderText: "Text Area Input..."
            }
        }
    }

    Maui.SectionGroup
    {
        title: i18n("Input Fields")
        spacing: control.spacing

        DemoSection
        {
            title: "Sliders"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column:[

                Slider
                {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 50
                }
            ]
        }

        DemoSection
        {
            title: "ProgressBar"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            column:[
                ProgressBar
                {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 50
                },

                ProgressBar
                {
                    Layout.fillWidth: true
                    indeterminate: true
                    from: 0
                    to: 100
                    value: 50
                }
            ]
        }
    }
}
