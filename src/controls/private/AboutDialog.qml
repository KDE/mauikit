
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
import org.kde.mauikit 1.2 as Maui

Maui.Dialog
{
    id: control
    
    defaultButtons: false
        persistent: false
        widthHint: 0.9
        heightHint: 0.8
        
        maxWidth: 350
        maxHeight: 250
        
        /**
         * mainHeader : AlternateListItem
         */
        property alias mainHeader : _header
        //         defaultButtonsLayout.visible: flickable.atYEnd
        page.padding: 0
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
        
        verticalScrollBarPolicy: ScrollBar.AlwaysOff
        
        Maui.AlternateListItem
        {
            id: _header
            Layout.fillWidth: true
            implicitHeight: Math.max((_div1.implicitHeight * 1.5) + Maui.Style.space.big, control.page.height+ Maui.Style.space.tiny)
            
            Item
            {
                id: _iconItem
                anchors.fill: parent
                clip: true
                
                Item
                {
                    id: _iconRec
                    anchors.fill: parent
                    
                    FastBlur
                    {
                        id: fastBlur
                        height: parent.height * 2
                        width: parent.width * 2
                        anchors.centerIn: parent
                        source: _div1.iconItem
                        radius: 64
                        transparentBorder: true
                        cached: true
                    }
                    
                    Rectangle
                    {
                        anchors.fill: parent
                        opacity: 0.8
                        color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
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
                        GradientStop { position: 0.2; color: "transparent"}
                        GradientStop { position: 0.5; color: control.background.color}
                    }
                    
                    start: Qt.point(0, 0)
                    end: Qt.point(_iconRec.width, _iconRec.height)
                }
                                
                Maui.Separator
                {
                    edge: Qt.BottomEdge
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }            
            
            Maui.ListItemTemplate
            {
                id: _div1
                
                width: parent.width
                anchors.centerIn: parent
                
                imageBorder: false
                imageSource: Maui.App.iconName
                imageWidth: Math.min(Maui.Style.iconSizes.huge, parent.width)
                imageHeight: imageWidth
                fillMode: Image.PreserveAspectFit
                imageSizeHint: imageWidth
                
                spacing: Maui.Style.space.big
                label1.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                label1.text: Maui.App.about.displayName
                label1.font.weight: Font.Bold
                label1.font.bold: true
                label1.font.pointSize: Maui.Style.fontSizes.enormous * 1.3
                
                label2.text:  Maui.App.about.version + "\n" + Maui.App.about.shortDescription
                label2.elide: Text.ElideRight
                label2.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                leftLabels.spacing: Maui.Style.space.medium
                leftLabels.data:    Repeater
                {
                    model: Maui.App.about.licenses
                    Label
                    {
                        Layout.fillWidth: true
                        text: "© " + modelData.name
                    }
                }
            } 
        }
        
        Maui.AlternateListItem
        {
            Layout.fillWidth: true
            Layout.preferredHeight: _credits.implicitHeight + Maui.Style.space.huge
            
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
                        width: parent.width
                        spacing: Maui.Style.space.medium
                        label1.text: modelData.name
                        label2.text: String("<a href='mailto:%1'>%1</a>").arg(modelData.emailAddress)
                        label3.text: modelData.task
                        
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
            Layout.fillWidth: true
            Layout.preferredHeight: _licenses.implicitHeight + Maui.Style.space.huge
            
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
                        iconSizeHint: Maui.Style.iconSizes.medium
                        spacing: Maui.Style.space.medium
                        label1.text: modelData.name
                    }
                }
            }
        }        
        
        Maui.AlternateListItem
        {
            Layout.fillWidth: true
            Layout.preferredHeight: _poweredBy.implicitHeight + Maui.Style.space.huge
            
            Maui.ListItemTemplate
            {
                id: _poweredBy
                anchors.centerIn: parent
                width: parent.width
                
                iconSource: "code-context"
                iconSizeHint: Maui.Style.iconSizes.medium
                spacing: Maui.Style.space.medium
                label1.text: "Powered by"
                label2.text: "<a href='https://mauikit.org'>MauiKit</a> " + Maui.App.mauikitVersion
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
            Layout.fillWidth: true
            Layout.preferredHeight: _libraries.implicitHeight + Maui.Style.space.huge
            
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
                        iconSizeHint: Maui.Style.iconSizes.medium
                        spacing: Maui.Style.space.medium
                        label1.text: modelData
                    }
                }
            }
        }        
        
        Maui.AlternateListItem
        {
            Layout.fillWidth: true
            Layout.preferredHeight: _footerColumn.implicitHeight + Maui.Style.space.huge
            lastOne: true
            
            ColumnLayout
            {
                id: _footerColumn
                width: parent.width
                spacing: Maui.Style.space.big
                anchors.centerIn: parent
                
                RowLayout
                {
                    spacing: Maui.Style.space.big
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredHeight: Maui.Style.rowHeight                    
                    
                    Kirigami.Icon
                    {
                        source: "qrc:/assets/nitrux.svg"
                        color: Kirigami.Theme.textColor
                        isMask: true
                        implicitHeight: Maui.Style.iconSizes.big
                        implicitWidth: implicitHeight
                    }
                    
                    Kirigami.Icon
                    {
                        source: "qrc:/assets/mauikit.svg"
                        color: Kirigami.Theme.textColor
                        isMask: true
                        implicitHeight: Maui.Style.iconSizes.big
                        implicitWidth: implicitHeight
                    }
                    
                    Kirigami.Icon
                    {
                        source: "qrc:/assets/kde.svg"
                        color: Kirigami.Theme.textColor
                        isMask: true
                        implicitHeight: Maui.Style.iconSizes.big
                        implicitWidth: implicitHeight
                    }
                    
                }
                
                Maui.ListItemTemplate
                {
                    id: _copyRight
                    Layout.fillWidth: true
                    
                    iconSizeHint: Maui.Style.iconSizes.medium
                    spacing: Maui.Style.space.medium
                    label1.text: Maui.App.about.copyrightStatement
                    label1.horizontalAlignment: Qt.AlignHCenter
                }
            }
        }
}
