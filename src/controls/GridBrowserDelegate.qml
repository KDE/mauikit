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
import QtQml 2.14

import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/**
 * GridBrowserDelegate
 * A GridItemTemplate wrapped into a ItemDelegate to make it clickable and draggable.
 *
 * For more details check the ItemDelegate and GridItemTemplate documentation.
 *
 * This mix adds a drop area, tooltip information and a custom styling.
 *
 *
 */
Maui.ItemDelegate
{
    id: control
    
    isCurrentItem : GridView.isCurrentItem || checked
    flat : !Maui.Handy.isMobile
    
    implicitHeight: _template.implicitHeight + topPadding +bottomPadding
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.medium
    
    radius: Maui.Style.radiusV

    /**
     * template : GridItemTemplate
     */
    property alias template : _template
    
    
    /**
     * label1 : Label
     */
    property alias label1 : _template.label1

    /**
     * label2 : Label
     */
    property alias label2 : _template.label2


    /**
     * iconItem : Item
     */
    property alias iconItem : _template.iconItem

    /**
     * iconVisible : bool
     */
    property alias iconVisible : _template.iconVisible
    property alias imageSizeHint : _template.imageSizeHint
    
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
    //property alias showLabel : _template.labelsVisible

    property alias labelsVisible : _template.labelsVisible

    /**
     * checked : bool
     */
    property bool checked : false

    property alias fillMode : _template.fillMode

    property alias maskRadius : _template.maskRadius

    /**
     * checkable : bool
     */
    property bool checkable: false

    /**
     * dropArea : DropArea
     */
    property alias dropArea : _dropArea

    property alias imageWidth : _template.imageWidth
    property alias imageHeight : _template.imageHeight
    
    /**
     * contentDropped :
     */
    signal contentDropped(var drop)

    /**
     * toggled :
     */
    signal toggled(bool state)

    background: Rectangle
    {
        color: (control.isCurrentItem || control.containsPress ? Maui.Theme.highlightColor : ( control.hovered ? Maui.Theme.hoverColor : (control.flat ? "transparent" : Maui.Theme.alternateBackgroundColor)))

        
        radius: control.radius

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
        Rectangle
        {
            anchors.fill: parent
            radius: control.radius
            color:  control.Maui.Theme.backgroundColor
            border.color: control.Maui.Theme.highlightColor
            visible: parent.containsDrag
        }

        onDropped:
        {
            control.contentDropped(drop)
        }
    }

    Maui.GridItemTemplate
    {
        id: _template
        anchors.fill: parent
        iconContainer.scale: _dropArea.containsDrag  || _checkboxLoader.active ? 0.8 : 1
        hovered: control.hovered
        maskRadius: control.radius
        spacing: control.spacing
        isCurrentItem: control.isCurrentItem
        highlighted: control.containsPress 
    }

    Loader
    {
        id: _checkboxLoader
        asynchronous: true
        active: control.checkable || control.checked
        height: Math.max(Maui.Style.iconSizes.medium, parent.height * 0.1)
        width: height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: Maui.Style.space.medium
        scale: active ? 1 : 0

        Behavior on scale
        {
            NumberAnimation
            {
                duration: Maui.Style.units.longDuration*2
                easing.type: Easing.OutBack
            }
        }

        sourceComponent: CheckBox
        {
            checkable: control.checkable
            Binding on checked
            {
                value: control.checked
                restoreMode: Binding.RestoreBinding
            }
            onToggled: control.toggled(state)
        }
    }
}
