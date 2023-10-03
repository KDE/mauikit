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
        headBar.forceCenterMiddleContent: true

        Column
        {
            anchors.centerIn: parent
            width: parent.width

            Maui.FlexListItem
            {
                id: _flexItem
                width: parent.width
                label1.text: "Flex List Item"
                label2.text: "This item is reposnive and will split into a column on a narrow space."
                iconSource: "love"

                Rectangle
                {
                    color: "purple"
                    radius: 4
                    implicitHeight: 64
                    implicitWidth: 140
                    Layout.fillWidth: !_flexItem.wide
                    Layout.minimumWidth: 140
                }

                Rectangle
                {
                    color: "yellow"
                    radius: 4
                    implicitHeight: 64
                    implicitWidth: 80
                    Layout.fillWidth: !_flexItem.wide
                }
            }
        }
    }

}

