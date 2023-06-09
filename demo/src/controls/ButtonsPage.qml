import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control

    Maui.SectionGroup
    {
        title: i18n("Button")
        spacing: control.spacing

        DemoSection
        {
            title: "Buttons"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            Button
            {
                icon.name: "folder"
                text: "Button 1"
                onClicked:
                {
                    //                    _dialogLoader.sourceComponent = _dialogComponent

                    _dialog.open()
                    //                    var obj =  _dialogComponent.createObject(window)
                    //                    obj.open()
                }
            }

            Button
            {
                icon.name: "folder-music"
                text: "Checkable"
                checkable: true
                checked: true
                onClicked:
                {
                    root.notify("dialog-info", i18n("Notification #1"), i18n("This is a body message regarding some inportant information about the application state"))

                    root.notify("dialog-info", i18n("Notification #2"), i18n("This is a body message with a custom action"), ()=> { console.log("Notication action") }, i18n("Action"))

                }
            }

            Button
            {
                icon.name: "downloads"
                text: "Flat"
                flat: true
            }

            Button
            {
                display: Button.TextUnderIcon
                icon.name: "folder-downloads"
                text: "Hello"
            }

        }

        DemoSection
        {
            title: i18n("ToolButton")
            body: i18n("A common button to be used in tool bars: Regular, Checkable and flat. Can also have different layouts")


            ToolButton
            {
                icon.name: "love"
            }

            ToolButton
            {
                icon.name: "love"
                checkable: true
                checked: true
                text: "Checkable"

            }

            ToolButton
            {
                icon.name: "love"
                display: ToolButton.TextUnderIcon
                text: "Mini"
            }

        }


        DemoSection
        {
            title: i18n("ToolActions")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.ToolActions
{
    Action
    {
        icon.name: "love"
    }

    Action
    {
        icon.name: "love"
    }

    Action
    {
        icon.name: "love"
    }
}'
            Maui.ToolActions
            {
                Action
                {
                    icon.name: "love"
                }

                Action
                {
                    icon.name: "love"
                }

                Action
                {
                    icon.name: "love"
                }
            }

            Maui.ToolActions
            {
                expanded: false
                Action
                {
                    icon.name: "love"
                }

                Action
                {
                    icon.name: "love"
                }

                Action
                {
                    icon.name: "love"
                    text: i18n("Hidden")
                }
            }
        }

        DemoSection
        {
            title: i18n("ToolButtonMenu")
            body: i18n("A ToolButton to host menu entries. Menu entries can be defined as Actions or MenuEntries.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.ToolButtonMenu
{
    icon.name: "overflow-menu"

    MenuItem
    {
        icon.name: "love"
        text: "Menu 1"
    }

    MenuItem
    {
        icon.name: "love"
        text: "Menu 2"
    }

    MenuItem
    {
        icon.name: "love"
        text: "Menu 3"
    }
}'

            Maui.ToolButtonMenu
            {
                icon.name: "overflow-menu"
                text: "Menu"

                MenuItem
                {
                    text: "test"
                }
            }
        }

        DemoSection
        {
            title: i18n("SpinBox")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")
            SpinBox
            {
                from: 0
                to: 10
            }
        }

        DemoSection
        {
            title: i18n("CloseButton")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.CloseButton
{
}'
            Maui.CloseButton {}
        }

        DemoSection
        {
            title: i18n("ColorsRow")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.ColorsRow
{
    colors: ["blue", "pink", "yellow", "magenta"]
}'

            Maui.ColorsRow
            {
                colors: ["blue", "pink", "yellow", "magenta"]
            }
        }

        DemoSection
        {
            title: i18n("Chip")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.Chip
{
    colors: "pink"
    icon.name: "love"
    text: "Chip"
}'

            Maui.Chip
            {
                text: "A chip"
                icon.name: "folder-gitlab"
            }

            Maui.Chip
            {
                text: "A chip"
                icon.name: "folder-gitlab"
                color: "pink"
            }

            Maui.Chip
            {
                text: "A chip"
                icon.name: "folder-gitlab"
                color: "orange"
            }

        }



        DemoSection
        {
            title: i18n("Switch")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            Switch
            {
                text: "Switch"
                icon.name: "contrast"
            }
        }

        DemoSection
        {
            title: i18n("Switch")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            Switch
            {
                text: "Switch"
                icon.name: "contrast"
            }

            Switch
            {
                icon.name: "anchor"
            }

            Switch
            {
                checked: true
            }
        }

        DemoSection
        {
            title: i18n("Checkbox")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            CheckBox
            {
                text: "CheckBox"
            }

            CheckBox
            {
                autoExclusive: true
                text: "Autoexclusive"
            }

            CheckBox
            {
                icon.name: "anchor"
                text: "CheckBox"
            }
        }


        DemoSection
        {
            title: i18n("RadioButton")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")

            RadioButton
            {
                text: "RadioButton"
            }
        }

        DemoSection
        {
            title: i18n("FloatingButton")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.FloatingButton
{
    icon.name: "list-add"
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: Maui.style.space.big
}'

            Pane
            {
                implicitHeight: 500
                implicitWidth: 500

                Maui.FloatingButton
                {
                    icon.name: "list-add"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: Maui.Style.space.big
                }

            }
        }
    }




}
