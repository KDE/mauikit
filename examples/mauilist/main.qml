import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

import org.maui.demo as Demo

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        id: _page
        anchors.fill: parent
        Maui.Controls.showCSD: true
        headBar.forceCenterMiddleContent: true

        Maui.ListBrowser
        {
            anchors.fill: parent
            model: Maui.BaseModel
            {
                list: Demo.PlantsList
                {

                }
            }

            delegate: Maui.ListBrowserDelegate
            {
                width: ListView.view.width
                label1.text: model.title
                label2.text: model.category
            }
        }
    }
}

