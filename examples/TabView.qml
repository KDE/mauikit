import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.TabView
    {
        id: _tabBar
        anchors.fill: parent
        Maui.Controls.showCSD: true

        onNewTabClicked:
        {
            _tabBar.addTab(_newTabComponent, ({'Maui.TabViewInfo.tabTitle': "New Tab"}))
        }

        Rectangle
        {
            Maui.TabViewInfo.tabTitle: "Tab1"
            Maui.TabViewInfo.tabIcon: "folder"
            color: "blue"
        }

        Rectangle
        {
            Maui.TabViewInfo.tabTitle: "Tab2"
            Maui.TabViewInfo.tabIcon: "folder"
            color: "pink"
        }

        Rectangle
        {
            Maui.TabViewInfo.tabTitle: "Tab3"
            Maui.TabViewInfo.tabIcon: "folder"
            color: "yellow"
        }
    }

    Component
    {
        id: _newTabComponent
        Rectangle
        {
            color: "purple"
        }
    }
}
