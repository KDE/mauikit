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
        headBar.forceCenterMiddleContent: true

        Column
        {
            width: 400
            anchors.centerIn: parent
            spacing: Maui.Style.space.big

            Maui.ColorsRow
            {
                id: _colorsRow
                width: parent.width

                currentColor: "#CBFF8C"
                defaultColor : "#CBFF8C"

                colors: ["#E3E36A", "#CBFF8C", "#C16200", "#881600", "#6A3937", "#706563", "#748386", "#157A6E", "#77B28C", "#36311F"]

                onColorPicked: (color) =>
                               {
                                   currentColor = color
                               }
            }

            Rectangle
            {
                radius: 10
                height: 400
                width: parent.width
                color: _colorsRow.currentColor
            }
        }
    }
}

