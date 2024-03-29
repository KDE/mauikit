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
    /**
     * content : data
     */
    default property alias content: _layout.data

    implicitHeight: _layout.implicitHeight

    property alias spacing: _layout.spacing

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
         * iconItemContainer : Item
         */
    property alias iconContainer : _iconLoader

    /**
         * iconItem : Item
         */
    property alias iconItem : _iconLoader.item

    /**
         * iconVisible : bool
         */
    property alias iconVisible : _iconLoader.visible

    /**
         * leftLabels : ColumnLayout
         */
    property alias leftLabels : _leftLabels

    /**
         * rightLabels : ColumnLayout
         */
    property alias rightLabels : _rightLabels


    /**
         * layout : RowLayout
         */
    property alias layout : _layout

    /**
         * iconSizeHint : int
         */
    property int iconSizeHint : Maui.Style.iconSizes.big
    property int imageSizeHint : -1
    property int headerSizeHint : -1

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
         * fillMode : Image.fillMode
         */
    property int fillMode : Image.PreserveAspectFit

    /**
         * maskRadius : int
         */
    property int maskRadius: 0


    /**
         * iconComponent : Component
         */
    property Component iconComponent : _iconComponent

    property bool isMask : iconSizeHint <= Maui.Style.iconSizes.small
    property bool hovered: false

    property bool highlighted: false

    Component
    {
        id: _iconComponent

        Maui.IconItem
        {
            iconSource: control.iconSource
            imageSource: control.imageSource

            highlighted: control.isCurrentItem || control.highlighted
            hovered: control.hovered

            iconSizeHint: control.iconSizeHint
            imageSizeHint: control.imageSizeHint

            fillMode: control.fillMode
            maskRadius: control.maskRadius

            isMask: control.isMask
        }
    }

    RowLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: Maui.Style.space.medium

        readonly property color labelColor: control.isCurrentItem || control.highlighted? Maui.Theme.highlightedTextColor : Maui.Theme.textColor

            Loader
            {
                id: _iconLoader

                asynchronous: true

                visible: (control.width > Maui.Style.units.gridUnit * 10) && (control.iconSource.length > 0 || control.imageSource.length > 0)

                active: visible

                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: !control.labelsVisible
                Layout.fillHeight: true
                Layout.preferredWidth: Math.max(implicitWidth, control.headerSizeHint)
                Layout.preferredHeight: Math.max(implicitHeight, control.headerSizeHint)

                sourceComponent: control.iconComponent
            }


        ColumnLayout
        {
            id: _leftLabels
            clip: true
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

                elide: Text.ElideRight
                //                wrapMode: _label2.visible ? Text.NoWrap : Text.Wrap
                wrapMode: Text.NoWrap
textFormat: Text.PlainText
                color: _layout.labelColor
            }

            Label
            {
                id: _label2
                visible: text.length

                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: _label1.visible ? Qt.AlignTop : Qt.AlignVCenter

                elide: Text.ElideRight
                //                wrapMode: Text.Wrap
                wrapMode: Text.NoWrap
                textFormat: Text.PlainText
 color: _layout.labelColor
 opacity: control.isCurrentItem ? 0.8 : 0.6
            }
        }

        ColumnLayout
        {
            id: _rightLabels
            clip: true
            // visible: (control.width >  Maui.Style.units.gridUnit * 15) && control.labelsVisible

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: control.width/2
            Layout.preferredWidth: implicitWidth
            Layout.minimumWidth: 0
            spacing: _leftLabels.spacing

            Label
            {
                id: _label3
                visible: text.length > 0

                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignRight

                horizontalAlignment: Qt.AlignRight
                verticalAlignment: _label4.visible ? Qt.AlignBottom :  Qt.AlignVCenter

                font.pointSize: Maui.Style.fontSizes.tiny

                wrapMode: Text.NoWrap
                elide: Text.ElideMiddle
                textFormat: Text.PlainText
 color: _layout.labelColor
 opacity: control.isCurrentItem ? 0.8 : 0.6
            }

            Label
            {
                id: _label4
                visible: text.length > 0

                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: _label3.visible ? Qt.AlignTop : Qt.AlignVCenter

                font.pointSize: Maui.Style.fontSizes.tiny

                wrapMode: Text.NoWrap
                elide: Text.ElideMiddle
                textFormat: Text.PlainText
                color: _layout.labelColor
                opacity: control.isCurrentItem ? 0.8 : 0.6
            }
        }
    }
}
