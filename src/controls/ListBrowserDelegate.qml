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
import QtQml 2.14

import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

import "private" as Private

/**
 * ListBrowserDelegate
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.ItemDelegate
{
    id: control

    radius: Maui.Style.radiusV

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    isCurrentItem : ListView.isCurrentItem || checked
    padding: Maui.Style.space.small

    /**
      * content : ListItemTemplate.data
      */
    default property alias content : _template.content

    /**
      * label1 : Label
      */
    property alias label1 : _template.label1

    /**
      * label2 :  Label
      */
    property alias label2 : _template.label2

    /**
      * label3 : Label
      */
    property alias label3 : _template.label3

    /**
      * label4 : Label
      */
    property alias label4 : _template.label4

    /**
      * iconItem : Item
      */
    property alias iconItem : _template.iconItem

    /**
      * iconVisible : bool
      */
    property alias iconVisible : _template.iconVisible

    /**
      * iconSizeHint : int
      */
    property alias iconSizeHint : _template.iconSizeHint

    /**
      * imageSource : string
      */
    property alias imageSource : _template.imageSource

    /**
      * iconSource : string
      */
    property alias iconSource : _template.iconSource

    /**
      * showLabel : bool
      */
    property alias showLabel : _template.labelsVisible

    /**
      * checked : bool
      */
    property bool checked : false

    /**
      * checkable : bool
      */
    property bool checkable: false

    /**
      * leftLabels : ColumnLayout
      */
    property alias leftLabels: _template.leftLabels

    /**
      * rightLabels : ColumnLayout
      */
    property alias rightLabels: _template.rightLabels

    /**
      * template : ListItemTemplate
      */
    property alias template : _template

    property alias maskRadius : _template.maskRadius

    property alias containsDrag : _dropArea.containsDrag

    property alias dropArea : _dropArea

    property alias layout : _layout

    /**
      * contentDropped :
      */
    signal contentDropped(var drop)

    signal contentEntered(var drag)
    /**
      * toggled :
      */
    signal toggled(bool state)


    background: Rectangle
    {
        readonly property color m_color : Qt.tint(Qt.lighter(control.Kirigami.Theme.textColor), Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))

        color: control.hovered ? control.Kirigami.Theme.hoverColor :( control.isCurrentItem ||  control.containsPress ? control.Kirigami.Theme.highlightColor : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.4))

        radius: control.radius

        Rectangle
        {
            width: parent.width
            height: parent.height
            radius: control.radius
            visible: control.containsDrag
            color:  control.Kirigami.Theme.backgroundColor
            border.color: control.Kirigami.Theme.highlightColor
        }
    }

    DropArea
    {
        id: _dropArea
        width: parent.width
        height: parent.height
        enabled: control.draggable

        onDropped:
        {
            control.contentDropped(drop)
        }

        onEntered:
        {
            control.contentEntered(drag)
        }
    }

    RowLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: _template.spacing

//        Item
//        {
//            Layout.preferredHeight: Maui.Style.iconSizes.medium
//            visible: control.checkable || control.checked
//        }

        Loader
        {
            asynchronous: true
            active: control.checkable || control.checked
            visible: active
            Layout.preferredHeight: Math.min(Maui.Style.iconSizes.medium, control.height)
            Layout.preferredWidth: Maui.Style.iconSizes.medium
            Layout.alignment: Qt.AlignCenter
            scale: active? 1 : 0
            Behavior on scale
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
            sourceComponent: Private.CheckBoxItem
            {
                Binding on checked
                {
                    value: control.checked
                    restoreMode: Binding.RestoreBinding
                }
                onToggled: control.toggled(state)
            }
        }

        Maui.ListItemTemplate
        {
            id: _template
            Layout.fillHeight: true
            Layout.fillWidth: true
            hovered: control.hovered

            isCurrentItem : control.isCurrentItem
        }
    }
}
