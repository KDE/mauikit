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

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Maui.PopupPage
{
    id: control

    default property alias content : _content.data
    property var urls: []

    property string message : ""

    readonly property var singleItem : FB.FM.getFileInfo(control.urls[0])
    property alias template : _template

    hint: 1
    maxWidth: 350

    headBar.visible: false

    Maui.ListItemTemplate
    {
        id: _template
        visible: control.message.length
        Layout.fillWidth: true
        label2.text: message
        label2.textFormat : TextEdit.AutoText
        label2.wrapMode: TextEdit.WordWrap
        iconVisible: control.width > Maui.Style.units.gridUnit * 10

        iconSizeHint: Maui.Style.iconSizes.large
        spacing: Maui.Style.space.big

        leftLabels.spacing: control.spacing

        headerSizeHint: template.iconSizeHint + Maui.Style.space.big
        iconSource: singleItem.icon
        imageSource: singleItem.thumbnail
        implicitHeight: Math.max(template.leftLabels.implicitHeight, 64)


        leftLabels.data: ColumnLayout
        {
            id: _content
            Layout.fillWidth: true
            spacing: control.spacing
        }

        iconComponent: Item
        {
            Item
            {
                height: Math.min(parent.height, 120, width)
                width: parent.width
                anchors.centerIn: parent
                layer.enabled: true

                Rectangle
                {
                    visible: control.urls ? control.urls.length > 1 : false
                    anchors.fill: parent

                    anchors.leftMargin: Maui.Style.space.small
                    anchors.rightMargin: Maui.Style.space.small

                    radius: Maui.Style.radiusV
                    color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
                    border.color: Maui.Theme.backgroundColor
                }

                Rectangle
                {
                    visible: control.urls ? control.urls.length > 1 : false
                    anchors.fill: parent

                    anchors.topMargin: Maui.Style.space.tiny
                    anchors.leftMargin: Maui.Style.space.tiny
                    anchors.rightMargin: Maui.Style.space.tiny

                    radius: Maui.Style.radiusV
                    color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
                    border.color: Maui.Theme.backgroundColor
                }

                Rectangle
                {
                    anchors.fill: parent
                    anchors.topMargin:  control.urls.length > 1 ? Maui.Style.space.small : 0
                    border.color: Maui.Theme.backgroundColor

                    radius: Maui.Style.radiusV
                    color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))

                    Maui.GridItemTemplate
                    {
                        anchors.fill: parent
                        anchors.margins: Maui.Style.space.tiny
                        iconSizeHint: Math.min(height, width)

                        iconSource: control.template.iconSource
                        imageSource:  control.template.imageSource
                    }
                }
            }
        }

    }

    property Component listDelegate : Maui.ListItemTemplate
    {
        width: ListView.view.width
        height: Maui.Style.rowHeight
        property var item : FB.FM.getFileInfo(modelData)
        label1.text: item.label
        label3.text: Maui.Handy.formatSize(item.size)
        rightLabels.visible: true
        iconVisible: true
        iconSource: item.icon
        imageSource: item.thumbnail
        iconSizeHint: Maui.Style.iconSizes.medium

        ToolButton
        {
            //text: i18nd("mauikit", "Clear")
            icon.name: "edit-clear"
            icon.width: Maui.Style.iconSizes.small
            icon.height: Maui.Style.iconSizes.small

            onClicked:
            {
                var array = control.urls
                const index = array.indexOf(modelData);
                if (index > -1) {
                    array.splice(index, 1);
                }

                if(array.length === 0)
                {
                    control.close()
                    return
                }

                control.urls = array
            }
        }
    }

    Loader
    {
        id: _listViewLoader

        asynchronous: true
        active: control.urls.length > 0
        visible: active

        Layout.fillWidth: true

        sourceComponent: Maui.ListBrowser
        {
clip: true
            implicitHeight: Math.min(contentHeight, 300)
            model: urls
            spacing: Maui.Style.defaultSpacing
            padding: 0

            delegate: control.listDelegate
        }
    }
}
