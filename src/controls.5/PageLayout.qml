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
    
    property list<QtObject> leftContent
    
    property list<QtObject> rightContent 
    
    // property alias middleContent : control.headBar.middleContent
    
    property bool split : false
    property int splitIn : ToolBar.Header
    
    headBar.forceCenterMiddleContent: !control.split
    headBar.leftContent: !control.split && control.leftContent ? control.leftContent : null
    headBar.rightContent: !control.split && control.rightContent ? control.rightContent : null    
    
    // headBar.middleContent: control.middleContent ? control.middleContent : null
    
    headerColumn: Loader
    {
        active: control.splitIn === ToolBar.Header 
        visible: control.split && control.splitIn === ToolBar.Header
        width: parent.width
        asynchronous: true
        
        sourceComponent: Maui.ToolBar
    {        
        leftContent: control.split && control.leftContent ? control.leftContent : null    
        rightContent: control.split && control.rightContent ? control.rightContent : null        
    }
    }
    
    footerColumn: Loader
    {
        active: control.splitIn === ToolBar.Footer
        visible: control.split && control.splitIn === ToolBar.Footer
        width: parent.width
        asynchronous: true

        sourceComponent: Maui.ToolBar
        {            
            leftContent: control.split && control.leftContent ? control.leftContent : null    
            rightContent: control.split && control.rightContent ? control.rightContent : null        
        }
    }
}
