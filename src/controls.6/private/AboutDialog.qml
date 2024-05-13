
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

    Maui.SectionItem
    {
        id: _header
            imageSource: Maui.App.iconName

            template.fillMode: Image.PreserveAspectFit

            template.iconSizeHint: Maui.Style.iconSizes.huge
            template.imageSizeHint: template.iconSizeHint
            template.isMask: false
            template.headerSizeHint: template.iconSizeHint

            // spacing: Maui.Style.space.big
            label1.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            label1.text: Maui.App.about.displayName
            label1.font.weight: Font.Black
            label1.font.pointSize: Maui.Style.fontSizes.enormous

            label2.text: Maui.App.about.shortDescription
            label2.font.pointSize: Maui.Style.fontSizes.big
            label2.elide: Text.ElideRight
            label2.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
        
         Label
                {
                    Maui.Theme.inherit: true
                    Layout.alignment: horizontalAlignment
                    // Layout.fillWidth: true
                    horizontalAlignment:Qt.AlignLeft
                    text: Maui.App.about.version + " " + Maui.App.about.otherText
                    font.family: "Monospace"
                    opacity: 0.6
                    font.pointSize: Maui.Style.fontSizes.tiny
                    padding: Maui.Style.space.small
                    background: Rectangle
                    {
                        opacity: 0.5
                        color: "black"
                        radius: Maui.Style.radiusV                        
                    }                    

                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: 
                        {
                            Maui.Handy.copyTextToClipboard(parent.text)
                            root.notify("dialog-information", i18n("Version ID copied to clipboard"))
                                                        control.close()

                        }
                        
                        ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: containsMouse 
    ToolTip.text: i18n("Copy")
                    }
                }
                
                Column
        {
            id: _links
            spacing: Maui.Style.defaultSpacing
            Layout.fillWidth: true
    
            Button
            {
                Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary
    
                width: parent.width
                text: i18nd("mauikit", "Reports")
                onClicked: Qt.openUrlExternally(Maui.App.about.bugAddress)
            }

            Button
            {
                Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary
    
                width: parent.width
                text: i18nd("mauikit", "Home Page")
                onClicked: Qt.openUrlExternally(Maui.App.about.homepage)
            }
        }
    
     Maui.Separator 
    {
        Layout.fillWidth: true
    }

    Item{}
    
    Maui.SectionItem
    {
        id: _authorsSection
        label1.text: i18nd("mauikit", "Authors")
        visible: Maui.App.about.authors.length > 0

        // iconSource: "view-media-artist"
        template.isMask: true
        template.iconSizeHint: Maui.Style.iconSize

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

                    label1.text: modelData.emailAddress ? formatLink(modelData.name, String("mailto:%1").arg(modelData.emailAddress)) : modelData.name
                    label1.textFormat: Text.RichText
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

                    label1.text: modelData.emailAddress ? formatLink(modelData.name, String("mailto:%1").arg(modelData.emailAddress)) : modelData.name
                    label1.textFormat: Text.RichText
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

                    label1.text: modelData.emailAddress ? formatLink(modelData.name, String("mailto:%1").arg(modelData.emailAddress)) : modelData.name
                    label1.textFormat: Text.RichText
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
                    label1.textFormat: Text.RichText
                    
                    label1.text: modelData.webAddress ? formatLink(modelData.name, modelData.webAddress) : modelData.name

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
    
    /**
     * @private
     */
    function formatLink(text, url)
    {
        return String("<a href='%1' style=\"text-decoration:none;color:#fafafa\">%2</a>").arg(url).arg(text)
    }
}
