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

                Maui.SectionItem
                {
                    label1.text: "Checkable section item"
                    iconSource: "folder"

                    Switch
                    {
                        onToggled: checked = !checked
                    }
                }

                Maui.SectionItem
                {
                    label1.text: "Single section item"
                    iconSource: "anchor"
                }

                Maui.SectionItem
                {
                    label1.text: "Hello this is a two line section item"
                    label2.text : "Subtitle text"

                    TextArea
                    {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}

