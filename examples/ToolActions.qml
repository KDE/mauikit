import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        id: _page
        anchors.fill: parent

        Maui.Controls.showCSD: true

        Maui.Theme.colorSet: Maui.Theme.Window

        Column
        {
            anchors.centerIn: parent
            spacing: Maui.Style.space.big

            Maui.ToolActions
            {
                checkable: false
                Action
                {
                    icon.name: "go-previous"
                }

                Action
                {
                    icon.name: "go-up"
                }

                Action
                {
                    icon.name: "go-next"
                }
            }

            Maui.ToolActions
            {
                checkable: true
                autoExclusive: false

                Action
                {
                    icon.name: "love"
                    text: checked
                }

                Action
                {
                    icon.name: "anchor"
                    text: checked
                }

                Action
                {
                    icon.name: "folder"
                    text: checked
                }
            }

            Maui.ToolActions
            {
                checkable: true
                autoExclusive: true

                Action
                {
                    text: "Pick"
                }

                Action
                {
                    text: "Only"
                }

                Action
                {
                    text: "One"
                }
            }

            Maui.ToolActions
            {
                expanded: false
                checkable: true
                autoExclusive: true

                Action
                {
                    text: "Pick"
                }

                Action
                {
                    text: "Only"
                }

                Action
                {
                    text: "One"
                }
            }

            Maui.ToolActions
            {
                id: _actions
                checkable: true
                autoExclusive: true
                cyclic: true
                expanded: false

                property int currentAction: 0

                Action
                {
                    id: _action1
                    icon.name: "view-list-details"
                    checked: _actions.currentAction === 0
                    onTriggered:
                    {
                        _actions.currentAction = 0
                    }
                }

                Action
                {
                    id: _action2
                    icon.name: "view-list-icons"
                    checked: _actions.currentAction === 1
                    onTriggered:
                    {
                        _actions.currentAction = 1
                    }
                }
            }
        }

    }
}

