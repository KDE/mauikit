import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("TabView")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("TabView")
            body: i18n("TabView manages all contents in a swipe view and a created a header with the tab buttons representing each child. You can add items dynamically or declarative. The attached properties to each child item help to give title icon and color to the tab buttons. The tab bar is exposed and any item can be placed using the rightCOntent and leftContent. The tab bar can also be moved to the bottom with the altTab property. An overview can be exposed using the showOverview method. To use a custom tab button delegate you can define the tabButtonComponent, to make it easier you can use the MauiKit TabViewButton.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.TabView
{
    tabBar.leftContent: Switch
    {
        text: i18n("Mobile")
    }

    Rectangle
    {
        Maui.TabViewInfo.tabTitle: "Tab 1"
        color: "pink"
    }

    Rectangle
    {
        Maui.TabViewInfo.tabTitle: "Tab 2"
        Maui.TabViewInfo.tabIcon:  "love"
        color: "blue"
    }
}'
            column: Maui.TabView
            {
                id: _tabView
                Layout.fillWidth: true
                implicitHeight: 600

                tabBar.leftContent: Switch
                {
                    text: i18n("Mobile")
                    checked: _tabView.mobile
                    onToggled: _tabView.mobile = !_tabView.mobile
                }

                Rectangle
                {
                    Maui.TabViewInfo.tabTitle: "Tab 1"
                    color: "pink"
                }

                Rectangle
                {
                    Maui.TabViewInfo.tabTitle: "Tab 2"
                    Maui.TabViewInfo.tabIcon:  "love"
                    color: "blue"
                }

                Rectangle
                {
                    Maui.TabViewInfo.tabTitle: "Tab 3"
                    color: "yellow"
                }
            }
        }
    }
}
