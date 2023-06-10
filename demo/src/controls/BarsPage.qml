import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Bars")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("ToolBar")
            body: i18n("MauiKit ToolBar is split into five sections: farLeftContent, leftContent, middleContent, rightContent and farRightContent. The content is flickable when there is not enought space to fit them all. Also the window can be dragged from the toolbar itself.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.ToolBar
{
    Layout.fillWidth: true
    position: ToolBar.Header

    leftContent: [
        ToolButton
        {
            icon.name: "love"
        },

        ToolButton
        {
            icon.name: "love"
        }
    ]

    middleContent: Maui.SearchField
    {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: 500
    }

    rightContent: [
        ToolButton
        {
            icon.name: "love"
        },

        ToolButton
        {
            icon.name: "love"
        }
    ]
}'
            column: Maui.ToolBar
            {
                Layout.fillWidth: true
                position: ToolBar.Header

                leftContent: [
                    ToolButton
                    {
                        icon.name: "love"
                    },

                    ToolButton
                    {
                        icon.name: "love"
                    },

                    ToolButton
                    {
                        icon.name: "love"
                    },

                    ToolButton
                    {
                        icon.name: "love"
                    }
                ]

                middleContent: Maui.SearchField
                {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: 500
                }

                rightContent: [
                    ToolButton
                    {
                        icon.name: "love"
                    },

                    ToolButton
                    {
                        icon.name: "love"
                    },

                    ToolButton
                    {
                        icon.name: "love"
                    },

                    ToolButton
                    {
                        icon.name: "love"
                    }
                ]
            }
        }

        DemoSection
        {
            title: i18n("QQC ToolBar")
            body: i18n("QQC control places child items in a row layout.")

            column: ToolBar
            {
                Layout.fillWidth: true

                ToolButton
                {
                    icon.name: "love"
                }
            }

        }

        DemoSection
        {
            title: i18n("TabBar")
            body: i18n("MauiKit TabBar is split into three sections: leftContent, main content, and rightContent. The content becomes flickable when there is not enought space to fit them all. Also the window can be dragged from the bar itself. This allows to use tab bars as merged toolbars.")

            sampleText: 'import org.mauikit.controls as Maui
Maui.TabBar
{
    Layout.fillWidth: true

    leftContent: ToolButton
    {
        icon.name: "overflow-menu"
    }

    rightContent: ToolButton
    {
        icon.name: "folder-new"
    }

    Maui.TabButton
    {
        text: i18n("Tab 1")
        width: implicitWidth
    }
}'
            column: Maui.TabBar
            {
                Layout.fillWidth: true

                leftContent: ToolButton
                {
                    icon.name: "overflow-menu"
                }

                rightContent: ToolButton
                {
                    icon.name: "folder-new"
                }

                Maui.TabButton
                {
                    text: i18n("Tab 1")
                    width: implicitWidth
                }

                Maui.TabButton
                {
                    text: i18n("Tab 2")
                    width: implicitWidth
                }

                Maui.TabButton
                {
                    text: i18n("Tab 3")
                    width: implicitWidth
                }

                Maui.TabButton
                {
                    text: i18n("Tab 4")
                    width: implicitWidth
                }
            }
        }

        DemoSection
        {
            title: i18n("QQC TabBar")
            body: i18n("MauiKit control for a place holder message with optional list of actions.")

            column: TabBar
            {
                Layout.fillWidth: true

                TabButton
                {
                    text: i18n("Tab 1")
                }

                TabButton
                {
                    text: i18n("Tab 2")
                }

                TabButton
                {
                    text: i18n("Tab 3")
                }

                TabButton
                {
                    text: i18n("Tab 4")
                }
            }
        }
    }
}
