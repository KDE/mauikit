// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.3

import org.kde.kirigami 2.8 as Kirigami
import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    
    default property alias content: _container.data

    // the index of the item in the split view layout
    readonly property int splitIndex : ObjectModel.index
    
    property int minimumWidth : 200
    property int minimumHeight : 100
    
    SplitView.fillHeight: true
    SplitView.fillWidth: true
    
    SplitView.preferredHeight: SplitView.view.orientation === Qt.Vertical ? SplitView.view.height / (SplitView.view.count) :  SplitView.view.height
    SplitView.minimumHeight: SplitView.view.orientation === Qt.Vertical ?  minimumHeight : 0
    
    SplitView.preferredWidth: SplitView.view.orientation === Qt.Horizontal ? SplitView.view.width / (SplitView.view.count) : SplitView.view.width
    SplitView.minimumWidth: SplitView.view.orientation === Qt.Horizontal ? minimumWidth :  0
    
    opacity: SplitView.view.currentIndex === splitIndex ? 1 : 0.7
    
    Item
    {
        id:  _container
        anchors.fill: parent
    }
    
    Loader
    {
        asynchronous: true
        anchors.fill: parent
        active: control.SplitView.view.resizing 
        visible: active
        sourceComponent: Rectangle
        {
            
            color: Maui.Theme.backgroundColor
            opacity: (control.minimumWidth) / control.width
        }
    }
    
    Loader
    {
        asynchronous: true
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        active: control.SplitView.view.currentIndex === splitIndex && control.SplitView.view.count > 1
        visible: active
        sourceComponent: Rectangle
        {
            
            color: Maui.Theme.highlightColor
        }
    }
    
    Loader
    {
        asynchronous: true
        anchors.centerIn: parent
        active: control.SplitView.view.resizing && control.width < control.minimumWidth + 60
        visible: active
        sourceComponent: Maui.Chip
        {
            opacity: (control.minimumWidth) / control.width
            
            Maui.Theme.backgroundColor: Maui.Theme.negativeTextColor
            label.text: i18n("Close Split")
        }
    }
    
    Loader
    {
        asynchronous: true
        anchors.centerIn: parent
        active: control.SplitView.view.resizing && control.height < control.minimumHeight + 60
        visible: active
        sourceComponent: Maui.Chip
        {
            opacity: (control.minimumHeight) / control.height
            
            Maui.Theme.backgroundColor: Maui.Theme.negativeTextColor
            label.text: i18n("Close Split")
        }
    }
    
    
    Connections
    {
        target: control.SplitView.view
        function onResizingChanged()
        {
            if(control.width === control.minimumWidth && !control.SplitView.view.resizing)
            {
                control.SplitView.view.closeSplit(control.splitIndex)
            }
            
            if(control.height === control.minimumHeight && !control.SplitView.view.resizing)
            {
                control.SplitView.view.closeSplit(control.splitIndex)
            }
        }
    }
    
    MouseArea
    {
        anchors.fill: parent
        propagateComposedEvents: true
        //        hoverEnabled: true
        //        onEntered: _splitView.currentIndex = control.index
        onPressed:
        {
            control.SplitView.view.currentIndex = control.splitIndex
            mouse.accepted = false
        }
    }
    
    function focusSplitItem()
    {
        control.SplitView.view.currentIndex = control.splitIndex
    }    
}
