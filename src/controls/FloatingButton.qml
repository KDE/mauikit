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

import QtQuick 2.10
import QtQuick.Controls 2.10

import org.mauikit.controls 1.0 as Maui

import QtGraphicalEffects 1.0

/**
 * FloatingButton
 * A styled button to be used above other elements.
 *
 */
ToolButton
{
  id: control
  
  padding: Maui.Style.space.big
  
  icon.height: Maui.Style.iconSize
  icon.width: Maui.Style.iconSize
  
  icon.color: Maui.Theme.highlightedTextColor
  
  display: ToolButton.IconOnly
  
  background: Rectangle
  {
    id: _rec
    radius: Maui.Style.radiusV
    color: control.hovered || control.pressed ? Qt.lighter( Maui.Theme.highlightColor, 1.2) :   Maui.Theme.highlightColor
  }
  
  layer.enabled: true
  layer.effect: DropShadow
  {
    id: rectShadow
    cached: true
    horizontalOffset: 0
    verticalOffset: 0
    radius: 8.0
    samples: 16
    color:  "#80000000"
    smooth: true
  }
}
