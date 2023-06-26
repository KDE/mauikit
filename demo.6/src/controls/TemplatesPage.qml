import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("Templates")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("ListItemTemplate")
            body: i18n("MauiKit control for a place holder message with optional list of actions.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.ListItemTemplate
{
    imageSource: "qrc:/assets/6588168.jpg"
    label1.text: "Title of template"
    label2.text: "Subtitle of the template"
    label3.text: "+info"

    ToolButton
    {
        flat: true
        icon.name: "list-add"
    }
}'
            column: [Maui.ListItemTemplate
                {
                    Layout.fillWidth: true

                    imageSource: "qrc:/assets/6588168.jpg"
                    label1.text: "Title of template"
                    label2.text: "Subtitle of the template"
                    label3.text: "+info"

                    ToolButton
                    {
                        flat: true
                        icon.name: "list-add"
                    }
                },

                Maui.ListItemTemplate
                {
                    Layout.fillWidth: true

                    iconSource: "folder-pink"
                    label1.text: "Title of template"
                    label2.text: "Subtitle of the template"
                    label3.text: "+info"
                },

                Maui.ListItemTemplate
                {
                    Layout.fillWidth: true

                    imageSource: "qrc:/assets/6588168.jpg"
                    headerSizeHint: 64
                    maskRadius: Maui.Style.radiusV
                    label1.text: "Title of template"
                    label2.text: "Subtitle of the template"
                    label3.text: "+info"

                    ToolButton
                    {
                        flat: true
                        icon.name: "list-add"
                    }
                }
            ]
        }

        DemoSection
        {
            title: i18n("GridItemTemplate")
            body: i18n("MauiKit control for a place holder message with optional list of actions.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.GridItemTemplate
{
    height: 200
    imageSource: "qrc:/assets/6588168.jpg"
    label1.text: "Title of template"
    label2.text: "Subtitle of the template"
}
'
            Maui.GridItemTemplate
            {
                implicitHeight: 200
                implicitWidth: 200
                imageSource: "qrc:/assets/6588168.jpg"
                label1.text: "Title of template"
                label2.text: "Subtitle of the template"
            }

            Maui.GridItemTemplate
            {
                implicitHeight: 200
                implicitWidth: 200
                maskRadius: 40
                alignment: Qt.AlignLeft
                imageSource: "qrc:/assets/6919759.jpg"
                label1.text: "Title of template"
                label2.text: "Subtitle of the template"
            }

            Maui.GridItemTemplate
            {
                implicitHeight: 200
                implicitWidth: 200
                alignment: Qt.AlignLeft
                iconSource: "folder-green"
                iconSizeHint: Maui.Style.iconSizes.big
                label1.text: "Title of template"
                label2.text: "Subtitle of the template"
            }
        }

        DemoSection
        {
            title: i18n("IconItem")
            body: i18n("MauiKit control for a place holder message with optional list of actions.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.IconItem
{
    imageSource:  "qrc:/assets/6588168.jpg"
    imageSizeHint: 200
    maskRadius: Maui.Style.radiusV
    fillMode: Image.PreserveAspectCrop
}
'
            Maui.IconItem
            {
                imageSource:  "qrc:/assets/6588168.jpg"
                imageSizeHint: 200
                fillMode: Image.PreserveAspectFit
            }

            Maui.IconItem
            {
                imageSource:  "qrc:/assets/6919759.jpg"
                imageSizeHint: 200
                maskRadius: Maui.Style.radiusV
                fillMode: Image.PreserveAspectCrop
            }

            Maui.IconItem
            {
                iconSource: "folder-pink"
                iconSizeHint: Maui.Style.iconSizes.huge
                isMask: false
            }
        }

        DemoSection
        {
            title: i18n("GalleryRollTemplate")
            body: i18n("MauiKit control for a place holder message with optional list of actions.")
            sampleText: 'import org.mauikit.controls as Maui
Maui.IconItem
{
    imageSource:  "qrc:/assets/6588168.jpg"
    imageSizeHint: 200
    maskRadius: Maui.Style.radiusV
    fillMode: Image.PreserveAspectCrop
}
'
            Maui.GalleryRollTemplate
            {
                implicitHeight: 120
                implicitWidth: 120

                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg"]
            }

            Maui.GalleryRollTemplate
            {
                implicitHeight: 120
                implicitWidth: 120
                radius: Maui.Style.radiusV
                images: ["qrc:/assets/6588168.jpg", "qrc:/assets/6628908.jpg", "qrc:/assets/6919759.jpg"]
            }
        }
    }
}
