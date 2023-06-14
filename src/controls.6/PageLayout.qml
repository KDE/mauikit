/*
 *   Copyright 2019 Camilo Higuita <milo.h@aol.com>
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
import QtQml
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

Maui.Page
{
    id: control

    property Component leftComponent : null
    property Component rightComponent : null
    property Component middleComponent: null

    property bool mobile : false

    headBar.forceCenterMiddleContent: !control.mobile
    headBar.leftContent: Loader
    {
        active: !control.mobile && control.leftComponent
        asynchronous: true
        visible: active
        sourceComponent: control.leftComponent
    }

    headBar.rightContent: Loader
    {
        active: !control.mobile && control.rightComponent
        asynchronous: true
        visible: active
        sourceComponent: control.rightComponent
    }

    headBar.middleContent: Loader
    {
        asynchronous: true
        active: control.middleComponent
        visible: active
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        sourceComponent: control.middleComponent
    }

    headerColumn: Maui.ToolBar
    {
        visible: control.mobile
        width: parent.width

        leftContent: Loader
        {
            active: control.mobile && control.leftComponent
            asynchronous: true
            visible: active
            sourceComponent: control.leftComponent
        }

        rightContent: Loader
        {
            active: control.mobile && control.rightComponent
            asynchronous: true
            visible: active
            sourceComponent: control.rightComponent
        }
    }

}
