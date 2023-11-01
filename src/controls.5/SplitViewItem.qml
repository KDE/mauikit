// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.3
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

Pane
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

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

    clip: SplitView.view.orientation === Qt.Vertical && SplitView.view.count === 2 && splitIndex > 0

    padding: compact ? 0 : Maui.Style.contentMargins

    Behavior on padding
    {
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InQuad
        }
    }

    property bool compact : Maui.Handy.isMobile || SplitView.view.count === 1

     contentItem: Item
        {
            Item
            {
                anchors.fill: parent
                
                Item
                {
                    id:  _container
                    anchors.fill: parent
                }                
                
                layer.enabled: !control.compact   
                layer.smooth: true
                layer.effect: OpacityMask
                {
                    cached: true
                    maskSource: Rectangle
                    {
                        width: _container.width
                        height: _container.height
                        radius: Maui.Style.radiusV
                    }
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
                        label.text: i18nd("mauikit", "Close Split")
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
                        label.text: i18nd("mauikit", "Close Split")
                    }
                }
            }
            
            MouseArea
            {
                anchors.fill: parent
                propagateComposedEvents: true
                preventStealing: false
                cursorShape: undefined
                
                onPressed: (mouse) =>
                {
                    control.SplitView.view.currentIndex = control.splitIndex
                    mouse.accepted = false
                }
            }
            
            layer.enabled: !control.compact && control.SplitView.view.currentIndex === splitIndex            
            layer.effect: DropShadow
            {
                cached: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 16
                color:  "#80000000"
                smooth: true
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

    function focusSplitItem()
    {
        control.SplitView.view.currentIndex = control.splitIndex
    }
}
