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

import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T
import QtGraphicalEffects 1.15

import org.mauikit.controls 1.3 as Maui

Maui.Page
{
id: control    

property Component leftComponent : null
property Component rightComponent : null
property Component middleComponent: null

property bool mobile : false

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
    sourceComponent: control.leftComponent
}

headBar.middleComponent: Loader
{
    asynchronous: true
    active: control.middleComponent
    visible: active
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
        sourceComponent: control.leftComponent
    }    
}

}
