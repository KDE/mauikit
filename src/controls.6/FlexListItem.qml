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

import org.mauikit.controls 1.2 as Maui

import QtQuick.Templates 2.15 as T

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs

  A template to position text besides an icon or image with a flex content side, that flexes under constrained spaces.
*/
T.ItemDelegate
{
    id: control

    /**
      *
      */
    // default property alias content : _content.data
     default property alias content : _layout.data
       
        
    /**
      *
      */
    property alias template: _template

    /**
      *
      */
    property alias label1 : _template.label1

    /**
      *
      */
    property alias label2 : _template.label2

    /**
      *
      */
    property alias label3 : _template.label3

    /**
      *
      */
    property alias label4 : _template.label4

    /**
      *
      */
    property alias iconSource : _template.iconSource

    /**
      *
      */
    property alias imageSource : _template.imageSource

    /**
      *
      */
    property alias iconSizeHint : _template.iconSizeHint

    /**
      *
      */
    property bool wide : _layout.children[1] ? _layout.children[1].implicitWidth < _layout.width*0.5 : true

    property alias rowSpacing : _layout.rowSpacing

    property alias columnSpacing: _layout.columnSpacing    
    
    property alias columns: _layout.columns
    property alias rows: _layout.rows    

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    background: null
    
    spacing: Maui.Style.defaultSpacing
    
    contentItem: GridLayout
    {
        id: _layout
        
        rowSpacing: control.spacing
        columnSpacing: control.spacing
        
        columns: control.wide ? 2 : 1
        
        Maui.ListItemTemplate
        {
            id: _template
            Layout.fillWidth: true
            iconSizeHint: Maui.Style.iconSizes.medium
            label2.wrapMode: Text.WordWrap
            label1.font.weight: Font.Medium
        }
    }
}
