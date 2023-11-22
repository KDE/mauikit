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
    
    isDialog: true
    
    /**
     * @brief The default content of this dialog window. This is handled by a MauiKit Page
     * @property list<QtObject> DialogWindow::content
     */
    default property alias content : _page.content
        
        /**
         * @brief An alias to the MauiKit Page filling the dialog window. All the children content of this control will be parented by the Page.
         * @property Page DialogWindow::page
         */
        readonly property alias page: _page
        maximumWidth: 900
        
        Maui.Page
        {
            id: _page
            anchors.fill: parent
            title: control.title
            Maui.Controls.showCSD: true
            Maui.Theme.inherit: true
        }
}
