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

        Button
        {
            anchors.centerIn: parent
            text: "Click me"
            onClicked: _settingsDialog.open()
        }

        Maui.SettingsDialog
        {
            id: _settingsDialog

            Maui.FlexSectionItem
            {
                label1.text: "SSetting Subpage"
                label2.text: "Click me to add a new page"

                ToolButton
                {
                    icon.name: "go-next"
                    checkable: true
                    onToggled: _settingsDialog.addPage(_settingsPage2)
                }
            }

            Maui.SectionGroup
            {
                title: "First Section"

                Maui.FlexSectionItem
                {
                    label1.text: "Configuration title"
                    label2.text: "Description text"

                    Button
                    {
                        text: "Test"
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: "Configuration title"
                    label2.text: "Description text"

                    Switch {}
                }

                Maui.FlexSectionItem
                {
                    label1.text: "Configuration title"
                    label2.text: "Description text"

                    Switch {}
                }
            }

            Maui.SectionGroup
            {
                title: "A Second Section"

                Maui.FlexSectionItem
                {
                    label1.text: "Configuration title"
                    label2.text: "Description text"

                    Switch {}
                }

                Maui.FlexSectionItem
                {
                    label1.text: "Configuration title"
                    label2.text: "Description text"
                    wide: false
                    TextField
                    {
                        Layout.fillWidth: true
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: "Configuration title"
                    label2.text: "Description text"

                    Switch {}
                }
            }

            Component
            {
                id: _settingsPage2

                Maui.SettingsPage
                {
                    title: "Page2"

                    Maui.FlexSectionItem
                    {
                        label1.text: "Configuration title"
                        label2.text: "Description text"

                        Switch {}
                    }
                }
            }
        }
    }
}

