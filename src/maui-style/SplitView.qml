// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui

T.SplitView
{
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    
    clip: true
    focus: true
        
    Component
    {
        id: _horizontalHandleComponent
        
        Rectangle
        {
            implicitWidth: Maui.Handy.isTouch ? 20 : 12
            implicitHeight: Maui.Handy.isTouch ? 20 : 12
            
            color: Maui.Theme.backgroundColor
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
            
            //Maui.Separator
            //{
                //width: parent.width
                //anchors.centerIn: parent
            //}
            
            Rectangle
            {
                property int length: pressed ? 80 : 48
                
                Behavior on length
                {
                    NumberAnimation 
                    {
                        duration: 100
                    }
                }                
                
                Behavior on opacity 
                {
                    NumberAnimation
                    {
                        duration: 100
                    }
                }  
                
                opacity: pressed ? 1 : 0.2
                
                anchors.centerIn: parent
                height: 8
                width: length
                radius: height
                
                color: pressed || control.T.SplitHandle.hovered  ? Maui.Theme.highlightColor : Maui.Theme.textColor
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }                
            }            
        }
    }
    
    Component
    {
        id: _verticalHandleComponent
        
        Rectangle
        {
            implicitWidth: Maui.Handy.isTouch ? 20 : 12
            implicitHeight: Maui.Handy.isTouch ? 20 : 12
            
            color: Maui.Theme.backgroundColor
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }                       
            
            //Maui.Separator
            //{
                //height: parent.height
                //anchors.centerIn: parent
            //}
            
            Rectangle
            {
                property int length: pressed ? 80 : 48
                
                Behavior on length
                {
                    NumberAnimation 
                    {
                        duration: 100
                    }
                }    
                
                Behavior on opacity 
                {
                    NumberAnimation
                    {
                        duration: 100
                    }
                }  
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }
                
                
                opacity: pressed ? 1 : 0.2
                anchors.centerIn: parent
                height: length
                width: 8
                radius: width
                color: pressed || control.T.SplitHandle.hovered ? Maui.Theme.highlightColor : Maui.Theme.textColor
            }
        }
    }
    
    handle: Loader
    {
        //        asynchronous: true
        property bool pressed: T.SplitHandle.pressed
        sourceComponent: control.orientation === Qt.Horizontal ? _verticalHandleComponent : _horizontalHandleComponent
    }
}
