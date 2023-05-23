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

import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

ScrollView
{
    id: control

    default property alias content : _pageContent.data
        property alias container : _pageContent
    property alias flickable: _flickable

    padding: Maui.Style.contentMargins

    contentWidth: availableWidth
    contentHeight: _pageContent.implicitHeight
    
    implicitHeight: contentHeight + topPadding + bottomPadding

    spacing: Maui.Style.defaultSpacing
    
    Flickable
    {
        id: _flickable
        boundsBehavior: Flickable.StopAtBounds
        boundsMovement: Flickable.StopAtBounds

        ColumnLayout
        {
            id: _pageContent
            width: parent.width
            spacing: control.spacing
        }
    }
}

