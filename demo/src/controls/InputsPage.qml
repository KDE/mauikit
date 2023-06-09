import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control

    Maui.SectionGroup
    {
        title: i18n("Input Fields")
        spacing: control.spacing
    }

    DemoSection
    {
        title: "Buttons"
        body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

        TextField
        {
            placeholderText: "TextField"
        }
    }

    DemoSection
    {
        title: "Buttons"
        body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")


        Maui.SearchField
        {
            placeholderText: "SearchField"
        }

    }

    DemoSection
    {
        title: "Buttons"
        body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

        Maui.PasswordField
        {
            placeholderText: "PasswordField"
        }
    }

    DemoSection
    {
        title: "Buttons"
        body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

        column: TextArea
        {
            Layout.fillWidth: true
            implicitHeight: 250
            placeholderText: "Text Area Input..."
        }
    }

    DemoSection
    {
        title: "Buttons"
        body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

    }
}
