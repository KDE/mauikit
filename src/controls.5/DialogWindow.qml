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

import QtQuick 

import QtQuick.Controls

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/**
 * @inherit QtQuick.Window
 * @brief A window that provides some basic features needed for most applications.
 */

Private.BaseWindow
{
    id: control
    
    flags: Maui.CSD.enabled ? (Qt.FramelessWindowHint | Qt.Dialog ): (Qt.Dialog & ~Qt.FramelessWindowHint)
    
    
    /***************************************************/
    /********************* COLORS *********************/
    /*************************************************/
    Maui.Theme.colorSet: Maui.Theme.View         
    
    default property alias content : _page.content
        readonly property alias page: _page
        // maximumHeight: 700
        maximumWidth: 900
        
        Maui.Page
        {
            id: _page
             anchors.fill: parent
             title: control.title
        Maui.Controls.showCSD: true
        }
}
