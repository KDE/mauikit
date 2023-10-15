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
        Maui.Theme.colorSet: Maui.Theme.Complementary

        Maui.ScrollColumn
        {
            anchors.centerIn: parent
            width: Math.min(parent.width, 600)
            spacing: Maui.Style.space.big

            Maui.SectionGroup
            {
                title: "Section with Children"
                description: "The description label can be a bit longer explaining something importand. Maybe?"

                Maui.FlexSectionItem
                {
                    label1.text: "Checkable section item"
                    iconSource: "folder"

                    Switch
                    {
                        onToggled: checked = !checked
                    }

                    Button
                    {
                        text: "Example"
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: "Checkable section item"
                    iconSource: "folder"

                    Button
                    {
                        text: "Example"
                        checkable: true
                        onToggled: checked = !checked
                    }
                }
            }
        }
    }
}

