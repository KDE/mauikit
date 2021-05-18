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

import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

/**
 * GridItemTemplate
 * A template with a icon or image and a bottom label..
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

    /**
      * text1 : string
      */
    property alias text1 : _label1.text

    /**
      * label1 : Label
      */
    property alias label1 : _label1

    /**
      * iconItem : Item
      */
    property alias iconItem : _iconLoader.item

    /**
      * iconVisible : bool
      */
    property alias iconVisible : _iconContainer.visible

    /**
     * labelSizeHint : int
     */
    property int labelSizeHint : height * 0.4
    
    /**
      * iconSizeHint : int
      */
    property int iconSizeHint : Maui.Style.iconSizes.big

    /**
      * imageWidth : int
      */
    property int imageWidth : iconSizeHint

    /**
      * imageHeight : int
      */
    property int imageHeight : iconSizeHint

    /**
      * imageSource : string
      */
    property string imageSource

    /**
      * iconSource : string
      */
    property string iconSource

    /**
      * checkable : bool
      */
    property bool checkable : false

    /**
      * checked : bool
      */
    property bool checked : false

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
    property int fillMode : Image.PreserveAspectCrop

    /**
      * maskRadius : int
      */
    property int maskRadius: Maui.Style.radiusV

    /**
      * hovered : bool
      */
    property bool hovered: false

    /**
      * iconComponent : Component
      */
    property Component iconComponent :  _iconContainer.visible ? _iconComponent : null


    /**
      * toggled :
      */
    signal toggled(bool state)

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

            fillMode: control.fillMode
            maskRadius: control.maskRadius
        }
    }

    ColumnLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: Maui.Style.space.tiny

        Item
        {
            id: _iconContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 1            

            Kirigami.Icon
            {
                visible: _iconLoader.status !== Loader.Ready
                anchors.centerIn: parent
                height: Math.min(Maui.Style.iconSizes.medium, Math.floor( parent.height * 0.7))
                width: height
                source:  control.iconSource || "folder-images"
                isMask: true
                color: Kirigami.Theme.textColor
                opacity: 0.5
            }

            Loader
            {
                id: _iconLoader
                anchors.fill: parent
                asynchronous: true
                sourceComponent: control.iconComponent

                Maui.Badge
                {
                    id: _emblem

                    visible: control.checkable || control.checked
                    size: Math.max(Maui.Style.iconSizes.medium, parent.height * 0.2)
                    anchors.margins: Maui.Style.space.medium
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom

                    color: control.checked ? Kirigami.Theme.highlightColor : Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.5)

                    border.color: Kirigami.Theme.highlightedTextColor

                    onClicked:
                    {
                        control.checked = !control.checked
                        control.toggled(control.checked)
                    }

                    Kirigami.Icon
                    {
                        visible: opacity > 0
                        color: Kirigami.Theme.highlightedTextColor
                        anchors.centerIn: parent
                        height: control.checked ? Math.round(parent.height * 0.9) : 0
                        width: height
                        opacity: control.checked ? 1 : 0
                        isMask: true
                        
                        source: "qrc:/assets/checkmark.svg"

                        Behavior on opacity
                        {
                            NumberAnimation
                            {
                                duration: Kirigami.Units.shortDuration
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }

        Kirigami.ShadowedRectangle
        {
            visible: control.labelsVisible && _label1.text

            Layout.preferredHeight: Maui.Style.iconSizes.big
            Layout.margins: 2

            Layout.fillWidth: true
            Layout.maximumHeight: Math.min(48, control.labelSizeHint)
            Layout.minimumHeight: Math.min(_label1.implicitHeight, 48)
            color: Kirigami.Theme.backgroundColor
            
            corners
            {
                topLeftRadius: 0
                topRightRadius: 0
                bottomLeftRadius: Maui.Style.radiusV
                bottomRightRadius: Maui.Style.radiusV
            }

            Label
            {
                id: _label1
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                width: parent.width
                height: parent.height

                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
            }
            
            Rectangle
            {
                visible: (control.hovered ) && _label1.implicitHeight > _label1.height
                height: Math.min(_label2.implicitHeight, control.height)
                width: parent.width
                color: Kirigami.Theme.backgroundColor
                anchors.bottom: parent.bottom
                radius: Maui.Style.radiusV

                Label
                {
                    id: _label2
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    text: _label1.text
                    width: parent.width
                    height: implicitHeight
                    elide: Qt.ElideRight
                    wrapMode: Text.Wrap
                    color: control.isCurrentItem ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                }
                
            }
        }
    }
}
