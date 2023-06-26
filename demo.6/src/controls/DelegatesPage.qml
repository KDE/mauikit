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
            title: i18n("GridBrowserDelegate")
            body: i18n("This prototype uses a column layout to place an icon or image, above two lines of text. It uses the GridItemTemplate as base, adn adds the features such as checkable, draggable. Meant to be used with the GridBrowser or GridView.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.GridBrowserDelegate
{
    implicitWidth: 200
    implicitHeight: 200

    checkable: true
    checked: true

    imageSource: "qrc:/assets/6588168.jpg"
    label1.text: i18n("Title")
    label2.text: i18n("Info")
}'
            Maui.GridBrowserDelegate
            {
                implicitWidth: 200
                implicitHeight: 200

                checkable: true
                checked: true

                imageSource: "qrc:/assets/6588168.jpg"
                label1.text: i18n("Title")
                label2.text: i18n("Info")
            }

            Maui.GridBrowserDelegate
            {
                implicitWidth: 200
                implicitHeight: 200

                draggable: true
                imageSource: "qrc:/assets/6588168.jpg"
                label1.text: i18n("Draggable")
                label2.text: i18n("Info")
            }
        }


        DemoSection
        {
            title: i18n("ListBrowserDelegate")
            body: i18n("This prototype uses a column layout to place an icon or image, above two lines of text. It uses the GridItemTemplate as base, adn adds the features such as checkable, draggable. Meant to be used with the GridBrowser or GridView.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.ListBrowserDelegate
{
    Layout.fillWidth: true
    label1.text: "Title"
    label2.text: "Subtitle"
    iconSource: "folder-green"
    iconSizeHint: Maui.Style.iconSizes.medium
    checkable: true
    checked: true
}'

            column: [

                Maui.ListBrowserDelegate
                {
                    Layout.fillWidth: true
                    label1.text: "Title"
                    label2.text: "Subtitle"
                    iconSource: "folder-green"
                    iconSizeHint: Maui.Style.iconSizes.medium
                    checkable: true
                    checked: true
                },

                Maui.ListBrowserDelegate
                {
                    Layout.fillWidth: true
                    label1.text: "Draggable"
                    label2.text: "Subtitle"
                    imageSource: "qrc:/assets/6919759.jpg"
                    template.headerSizeHint: 64
                    draggable: true
                }

            ]
        }

        DemoSection
        {
            title: i18n("CollageItem")
            body: i18n("This prototype uses a column layout to place an icon or image, above two lines of text. It uses the GridItemTemplate as base, adn adds the features such as checkable, draggable. Meant to be used with the GridBrowser or GridView.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.CollageItem
{
    implicitHeight: 200
    implicitWidth: 200
    images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg"]
    label1.text: "Title"
    checkable: true
    checked: true
}'

            Maui.CollageItem
            {
                implicitHeight: 200
                implicitWidth: 200
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg"]
                label1.text: "Title"
                checkable: true
                checked: true
            }

            Maui.CollageItem
            {
                implicitHeight: 200
                implicitWidth: 200
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6919759.jpg"]
                label1.text: "Title"
            }

            Maui.CollageItem
            {
                implicitHeight: 200
                implicitWidth: 200
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg", "qrc:/assets/6628908.jpg"]
                label1.text: "Title"
            }
        }

        DemoSection
        {
            title: i18n("GalleryRollItem")
            body: i18n("This prototype uses a column layout to place an icon or image, above two lines of text. It uses the GridItemTemplate as base, adn adds the features such as checkable, draggable. Meant to be used with the GridBrowser or GridView.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.CollageItem
{
    implicitHeight: 200
    implicitWidth: 200
    images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg"]
    label1.text: "Title"
    checkable: true
    checked: true
}'

            Maui.GalleryRollItem
            {
                implicitHeight: 200
                implicitWidth: 200
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg"]
                label1.text: "Title"
                checkable: true
                checked: true
            }

            Maui.GalleryRollItem
            {
                implicitHeight: 200
                implicitWidth: 200
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6919759.jpg"]
                label1.text: "Title"
                orientation: ListView.Vertical
            }

            Maui.GalleryRollItem
            {
                implicitHeight: 200
                implicitWidth: 200
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg", "qrc:/assets/6628908.jpg"]
                label1.text: "Title"
            }
        }
    }

    DemoSection
    {
        title: i18n("SwipeBrowserDelegate")
        body: i18n("This prototype uses a column layout to place an icon or image, above two lines of text. It uses the GridItemTemplate as base, adn adds the features such as checkable, draggable. Meant to be used with the GridBrowser or GridView.")
        sampleText: 'import org.mauikit.controls as Maui
Maui.ListBrowserDelegate
{
Layout.fillWidth: true
label1.text: "Title"
label2.text: "Subtitle"
iconSource: "folder-green"
iconSizeHint: Maui.Style.iconSizes.medium
checkable: true
checked: true
}'

        column: [


            Maui.SwipeBrowserDelegate
            {
                Layout.fillWidth: true
                label1.text: "Title"
                label2.text: "Subtitle"
                iconSource: "folder-green"
                iconSizeHint: Maui.Style.iconSizes.medium

                quickActions: [
                    Action
                    {
                        icon.name: "love"
                    },

                    Action
                    {
                        icon.name: "love"
                    }
                ]
            },

            Maui.SwipeBrowserDelegate
            {
                Layout.fillWidth: true
                label1.text: "Title"
                label2.text: "Subtitle"
                iconSource: "folder-green"
                iconSizeHint: Maui.Style.iconSizes.medium
                collapse: true
                quickActions: [
                    Action
                    {
                        icon.name: "love"
                    },

                    Action
                    {
                        icon.name: "love"
                    }
                ]
            },


            Maui.SwipeBrowserDelegate
            {
                Layout.fillWidth: true
                label1.text: "Draggable"
                label2.text: "Subtitle"
                imageSource: "qrc:/assets/6919759.jpg"
                template.headerSizeHint: 64
                draggable: true

                quickActions: Action
                {
                    icon.name: "love"
                }

                Button
                {
                    text: "Test"
                }
            }

        ]
    }

}
