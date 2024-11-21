import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Button")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: "Buttons"
            body: i18n("Different button states: Regular, Checkable and flat. Can also have different layouts")

            Button
            {
                icon.name: "folder"
                text: "Button 1"
                onClicked: {}
                Maui.Controls.badgeText: "@"
            }

            Button
            {
                icon.name: "folder-music"
                text: "Checkable"
                checkable: true
                checked: true
                onClicked:
                {
                    root.notify("", "", i18n("This is a quick body message regarding"))

                    root.notify("", i18n("Basic #1"))

                    root.notify("dialog-info", i18n("Notification #1"), i18n("This is a body message regarding some inportant information about the application state"))

                    root.notify("dialog-info", i18n("Notification #2"), i18n("This is a body message with a custom action"), [_action1, _action2])

                }

                Action
                {
                    id: _action1
                    text: "Action1"
                    onTriggered:  console.log("Notication action1")
                    Maui.Controls.status: Maui.Controls.Neutral
                }

                Action
                {
                    id: _action2
                    text: "Action2"
                    onTriggered:  console.log("Notication action2")
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

            Button
            {
                Maui.Controls.level: Maui.Controls.Secondary
                icon.name: "folder-downloads"
                text: "Secondary Level"
            }

            Button
            {
                Maui.Controls.status: Maui.Controls.Positive
                icon.name: "folder-downloads"
                text: "Positive"
            }

            Button
            {
                Maui.Controls.status: Maui.Controls.Negative
                icon.name: "folder-downloads"
                text: "Negative"
            }

            Button
            {
                Maui.Controls.status: Maui.Controls.Neutral
                icon.name: "folder-downloads"
                text: "Neutral"
            }

            Button
            {
                Maui.Controls.status: Maui.Controls.Normal
                icon.name: "folder-downloads"
                text: "Normal"
            }

        }

        DemoSection
        {
            title: i18n("ToolButton")
            body: i18n("A common button to be used in tool bars: Regular, Checkable and flat. Can also have different layouts")


            ToolButton
            {
                icon.name: "love"
                Maui.Controls.badgeText: "@"
            }

            ToolButton
            {
                icon.name: "love"
                checkable: true
                checked: true
                text: "Checkable"
                Maui.Controls.badgeText: checked ? "+1" : ""
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
                    onTriggered: console.log("Action1")
                }

                Action
                {
                    icon.name: "love"
                    onTriggered: console.log("Action2")
                    
                }

                Action
                {
                    icon.name: "love"
                    onTriggered: console.log("Action3")                    
                }
            }

            Maui.ToolActions
            {
                expanded: false
                Action
                {
                    icon.name: "love"
                    text: i18n("Hidden1")                    
                }

                Action
                {
                    icon.name: "appointment"
                    text: i18n("Hidden2")
                }

                Action
                {
                    icon.name: "folder"
                    text: i18n("Hidden3")
                }
            }
            
            Maui.ToolActions
            {
                expanded: false
                Action
                {
                    icon.name: "anchor"
                    text: i18n("Hidden1")                    
                }
                
                Action
                {
                    checked: true
                    icon.name: "folder"
                    text: i18n("Hidden2")
                }
                
                Action
                {
                    icon.name: "answer"
                    text: i18n("Hidden3")
                }
            }
                                    
            Maui.ToolActions
            {
                id: _toolActions
                expanded: false
                cyclic: true
                autoExclusive: true
                
                property string currentAction : "ciclyc1"
                Action
                {
                    checkable: true
                    icon.name: "folder"
                    text: "ciclyc1"
                    checked: _toolActions.currentAction === text
                    onTriggered: 
                    {
                        console.log("ciclyc1")
                        _toolActions.currentAction = text
                    }
                }
                
                Action
                {
                    checkable: true
                    text: "ciclyc2"
                    icon.name: "love"
                    checked: _toolActions.currentAction === text
                    
                    onTriggered: 
                    {
                        console.log("ciclyc2")
                        _toolActions.currentAction = text
                    }                    
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

            column: Pane
            {
                implicitHeight: 300
                Layout.fillWidth: true

                Maui.FloatingButton
                {
                    icon.name: "list-add"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: Maui.Style.space.big
                }
            }
        }

        DemoSection
        {
            title: i18n("PieButton")
            body: i18n("MauiKit control for joint action buttons. Can be collapsed and have hidden actions too.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.FloatingButton
{
    icon.name: "list-add"
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: Maui.style.space.big
}'

            column: Pane
            {
                implicitHeight: 300
                Layout.fillWidth: true

                Maui.PieButton
                {
                    icon.name: "go-previous"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: Maui.Style.space.big

                    Action
                    {
                        icon.name: "list-add"
                    }

                    Action
                    {
                        icon.name: "love"
                    }

                    Action
                    {
                        icon.name: "view-list-icons"
                    }
                }
            }
        }
    }
}
