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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.14

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

/**
 * ListItemTemplate
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Item
{
    id: control

    opacity: enabled ? 1 : 0.5
    /**
      * content : data
      */
    default property alias content: _layout.data

    implicitHeight: _layout.implicitHeight
    implicitWidth: _layout.implicitWidth

    /**
      * text1 : string
      */
    property alias text1 : _label1.text

    /**
      * text2 : string
      */
    property alias text2 : _label2.text

    /**
      * text3 : string
      */
    property alias text3 : _label3.text

    /**
      * text4 : string
      */
    property alias text4 : _label4.text

    /**
      * label1 : Label
      */
    property alias label1 : _label1

    /**
      * label2 : Label
      */
    property alias label2 : _label2

    /**
      * label3 : Label
      */
    property alias label3 : _label3

    /**
      * label4 : Label
      */
    property alias label4 : _label4

    /**
      * iconItem : Item
      */
    property alias iconItem : _iconLoader.item

    /**
      * iconVisible : bool
      */
    property alias iconVisible : _iconContainer.visible

    /**
      * leftLabels : ColumnLayout
      */
    property alias leftLabels : _leftLabels

    /**
      * rightLabels : ColumnLayout
      */
    property alias rightLabels : _rightLabels

    /**
      * spacing : int
      */
    property alias spacing : _layout.spacing

    /**
      * layout : RowLayout
      */
    property alias layout : _layout

    /**
      * iconSizeHint : int
      */
    property int iconSizeHint : Maui.Style.iconSizes.big
    property int imageSizeHint : -1
    
    property int headerSizeHint : height

    /**
      * imageSource : string
      */
    property string imageSource

    /**
      * iconSource : string
      */
    property string iconSource

    /**
      * isCurrentItem : bool
      */
    property bool isCurrentItem: false

    /**
      * labelsVisible : bool
      */
    property bool labelsVisible: true

    /**
      * hovered : bool
      */
    property bool hovered : false

    /**
      * fillMode : Image.fillMode
      */
    property int fillMode : Image.PreserveAspectCrop

    /**
      * maskRadius : int
      */
    property int maskRadius: Maui.Style.radiusV

    /**
      * margins : int
      */
    property int margins: 0

    /**
      * rightMargin : int
      */
    property int rightMargin: Maui.Style.space.medium

    /**
      * leftMargin : int
      */
    property int leftMargin: Maui.Style.space.medium

    /**
      * topMargin : int
      */
    property int topMargin: margins

    /**
      * bottomMargin : int
      */
    property int bottomMargin: margins

    /**
      * iconComponent : Component
      */
    property Component iconComponent :  _iconContainer.visible ? _iconComponent : null

    Component
    {
        id: _iconComponent

        Maui.IconItem
        {
            iconSource: control.iconSource
            imageSource: control.imageSource

            highlighted: control.isCurrentItem
            hovered: control.hovered

            iconSizeHint: control.iconSizeHint
            imageSizeHint: control.imageSizeHint
            
            fillMode: control.fillMode
            maskRadius: control.maskRadius
        }
    }

    RowLayout
    {
        id: _layout
        anchors.fill: parent
        anchors.margins: control.margins
        anchors.leftMargin: control.leftMargin
        anchors.rightMargin: control.rightMargin
        anchors.topMargin: control.topMargin
        anchors.bottomMargin: control.bottomMargin

        spacing: Maui.Style.space.small

        Item
        {
            id: _iconContainer
            implicitHeight: iconSizeHint

            visible: (control.width > Kirigami.Units.gridUnit * 10) && (iconSource.length > 0 || imageSource.length > 0)

            Layout.alignment: Qt.AlignCenter

            Layout.fillHeight: true
            Layout.fillWidth: !control.labelsVisible

            Layout.preferredWidth: Math.min(height, control.headerSizeHint)
            Layout.preferredHeight: Math.max(control.height, control.headerSizeHint)

            Kirigami.Icon
            {
                visible: _iconLoader.status !== Loader.Ready
                anchors.centerIn: parent
                height: Maui.Style.iconSizes.small
                width: height
                source:  control.iconSource || "folder-images"
                isMask: true
                color: Kirigami.Theme.textColor
                opacity: 0.5
            }

            Loader
            {
                id: _iconLoader
                asynchronous: true
                anchors.fill: parent
                anchors.margins: Maui.Style.space.tiny

                sourceComponent: control.iconComponent
            }
        }

        ColumnLayout
        {
            id: _leftLabels
            visible: control.labelsVisible
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0

            Label
            {
                id: _label1
                visible: text.length
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: _label2.visible ? Qt.AlignBottom :  Qt.AlignVCenter

                elide: Text.ElideMiddle
                wrapMode: Text.NoWrap
                color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                font.weight: Font.Normal
            }

            Label
            {
                id: _label2
                visible: text.length
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: _label1.visible ? Qt.AlignTop : Qt.AlignVCenter

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                opacity: control.isCurrentItem ? 0.8 : 0.6

                font.weight: Font.Normal
            }
        }

        ColumnLayout
        {
            id: _rightLabels
            visible: control.width >  Kirigami.Units.gridUnit * 15 && control.labelsVisible && control.height > 32
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: Maui.Style.space.tiny
            spacing: 0

            Label
            {
                id: _label3
                visible: text.length > 0
                Layout.fillHeight: true
                Layout.minimumWidth: implicitWidth
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: _label4.visible ? Qt.AlignBottom :  Qt.AlignVCenter

                font.pointSize: Maui.Style.fontSizes.small
                font.weight: Font.Light
                wrapMode: Text.NoWrap
                elide: Text.ElideMiddle
                color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                opacity: control.isCurrentItem ? 0.8 : 0.6
            }

            Label
            {
                id: _label4
                visible: text.length > 0
                Layout.fillHeight: true
                Layout.minimumWidth: implicitWidth
                Layout.preferredWidth: implicitWidth
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: _label3.visible ? Qt.AlignTop : Qt.AlignVCenter

                font.pointSize: Maui.Style.fontSizes.small
                font.weight: Font.Light
                wrapMode: Text.NoWrap
                elide: Text.ElideMiddle
                color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                opacity: control.isCurrentItem ? 0.8 : 0.6
            }
        }
    }
}
