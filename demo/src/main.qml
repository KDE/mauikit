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
        id: _othersPage
        OthersPage {}
    }

    Component
    {
        id: _popupsPage
        PopupsPage {}
    }

    Component
    {
        id: _altBrowserPage
        AltBrowserPage {}
    }

    Component
    {
        id: _imageViewerPage
        ImagePage {}
    }

    Component
    {
        id: _delegatesPage
        DelegatesPage {}
    }

    Component
    {
        id: _tabViewPage
        TabViewPage {}
    }

    Component
    {
        id: _barsPage
        BarsPage {}
    }

    Component
    {
        id: _templatesPage
        TemplatesPage {}
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
        ButtonsPage {}
    }

    Component
    {
        id: _inputsPage
        InputsPage {}
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

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("TabView")
                            onClicked: root.pushPage(_tabViewPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("ImageViewer")
                            onClicked: root.pushPage(_imageViewerPage)
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
                            onClicked: root.pushPage(_altBrowserPage)
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
                            label: i18n("Delegates")
                            onClicked: root.pushPage(_delegatesPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Containers")
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
                            label: i18n("Layouts")
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
                            onClicked: root.pushPage(_barsPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Templates")
                            onClicked: root.pushPage(_templatesPage)
                        }

                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Popups")
                            onClicked: root.pushPage(_popupsPage)
                        }
                        
                        Maui.ListDelegate
                        {
                            Layout.fillWidth: true
                            label: i18n("Other")
                            onClicked: root.pushPage(_othersPage)
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
