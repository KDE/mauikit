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

import org.mauikit.controls 1.3 as Maui

/**
 * ListDelegate
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
    
    implicitHeight: _template.implicitHeight + topPadding + bottomPadding
    
    padding: Maui.Style.space.medium
    /**
      * labelVisible : bool
      */
    property bool labelVisible : true

    /**
      * iconSize : int
      */
    property alias iconSize : _template.iconSizeHint

    /**
      * iconVisible : int
      */
    property alias iconVisible : _template.iconVisible

    /**
      * label : string
      */
    property alias label: _template.text1

    /**
      * label2 : string
      */
    property alias label2: _template.text2

    /**
      * iconName : string
      */
    property alias iconName: _template.iconSource

    /**
      * template : ListItemTemplate
      */
    property alias template : _template


    isCurrentItem : ListView.isCurrentItem

    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: hovered
    ToolTip.text: control.label

    Maui.ListItemTemplate
    {
        id: _template
        anchors.fill: parent
        labelsVisible: control.labelVisible
        hovered: control.hovered      
        isCurrentItem: control.isCurrentItem
        highlighted: control.containsPress 
    }
}
