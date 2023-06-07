import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root


    Maui.SideBarView
    {
        id: _sidebarView
        anchors.fill: parent
        sideBarContent: Pane
        {
            anchors.fill: parent
            padding: Maui.Style.space.medium
            Maui.Theme.colorSet: Maui.Theme.Window

            //            ScrollView
            //            {
            //                anchors.fill: parent
            //                Flickable
            //                {
            //                    width: parent.width
            //                    contentHeight: _layout.implicitHeight
            //                    ColumnLayout
            //                    {
            //                        id: _layout
            //                        width: parent.width
            //                        spacing: Maui.Style.space.big
            //                        Maui.SectionGroup
            //                        {
            //                            title: i18n ("Core")
            //                            description: i18n("MauiKit Core components")

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Views")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("Page")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("SplitView")

            //                                    }

            //                                }

            //                            }
            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Browsers")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("GridBrowser")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("AltBrowser")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("SidebarView")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("AppViews")

            //                                    }
            //                                }

            //                            }

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Buttons")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("ToolActions")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("ToolButtonMenu")

            //                                    }
            //                                }

            //                            }

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Layouts")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("SectionColumn")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("SectionTemplate")

            //                                    }
            //                                }

            //                            }

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Delegates")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("ListBrowserDelegate")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("GridBrowserDelegate")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("CollageDelegate")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("GalleryRollDelegate")

            //                                    }
            //                                }

            //                            }

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Templates")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("LisItemTemplate")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("GridItemTemplate")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("IconItem")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("CollageItem")

            //                                    }
            //                                }

            //                            }
            //                        }

            //                        Maui.SectionGroup
            //                        {
            //                            title: i18n ("Common")
            //                            description: i18n("Baseline controls")

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Buttons")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("Button")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("ToolButton")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("RadioButton")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("Switch")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("CheckBox")

            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("TabButton")

            //                                    }
            //                                }

            //                            }

            //                            Maui.SectionItem
            //                            {
            //                                Layout.fillWidth: true
            //                                label1.text: i18n("Sliders")
            //                                label2.text: i18n("Adaptive views for contents")

            //                                Column
            //                                {
            //                                    width: parent.parent.width
            //                                    spacing: Maui.Style.space.medium

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("Slider")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("ProgressBar")
            //                                    }

            //                                    Maui.ListDelegate
            //                                    {
            //                                        width: parent.width
            //                                        label: i18n("Range")
            //                                    }
            //                                }
            //                            }

            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Buttons")
            //                            }
            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Text")
            //                            }

            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Input")
            //                            }

            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Bars")
            //                            }

            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Popups")
            //                            }
            //                        }

            //                        Maui.SectionGroup
            //                        {
            //                            title: i18n ("Custom")
            //                            description: i18n("Baseline controls")

            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Bars")
            //                            }
            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Text")
            //                            }

            //                            Maui.ListDelegate
            //                            {
            //                                Layout.fillWidth: true
            //                                label: i18n("Input")
            //                            }
            //                        }
            //                    }
            //                }
            //            }

        }

        Maui.Page
        {
            anchors.fill: parent
            showCSDControls: true

            headBar.leftContent: ToolButton
            {
                icon.name: "sidebar-collapse"
                checked: _sidebarView.sideBar.visible
                onClicked: _sidebarView.sideBar.toggle()
            }

            headBar.rightContent: Maui.ToolButtonMenu
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

            Pane
            {
                anchors.fill: parent
                padding: Maui.Style.space.huge

                contentItem: ColumnLayout
                {
                    Pane
                    {
                        id: _descriptionPane
                        Layout.fillWidth: true

                        background: Rectangle
                        {
                            radius: Maui.Style.radiusV
                            color: Maui.Theme.alternateBackgroundColor
                        }

                        contentItem: Maui.SectionGroup
                        {
                            title: i18n("Control Title")
                            description: i18n("Control description")

                            TextArea
                            {
                                Layout.fillWidth: true
                                text: "import org.mauikit.controls 1.3 as Maui\n Maui.Control {}"
                                font.family: "Monospace"
                                background: Rectangle
                                {
                                    color: Maui.Theme.backgroundColor
                                    radius: Maui.Style.radiusV
                                }
                            }
                        }
                    }

                    Pane
                    {
                        id: _demoPane
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        background: Rectangle
                        {
                            radius: Maui.Style.radiusV
                            color: Maui.Theme.alternateBackgroundColor
                        }

                        contentItem: Item
                        {
                            Maui.Page
                            {
                                anchors.fill: parent

                                headBar.leftContent: Switch
                                {
                                    icon.name: "love"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
