import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.AppViews
    {
        id: _page
        anchors.fill: parent
        Maui.Controls.showCSD: true
        headBar.forceCenterMiddleContent: true

       Rectangle
       {
           Maui.AppView.title: "View1"
           Maui.AppView.iconName: "love"

           color: "blue"
       }

       Rectangle
       {
           Maui.AppView.title: "View2"
           Maui.AppView.iconName: "folder"
           Maui.AppView.badgeText: "30"
           color: "pink"
       }

       Rectangle
       {
           Maui.AppView.title: "View3"
           Maui.AppView.iconName: "tag"

           color: "blue"
       }
    }
}
