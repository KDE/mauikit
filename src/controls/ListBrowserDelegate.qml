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
    focus: true
    radius: Maui.Style.radiusV

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    isCurrentItem : ListView.isCurrentItem || checked
    
    padding: Maui.Style.defaultPadding
    spacing: padding
    
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

    property bool flat : !Maui.Handy.isMobile
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
      color: (control.isCurrentItem || control.containsPress ? Maui.Theme.highlightColor : ( control.hovered ? Maui.Theme.hoverColor : (control.flat ? "transparent" : Maui.Theme.alternateBackgroundColor)))
      
        radius: control.radius

        Rectangle
        {
            width: parent.width
            height: parent.height
            radius: control.radius
            visible: control.containsDrag
            color:  control.Maui.Theme.backgroundColor
            border.color: control.Maui.Theme.highlightColor
            Behavior on color
            {
              Maui.ColorTransition{}
            }
        }

        Behavior on color
        {
          enabled: !control.flat
          Maui.ColorTransition{}
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

        Loader
        {
            asynchronous: true
            active: control.checkable || control.checked
            visible: active
            Layout.preferredHeight: Maui.Style.iconSizes.medium
            Layout.preferredWidth: Math.max(Maui.Style.iconSizes.medium, _template.headerSizeHint)
            Layout.alignment: Qt.AlignCenter
            scale: active? 1 : 0
            
            Behavior on scale
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
            
            sourceComponent: Item
            {
                CheckBox
                {
                    anchors.centerIn: parent
                    height: Maui.Style.iconSizes.medium
                    width: Maui.Style.iconSizes.medium
                    Binding on checked
                    {
                        value: control.checked
                        restoreMode: Binding.RestoreBinding
                    }
                    onToggled: control.toggled(state)
                }                
            }           
        }

        Maui.ListItemTemplate
        {
            id: _template
            Layout.fillHeight: true
            Layout.fillWidth: true
            
            spacing: control.spacing
            
            hovered: control.hovered
            isCurrentItem : control.isCurrentItem
            highlighted: control.containsPress 
        }
    }
}
