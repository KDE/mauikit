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

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

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
    focus: false
    isCurrentItem : GridView.isCurrentItem || checked
    
    radius: maskRadius
    /**
     * tooltipText : string
     */
    property string tooltipText
    
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
    property alias checked : _emblem.checked
    
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
    
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: control.hovered && control.tooltipText
    ToolTip.text: control.tooltipText
    
    background: Rectangle
    {
        readonly property color m_color : Qt.tint(Qt.lighter(control.Kirigami.Theme.textColor), Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.95))
        
        color: control.isCurrentItem || control.hovered || control.containsPress ? Qt.rgba(control.Kirigami.Theme.highlightColor.r, control.Kirigami.Theme.highlightColor.g, control.Kirigami.Theme.highlightColor.b, 0.2) : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.5)

        radius: control.maskRadius
//         border.color: control.isCurrentItem || control.containsPress ? control.Kirigami.Theme.highlightColor : "transparent"        
    }
    
    DropArea
    {
        id: _dropArea
        anchors.fill: parent
        enabled: control.draggable
        
        onDropped:
        {
            control.contentDropped(drop)
        }
    }
    
    Maui.GridItemTemplate
    {
        id: _template
        anchors.fill: parent
        
        hovered: control.hovered || control.containsPress || _dropArea.containsDrag
        //        label1.elide: Text.ElideMiddle // TODO this is broken ???
        isCurrentItem: control.isCurrentItem
    }
    
    Private.CheckBoxItem
    {
        id: _emblem
        visible: control.checkable || control.checked
        height: Math.max(Maui.Style.iconSizes.medium, parent.height * 0.1)
        width: height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: Maui.Style.space.medium
        onToggled: control.toggled(state)
    }
}
