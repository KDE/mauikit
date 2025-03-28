import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Popups")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("MauiKit Popup")

            Maui.Popup
            {
                id: _popup1
            }

            Maui.Popup
            {
                id: _popup2
                filling: true

                Button
                {
                    anchors.centerIn: parent
                    text: i18n("Close")
                    onClicked: _popup2.close()
                }
            }

            Button
            {
                text: i18n("Normal")
                onClicked: _popup1.open()
            }


            Button
            {
                text: i18n("Filled")
                onClicked: _popup2.open()
            }
        }

        DemoSection
        {
            title: i18n("PopupPage")

            Maui.PopupPage
            {
                id: _popupPage
                hint: 1

                title: i18n("Title")

                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }
            }
            
            Maui.PopupPage
            {
                id: _popupPagActions
                hint: 1
                
                title: i18n("Title")
                
                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }
                
                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }
                
                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }
                
                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "magenta"
                }
                
                actions: [
                    
                    Action
                    {
                        icon.name: "anchor"
                        text: i18n("Expand")      
                        onTriggered: _popupPagActions.maxWidth = 700
                    },
                    
                    Action
                    {
                        icon.name: "folder"
                        text: i18n("Shrink")
                        onTriggered: _popupPagActions.maxWidth = 300
                        
                    },
                    
                    Action
                    {
                        icon.name: "answer"
                        text: i18n("Action3")
                    },                    
                    
                    Action
                    {
                        Maui.Controls.status: Maui.Controls.Negative
                        icon.name: "answer"
                        text: i18n("Action4")
                    }
                    
                    
                ]
            }

            Button
            {
                text: i18n("Open")
                onClicked: _popupPage.open()
            }

            
            Button
            {
                text: i18n("Popup Actions")
                onClicked: _popupPagActions.open()
            }
        }

        DemoSection
        {
            title: i18n("Dialog")

            Dialog
            {
                id: _dialog
                width: 300
                height: 300

                standardButtons: Dialog.Ok | Dialog.Close
            }

            Dialog
            {
                id: _dialog2
                width: 300
                height: 300

                standardButtons: Dialog.Ok | Dialog.Close | Dialog.Help
            }


            Button
            {
                text: i18n("Open 1")
                onClicked: _dialog.open()
            }

            Button
            {
                text: i18n("Open 2")
                onClicked: _dialog2.open()
            }
        }

        DemoSection
        {
            title: i18n("InfoDialog")

            Maui.InfoDialog
            {
                id: _infoDialog

                title: "Title"
                message: i18n("Info message about some important information fo the end user to act upon.")
                template.iconSource: "dialog-info"
                standardButtons: Dialog.Ok | Dialog.Close
            }


            Button
            {
                text: i18n("Open")
                onClicked: _infoDialog.open()
            }
        }

        DemoSection
        {
            title: i18n("InputDialog")

            Maui.InputDialog
            {
                id: _inputDialog

                title: "Title"
                message: i18n("Info message about some important information fo the end user to act upon.")
                template.iconSource: "dialog-info"
                standardButtons: Dialog.Ok | Dialog.Close

                Rectangle
                {
                    Layout.fillWidth: true
                    implicitHeight: 100
                    color: "blue"
                }

            }


            Button
            {
                text: i18n("Open")
                onClicked: _inputDialog.open()
            }
        }

        DemoSection
        {
            title: i18n("ContextualMenu")

            Maui.ContextualMenu
            {
                id: _menu

                title: "Title"

                Maui.MenuItemActionRow
                {
                    Action
                    {
                        icon.name: "love"
                    }

                    Action
                    {
                        icon.name: "list-add"
                    }

                    Action
                    {
                        icon.name: "view-list-icons"
                    }
                }

                MenuItem
                {
                    text: i18n("Menu 1")
                }

                MenuItem
                {
                    text: i18n("Menu 2")
                }

                MenuItem
                {
                    text: i18n("Menu 3")
                }
            }


            Button
            {
                text: i18n("Open Menu")
                onClicked: _menu.show()
            }
        }

        DemoSection
        {
            title: i18n("SettingsDialog")

            Maui.SettingsDialog
            {
                id: _settings


                Component
                {
                    id: _samplePage2

                    Maui.SettingsPage
                    {
                        title: "Subpage"

                        Maui.SectionGroup
                        {
                            title: i18n("Menu 3")

                            Maui.SectionItem
                            {
                                label1.text: "Sample title"
                                label2.text: "Description"

                                Switch{}
                            }

                            Maui.SectionItem
                            {
                                label1.text: "Sample title"
                                label2.text: "Description"

                                Switch{}
                            }

                            Maui.SectionItem
                            {
                                label1.text: "Sample title"
                                label2.text: "Description"

                                Switch{}
                            }
                        }
                    }
                }

                Maui.SectionGroup
                {
                    title: i18n("Menu 1")

                    Maui.SectionItem
                    {
                        label1.text: "Sample title"
                        label2.text: "Description"

                        Switch{}
                    }

                    Maui.SectionItem
                    {
                        label1.text: "Sample title"
                        label2.text: "Description"

                        Switch{}
                    }

                    Maui.SectionItem
                    {
                        label1.text: "Sample title"
                        label2.text: "Description"

                        Switch{}
                    }
                }

                Maui.SectionGroup
                {
                    title: i18n("Menu 2")

                    Maui.SectionItem
                    {
                        label1.text: "Sample title"
                        label2.text: "Description"

                        ToolButton
                        {
                            checkable: true
                            onToggled: _settings.addPage(_samplePage2)
                            icon.name: "go-next"
                        }
                    }

                    Maui.SectionItem
                    {
                        label1.text: "Sample title"
                        label2.text: "Description"

                        Button{text: "Test"}
                    }

                    Maui.SectionItem
                    {
                        label1.text: "Sample title"
                        label2.text: "Description"

                        TextField
                        {
                            Layout.fillWidth: true
                        }
                    }
                }
            }


            Button
            {
                text: i18n("Open Dialog")
                onClicked: _settings.open()
            }
        }


    }
}
