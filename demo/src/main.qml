import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.mauikit.controls as Maui

import "controls"

Maui.ApplicationWindow
{
    id: root

    property color accentColor : Maui.Style.accentColor

    ColorDialog {
        id: colorDialog
        selectedColor: root.accentColor
        onAccepted: Maui.Style.accentColor = selectedColor
    }

    Component
    {
        id: _listBrowserPage
        ListBrowserPage {}
    }

    Component
    {
        id: _gridBrowserPage
        GridBrowserPage {}
    }

    Component
    {
        id: _sideBarPage
        SideBarViewPage {}
    }

    Component
    {
        id: _appViewsPage
        AppViewsPage {}
    }

    Component
    {
        id: _indicatorsPage
        IndicatorsPage {}
    }

    Component
    {
        id: _buttonsPage
        ButtonsPage
        {
            title: i18n("Buttons")
        }
    }

    Component
    {
        id: _inputsPage
        InputsPage
        {
            title: i18n("Input Fields")
        }
    }

    Component
    {
        id: _pagePage
        MauiPage
        {
            title: i18n("Page")
        }
    }

    Component
    {
        id: _splitPage
        SplitViewPage
        {
            title: i18n("SplitView")
        }
    }

    Maui.SideBarView
    {
        id: _sidebarView
        anchors.fill: parent
        sideBarContent: Pane
        {
            anchors.fill: parent
            padding: 0
            Maui.Theme.colorSet: Maui.Theme.Window

            Maui.ScrollColumn
            {
                id: _layout
                anchors.fill: parent

                Button
                {
                    Layout.fillWidth: true
                    text: i18n("About")
                    onClicked: root.about()
                }

                Maui.SectionGroup
                {
                    title: i18n ("Core")
                    description: i18n("MauiKit Core components")

                    Maui.SectionItem
                    {
                        label1.text: i18n("Views")
                        columns: 1

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Page")
                            onClicked: root.pushPage(_pagePage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("SplitView")
                            onClicked: root.pushPage(_splitPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("SidebarView")
                            onClicked: root.pushPage(_sideBarPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("AppViews")
                            onClicked: root.pushPage(_appViewsPage)
                        }
                    }

                    Maui.SectionItem
                    {
                        label1.text: i18n("Browsers")
                        columns: 1

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("ListBrowser")
                            onClicked: root.pushPage(_listBrowserPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("GridBrowser")
                            onClicked: root.pushPage(_gridBrowserPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("AltBrowser")
                        }
                    }

                    Maui.SectionItem
                    {
                        label1.text: i18n("Layouts")
                        columns: 1

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("SectionColumn")
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("SectionTemplate")
                        }
                    }

                    Maui.SectionItem
                    {
                        label1.text: i18n("Delegates")
                        label2.text: i18n("Adaptive views for contents")
                        columns: 1

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("ListBrowserDelegate")
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("GridBrowserDelegate")

                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("CollageDelegate")

                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("GalleryRollDelegate")
                        }
                    }

                    Maui.SectionItem
                    {
                        Layout.fillWidth: true
                        label1.text: i18n("Templates")
                        label2.text: i18n("Adaptive views for contents")
                        columns: 1


                            Maui.ListDelegate
                            {
                                Layout.fillWidth: true
                                label: i18n("LisItemTemplate")
                            }

                            Maui.ListDelegate
                            {
                                Layout.fillWidth: true
                                label: i18n("GridItemTemplate")

                            }

                            Maui.ListDelegate
                            {
                                Layout.fillWidth: true
                                label: i18n("IconItem")

                            }

                            Maui.ListDelegate
                            {
                                Layout.fillWidth: true
                                label: i18n("CollageItem")

                            }
                        }




                    Maui.SectionItem
                    {
                        label1.text: i18n ("Common")
                        label2.text: i18n("Baseline controls")
                        columns: 1

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Buttons")
                            onClicked: root.pushPage(_buttonsPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Labels")
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Input")
                            onClicked: root.pushPage(_inputsPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Indicators")
                            onClicked: root.pushPage(_indicatorsPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Bars")
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Popups")
                        }
                    }
                }
            }


        }

        Maui.Page
        {
            anchors.fill: parent
            showCSDControls: true
            title: _stackView.currentItem.title

            headBar.leftContent: [
                ToolButton
                {
                    icon.name: _sidebarView.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                    checked: _sidebarView.sideBar.visible
                    onClicked: _sidebarView.sideBar.toggle()
                },

                ToolButton
                {
                    visible: _stackView.depth >= 2
                    icon.name: "go-previous"
                    onClicked: _stackView.pop()
                }

            ]

            headBar.rightContent:[ ToolButton
                {
                    icon.name: "color-management"
                    onClicked: colorDialog.open()
                },

                Maui.ToolButtonMenu
                {
                    icon.name: "contrast"

                    MenuItem
                    {
                        text: i18n("Light")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = Maui.Style.Light
                        checked:  Maui.Style.styleType === Maui.Style.Light
                    }

                    MenuItem
                    {
                        text: i18n("Dark")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = Maui.Style.Dark
                        checked:  Maui.Style.styleType === Maui.Style.Dark

                    }

                    MenuItem
                    {
                        text: i18n("Adaptive")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = Maui.Style.Adaptive
                        checked:  Maui.Style.styleType === Maui.Style.Adaptive

                    }

                    MenuItem
                    {
                        text: i18n("Custom")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = Maui.Style.Auto
                        checked:  Maui.Style.styleType === Maui.Style.Auto

                    }

                    MenuItem
                    {
                        text: i18n("Black")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = Maui.Style.TrueBlack
                        checked:  Maui.Style.styleType === Maui.Style.TrueBlack

                    }

                    MenuItem
                    {
                        text: i18n("White")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = Maui.Style.Inverted
                        checked:  Maui.Style.styleType === Maui.Style.Inverted

                    }

                    MenuItem
                    {
                        text: i18n("System")
                        checkable: true
                        autoExclusive: true
                        onTriggered: Maui.Style.styleType = undefined
                        checked:  Maui.Style.styleType === undefined

                    }
                }
            ]

            StackView
            {
                id: _stackView
                anchors.fill: parent
                padding: Maui.Style.space.huge

                initialItem: Item
                {
                    property string title: i18n("Home")
                    Maui.Holder
                    {
                        anchors.fill: parent
                        emoji: "start-here"
                        isMask: false
                        title: i18n("MauiKit Demo")
                        body: i18n("Welcome to the Maui Demo application. This app serves to demostrate the available controls in MauiKit and also the style and behaviour of the elements. Use it as a reference to discover the power of the MauiKit Controls!")
                    }
                }
            }
        }
    }

    function pushPage(page)
    {
        _stackView.pop()
        _stackView.push(page)
    }

}
