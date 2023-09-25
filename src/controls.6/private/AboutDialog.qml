
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import org.mauikit.controls as Maui

Maui.PopupPage
{
    id: control
    persistent: false
    widthHint: 0.9
    heightHint: 0.8

    width: 360
    maxHeight: implicitHeight

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary

    property alias mainHeader : _header

    Control
    {
        id: _header
        Layout.fillWidth: true
        implicitHeight: _div1.implicitHeight + topPadding + bottomPadding
        padding: Maui.Style.space.big
        background: null

        contentItem: Maui.ListItemTemplate
        {
            id: _div1

            imageSource: Maui.App.iconName

            fillMode: Image.PreserveAspectFit
            iconSizeHint: Maui.Style.iconSizes.huge
            imageSizeHint: iconSizeHint
            isMask: false

            spacing: Maui.Style.space.medium
            label1.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            label1.text: Maui.App.about.displayName
            label1.font.weight: Font.Black
            label1.font.pointSize: Maui.Style.fontSizes.enormous * 1.5

            label2.text: Maui.App.about.shortDescription
            label2.font.pointSize: Maui.Style.fontSizes.big
            label2.elide: Text.ElideRight
            label2.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            leftLabels.spacing: Maui.Style.space.medium

            leftLabels.data: [

                Label
                {
                    Maui.Theme.inherit: true
                    Layout.fillWidth: true
                    text: Maui.App.about.version + " " + Maui.App.about.otherText
                    font.family: "Monospace"
                    opacity: 0.6
                    font.pointSize: Maui.Style.fontSizes.small
                    color: _div1.label1.color

                    MouseArea
                    {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onDoubleClicked: Maui.Handy.copyTextToClipboard(parent.text)
                    }
                }
            ]
        }
    }

    Item
    {
        Layout.fillWidth: true
        implicitHeight: Maui.Style.space.big
    }

    Maui.SectionItem
    {
        id: _authorsSection
        // label1.text: i18nd("mauikit", "Authors")
        visible: Maui.App.about.authors.length > 0

        // iconSource: "view-media-artist"
        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize
        columns: 1

        Column
        {
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true
            opacity: 0.8

            Repeater
            {
                model: Maui.App.about.authors

                Maui.ListItemTemplate
                {
                    id: _credits

                    width: parent.width

                    label1.text: modelData.emailAddress ? String("<a href='mailto:%1' style=\"text-decoration:none;\">%2</a>").arg(modelData.emailAddress).arg(modelData.name) : modelData.name
                    label1.textFormat: Text.AutoText
                    // label1.linkColor: Maui.Theme.textColor
                    label3.text: modelData.task

                    Connections
                    {
                        target: _credits.label1
                        function onLinkActivated(link)
                        {
                            Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }
    }

    Maui.SectionItem
    {
        id: _translatorsSection
        label1.text: i18nd("mauikit", "Translators")
        visible: Maui.App.about.translators.length > 0
        // iconSource: "folder-language"
        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize
        columns: 1

        Column
        {
            id: _translators
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true
            opacity: 0.8

            Repeater
            {
                model: Maui.App.about.translators

                Maui.ListItemTemplate
                {
                    id: _tCredits

                    width: parent.width

                    label1.text: modelData.emailAddress ? String("<a href='mailto:%1' style=\"text-decoration:none;\>%2</a>").arg(modelData.emailAddress).arg(modelData.name) : modelData.name
                    label1.textFormat: Text.AutoText
                    label3.text: modelData.task
                    Connections
                    {
                        target: _tCredits.label1
                        function onLinkActivated(link)
                        {
                            Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }
    }

    Maui.SectionItem
    {
        id: _creditsSection
        label1.text: i18nd("mauikit", "Credits")
        visible: Maui.App.about.credits.length > 0
        // iconSource: "love"
        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize
        columns: 1

        Column
        {
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true
            opacity: 0.8

            Repeater
            {
                model: Maui.App.about.credits

                Maui.ListItemTemplate
                {
                    id: _tCredits

                    width: parent.width

                    label1.text: modelData.emailAddress ? String("<a href='mailto:%1'>%2</a>").arg(modelData.emailAddress).arg(modelData.name) : modelData.name
                    label1.textFormat: Text.AutoText
                    label3.text: modelData.task
                    Connections
                    {
                        target: _tCredits.label1
                        function onLinkActivated(link)
                        {
                            Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }
    }

    Maui.SectionItem
    {
        id: _licensesSection
        visible: Maui.App.about.licenses.length > 0
        // iconSource: "license"

        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize

        label1.text: i18nd("mauikit", "Licenses")
        columns: 1

        Column
        {
            id: _licenses
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true
            opacity: 0.8

            Repeater
            {
                model: Maui.App.about.licenses
                Maui.ListItemTemplate
                {
                    width: parent.width
                    label1.text: modelData.name
                    label3.text: modelData.spdx
                }
            }
        }
    }

    Maui.SectionItem
    {
        id: _componentsSection
        // iconSource: "code-context"
        visible: Maui.App.about.components.length > 0
        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize
        columns: 1

        label1.text: i18nd("mauikit", "Components")

        Column
        {
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true
            opacity: 0.8
            Repeater
            {
                model: Maui.App.about.components
                Maui.ListItemTemplate
                {
                    width: parent.width
                    label1.textFormat: Text.AutoText

                    label1.text: modelData.webAddress ? String("<a href='%1'>%2</a>").arg(modelData.webAddress).arg(modelData.name) : modelData.name


                    label2.text: modelData.description
                    label3.text: modelData.version

                    Connections
                    {
                        target: label1
                        function onLinkActivated(link)
                        {
                            Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }

    }

    Maui.SectionItem
    {
        id: _linksssSection
        // label1.text: i18nd("mauikit", "Links")
        // iconSource: "link"
        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize
        columns: 1

        Column
        {
            id: _links
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true

            Button
            {
                width: parent.width
                text: i18nd("mauikit", "Reports")
                onClicked: Qt.openUrlExternally(Maui.App.about.bugAddress)
            }

            Button
            {
                width: parent.width
                text: i18nd("mauikit", "Home Page")
                onClicked: Qt.openUrlExternally(Maui.App.about.homepage)
            }
        }
    }

    Item
    {
        Layout.fillWidth: true
        implicitHeight: Maui.Style.space.big
    }

    ColumnLayout
    {
        id: _footerColumn
        Layout.fillWidth: true
        opacity: 0.7
        spacing: Maui.Style.space.small

        Maui.Icon
        {
            visible: Maui.App.about.copyrightStatement.indexOf("Maui") > 0
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
            //                     headerSizeHint: iconSizeHint + Maui.Style.space.medium

            spacing: Maui.Style.defaultSpacing
            label1.text: Maui.App.about.copyrightStatement
            label1.horizontalAlignment: Qt.AlignHCenter
            label1.font.pointSize: Maui.Style.fontSizes.small
            label1.font.family: "Monospace"
        }
    }

    Item
    {
        id: _iconItem
        parent: control.background
        clip: true
        anchors.fill: parent

        Image
        {
            anchors.fill: parent
            source: "qrc:/assets/subtle-dots.png"
            fillMode: Image.Tile
            opacity: 0.15
        }
    }


}
