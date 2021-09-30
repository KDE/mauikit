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

pragma Singleton

import QtQuick 2.14
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

/**
 * Style
 * Preferred units and sizes to follow the Maui HIG
 *
 */
QtObject
{
    /**
      * radiusV : int
      */
    property int radiusV : Maui.Handy.isWindows ? 2 : 4

    /**
      * rowHeight : int
      */
    readonly property int rowHeight: 32


    /**
      * rowHeightAlt : int
      */
    readonly property int rowHeightAlt: 28

    /**
      * contentMargins : int
      */
    readonly property int contentMargins: space.medium

    /**
      * toolBarHeight : int
      */
    readonly property int toolBarHeight: 48 

    /**
      * toolBarHeightAlt : int
      */
    readonly property int toolBarHeightAlt: 40

    /**
      * defaultFontSize : int
      */
    readonly property int defaultFontSize: Kirigami.Theme.defaultFont.pointSize

    /**
      * fontSizes : var
      */
    readonly property QtObject fontSizes : QtObject {
        property int tiny: Math.round(defaultFontSize * 0.7)
        property int small: Math.round(defaultFontSize * 0.8)
        property int medium: defaultFontSize
        property int big: Math.round(defaultFontSize * 1.1)
        property int large: Math.round(defaultFontSize * 1.2)
        property int huge: Math.round(defaultFontSize * 1.3)
        property int enormous: Math.round(defaultFontSize * 1.4)
    }

    /**
      * space : var
      */
    readonly property QtObject space: QtObject {
        property int tiny: Kirigami.Units.smallSpacing
        property int small: Kirigami.Units.smallSpacing*2
        property int medium: Kirigami.Units.largeSpacing
        property int big: Kirigami.Units.largeSpacing*2
        property int large: Kirigami.Units.largeSpacing*3
        property int huge: Kirigami.Units.largeSpacing*4
        property int enormous: Kirigami.Units.largeSpacing*5
    }

    /**
      * iconSizes : QtObject
      */    
    readonly property QtObject iconSizes: QtObject {
        property int tiny : 8
        property int small: 16
        property int medium: 22
        property int big: 32
        property int large: 48
        property int huge: 64
        property int enormous: 128
    }
    
     function mapToIconSizes(size)
    {
        const values = Object.values(iconSizes);

        var closest = values.reduce(function(prev, curr) {
            return (Math.abs(curr - size) < Math.abs(prev - size) ? curr : prev);
        });
        console.log(size, closest)
        return closest;
    }  
}
