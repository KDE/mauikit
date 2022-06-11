
/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12

import org.kde.kirigami 2.8 as Kirigami
import org.mauikit.controls 1.2 as Maui

Maui.Dialog
{
    id: control
    //     implicitHeight: 200 + defaultButtonsLayout.height
    defaultButtons: false
    persistent: false
    widthHint: 0.9
    heightHint: 0.8
spacing: Maui.Style.space.medium
    //     scrollView.padding: 0

    maxWidth: 360
    maxHeight: implicitHeight

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary
    
    //     verticalScrollBarPolicy: ScrollBar.AlwaysOff

    /**
         * mainHeader : AlternateListItem
         */
    property alias mainHeader : _header
    //         defaultButtonsLayout.visible: flickable.atYEnd
    actions: [
        Action
        {
            icon.name: "link"
            text: i18n("Site")
            onTriggered: Qt.openUrlExternally(Maui.App.about.homepage)
        },
        
        Action
        {
            icon.name: "love"
            text: i18n("Donate")
            onTriggered: Qt.openUrlExternally(Maui.App.donationPage)
        },
        
        Action
        {
            icon.name: "documentinfo"
            text: i18n("Report")
            onTriggered: Qt.openUrlExternally(Maui.App.about.bugAddress)
        }
    ]

    //     background: Rectangle
    //     {
    //         color: "red"
    //     }

    Item
    {
        id: _header
        Layout.fillWidth: true
        implicitHeight: _div1.implicitHeight + Maui.Style.space.huge

        Maui.ListItemTemplate
        {
            id: _div1
            width: parent.width
            anchors.centerIn: parent

            iconSource: Maui.App.iconName

            fillMode: Image.PreserveAspectFit
            iconSizeHint: Maui.Style.iconSizes.huge
            imageSizeHint: iconSizeHint
            headerSizeHint: iconSizeHint + Maui.Style.space.huge
            isMask: false

            spacing: Maui.Style.space.big
            label1.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            label1.text: Maui.App.about.displayName
            label1.font.weight: Font.Bold
            label1.font.bold: true
            label1.font.pointSize: Maui.Style.fontSizes.enormous * 1.5

            label2.text: Maui.App.about.shortDescription
            label2.font.pointSize: Maui.Style.fontSizes.big
            label2.elide: Text.ElideRight
            label2.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            leftLabels.spacing: Maui.Style.space.medium
            leftLabels.data: [
                
                TextArea
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    text:   Maui.App.about.version + " " + Maui.App.about.otherText
                    font.family: "Monospace"
                    opacity: 0.6
                    font.pointSize: Maui.Style.fontSizes.small
                }
                
            ]
        }

    }

    Maui.Separator
    {
        Layout.fillWidth: true
    }
    
    Maui.AlternateListItem
    {
        implicitHeight: _credits.implicitHeight + Maui.Style.space.huge
        Layout.fillWidth: true

        Column
        {
            id: _credits
            spacing: Maui.Style.space.big
            width: parent.width
            anchors.centerIn: parent

            Repeater
            {
                model: Maui.App.about.authors

                Maui.ListItemTemplate
                {
                    id: _credits
                    iconSource: "view-media-artist"

                    iconSizeHint: Maui.Style.iconSizes.medium
                    headerSizeHint: iconSizeHint + Maui.Style.space.medium

                    width: parent.width
                    spacing: Maui.Style.space.medium
                    label1.text: modelData.name
                    label2.text: String("<a href='mailto:%1'>%1</a>").arg(modelData.emailAddress)
                    label3.text: modelData.task
                    isMask: true

                    Connections
                    {
                        target: _credits.label2
                        function onLinkActivated(link)
                        {
                            Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }
    }

    Maui.AlternateListItem
    {
        implicitHeight: _licenses.implicitHeight + Maui.Style.space.huge
        Layout.fillWidth: true

        Column
        {
            id: _licenses
            spacing: Maui.Style.space.big
            width: parent.width
            anchors.centerIn: parent

            Repeater
            {
                model: Maui.App.about.licenses
                Maui.ListItemTemplate
                {
                    iconSource: "license"
                    width: parent.width
                    isMask: true

                    iconSizeHint: Maui.Style.iconSizes.medium
                    headerSizeHint: iconSizeHint + Maui.Style.space.medium

                    spacing: Maui.Style.space.medium
                    label1.text: modelData.name
                }
            }
        }
    }

    Maui.AlternateListItem
    {
        Layout.fillWidth: true

        implicitHeight: _poweredBy.implicitHeight + Maui.Style.space.huge

        Maui.ListItemTemplate
        {
            id: _poweredBy
            anchors.centerIn: parent
            width: parent.width
            isMask: true

            iconSource: "code-context"
            iconSizeHint: Maui.Style.iconSizes.medium
            headerSizeHint: iconSizeHint + Maui.Style.space.medium

            spacing: Maui.Style.space.medium
            label1.text: i18n("Powered by")
            label2.text: "MauiKit Frameworks " + Maui.App.mauikitVersion
            Connections
            {
                target: _poweredBy.label2
                function onLinkActivated(link)
                {
                    Qt.openUrlExternally(link)
                }
            }
        }

    }

    Maui.AlternateListItem
    {
        implicitHeight: _libraries.implicitHeight + Maui.Style.space.huge
        Layout.fillWidth: true

        Column
        {
            id: _libraries
            spacing: Maui.Style.space.big
            width: parent.width
            anchors.centerIn: parent

            Repeater
            {
                model: Kirigami.Settings.information
                Maui.ListItemTemplate
                {
                    iconSource: "plugins"
                    width: parent.width
                    isMask: true

                    iconSizeHint: Maui.Style.iconSizes.medium
                    headerSizeHint: iconSizeHint + Maui.Style.space.medium

                    spacing: Maui.Style.space.medium
                    label1.text: modelData
                }
            }
        }
    }


    Maui.AlternateListItem
    {
        Layout.fillWidth: true

        implicitHeight: _footerColumn.implicitHeight + Maui.Style.space.huge
        lastOne: true

        ColumnLayout
        {
            id: _footerColumn
            width: parent.width
            spacing: Maui.Style.space.medium
            anchors.centerIn: parent

            Maui.Icon
            {
                Layout.alignment: Qt.AlignCenter
                source: "qrc:/assets/mauikit.svg"
                color: Maui.Theme.textColor
                isMask: true
                implicitHeight: Maui.Style.iconSizes.big
                implicitWidth: implicitHeight
            }

            Maui.ListItemTemplate
            {
                id: _copyRight
                Layout.fillWidth: true
                isMask: true

                iconSizeHint: Maui.Style.iconSizes.medium
                headerSizeHint: iconSizeHint + Maui.Style.space.medium

                spacing: Maui.Style.space.medium
                label1.text: Maui.App.about.copyrightStatement
                label1.horizontalAlignment: Qt.AlignHCenter
                label1.font.family: "Monospace"
            }
        }
    }

    Item
    {
        id: _iconItem
        parent: control.background
        clip: true
        anchors.fill: parent
        anchors.margins: 1
        layer.enabled: true
        layer.effect: OpacityMask
        {
            cached: true
            maskSource:  Rectangle
            {
                width: control.width
                height: control.height
                radius: Maui.Style.radiusV
            }
        }
        
        Item
        {
            id: _iconRec
            anchors.fill: parent

            FastBlur
            {
                rotation: 45

                id: fastBlur
                height: parent.height * 3
                width: parent.width * 4
                anchors.centerIn: parent
                source: _div1.iconItem
                radius: 64
                transparentBorder: false
            }

            Rectangle
            {
                anchors.fill: parent
                opacity: 0.8
                color: control.Maui.Theme.backgroundColor
            }
        }

        HueSaturation
        {
            anchors.fill: _iconRec
            source: _iconRec
            hue: 0
            saturation: 1
            lightness: 0
        }

        OpacityMask
        {
            source: mask
            maskSource: _iconRec
        }

        LinearGradient
        {
            id: mask
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent"}
                GradientStop { position: 0.3; color: control.background.color}
            }

            start: Qt.point(0, 0)
            end: Qt.point(_iconRec.width, _iconRec.height)
        }
    }

    

}
