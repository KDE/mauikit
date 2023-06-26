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
            title: "TextField"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            TextField
            {
                placeholderText: "TextField"
            }
        }

        DemoSection
        {
            title: "SearchField"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            Maui.SearchField
            {
                placeholderText: "SearchField"
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
