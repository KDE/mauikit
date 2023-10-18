// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls
import QtQml.Models
import Qt5Compat.GraphicalEffects

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Controls.Pane
 * @brief An item to be used as a view container for the MauiKit SplitView.
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-pane.html">This controls inherits from QQC2 Pane, to checkout its inherited properties refer to the Qt Docs.</a>
 * This is the preferred control to use when adding a new view into the SplitView, since it follows the Maui Style HIG.
 * @see SplitView
 * 
 * @note When this element is being resized by the SplitView handle, and reaches the minimum width, an action to close the view is then suggested and triggered if the pressed event of the handle is released at that minimum width.
 */
Pane
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false
    
    /**
     * @brief By default the children content of this item needs to be positioned manually.
     * @property list<QtObject> SplitViewItem::content
     */
    default property alias content: _container.data
        
        /**
         * @brief The index of this view in the SplitView control.
         */
        readonly property int splitIndex : ObjectModel.index
        
        /**
         * @brief The minimum width of this view when resizing the SplitView.
         * By default this is set to a fixed value of `200`.
         */
        property int minimumWidth : 200
        
        /**
         * @brief The minimum height of this view when resizing the SplitView.
         * By default this is set to a fixed value of `100`.
         */
        property int minimumHeight : 100
        
        /**
         * @brief Whether the style of this view will be more compact. A compact style has not border corners or styling.
         * While a non-compact mode means there is more than on view in the parent SplitView and the views will have rounded corners.
         * This is `true` for mobile devices and one there is a single item in the SplitView.
         */
        readonly property bool compact : Maui.Handy.isMobile || SplitView.view.count === 1
        
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
        
        /**
         * @brief Forces to focus this item in the SplitView, and marks it as the current view.
         */
        function focusSplitItem()
        {
            control.SplitView.view.currentIndex = control.splitIndex
        }
}
