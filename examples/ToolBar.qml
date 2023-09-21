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

        footBar.forceCenterMiddleContent: true
        footBar.farLeftContent: ToolButton
        {
            icon.name: "love"
        }

        footBar.leftContent: ToolButton
        {
            icon.name: "folder"
        }

        footBar.middleContent: ToolButton
        {
            icon.name: "folder-music"
            Layout.alignment: Qt.AlignHCenter
        }

        footBar.rightContent: ToolButton
        {
            icon.name: "download"
        }

        footBar.farRightContent: ToolButton
        {
            icon.name: "application-menu"
        }

        Maui.Holder
        {
            anchors.fill: parent
            title: "Page"
            body: "Page main content."
            emoji: "application-x-addon-symbolic"
        }
    }
}
