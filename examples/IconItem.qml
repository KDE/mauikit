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

        title: "IconItem"

        Row
        {
            anchors.centerIn: parent
            spacing: Maui.Style.space.big

            Maui.IconItem
            {
                imageSource: "file:///home/camiloh/Downloads/premium_photo-1664203068007-52240d0ca48f.avif"
                imageSizeHint: 200
                maskRadius: 100
                fillMode: Image.PreserveAspectCrop

            }

            Maui.IconItem
            {
                iconSource: "vvave"
                iconSizeHint: 94
            }
        }
    }
}

