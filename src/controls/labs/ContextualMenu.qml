// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Controls 2.15

import QtQuick.Templates 2.15 as T
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

T.Menu
{
    id: control
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    
    property bool responsive: Kirigami.Settings.hasTransientTouchInput
    
    property string subtitle
    property string titleImageSource
    property string titleIconSource
    
    parent: control.responsive ?  ApplicationWindow.overlay : undefined
    
    //     x: control.responsive ? 0 : 0
    y: control.responsive ? ApplicationWindow.overlay.height - height : 0
    
    implicitWidth: control.responsive ? ApplicationWindow.overlay.width :  Math.min(ApplicationWindow.overlay.width,  Math.max(250, implicitContentWidth + leftPadding + rightPadding ))
    
    implicitHeight: control.responsive ? Math.min(ApplicationWindow.overlay.height * 0.8, contentHeight + Maui.Style.space.huge) :  Math.min(implicitContentHeight + topPadding + bottomPadding, ApplicationWindow.overlay.height * 0.9)
    
    focus: true
    modal: control.responsive
    
    spacing: control.responsive ? Maui.Style.space.medium : Maui.Style.space.small
    
    margins: 0
    rightMargin: control.margins
    leftMargin: control.margins
    topMargin: control.margins
    bottomMargin: control.margins
    
    padding: 0
    topPadding: control.responsive ? Maui.Style.space.big : Maui.Style.space.medium
    bottomPadding: Maui.Style.space.medium
    
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    delegate: MenuItem {}
    
    Keys.forwardTo: _listView
    
    
    contentItem: Maui.ListBrowser
    {
        id: _listView
        clip: true       
        focus: true 
        
        flickable.header: Control
        {
            visible: control.title && control.title.length
            height: visible ?  48 + topPadding + bottomPadding : 0
            padding: Maui.Style.space.tiny
            topPadding: 0
            bottomPadding: control.bottomPadding
            
            width: parent.width
            
            //            background: Item
            //            {
            //                Kirigami.Separator
            //                {
            //                    width: parent.width
            //                    anchors.bottom: parent.bottom
            //                }
            //            }
            
            contentItem: Maui.ListItemTemplate
            {
                label1.font.bold: true
                label1.text: control.title
                label2.text: control.subtitle
                imageSource: control.titleImageSource
                iconSource: control.titleIconSource
                maskRadius: Maui.Style.radiusV
                imageSizeHint: 42
                iconSizeHint: 32
                
            }
        }
        
        flickable.headerPositioning: ListView.InlineHeader
        
        //         implicitWidth: 
        //         {
        //             var maxWidth = 0;
        //             for (var i = 0; i < control.contentItem.children.length; ++i) {
        //                 maxWidth = Math.max(maxWidth, control.contentItem.children[i].implicitWidth);
        //             }
        //             return Math.min(250, maxWidth);
        //         }
        
        implicitHeight: contentHeight
        model: control.contentModel
        spacing: control.spacing
        padding: 0
        currentIndex: control.currentIndex || 0
    }
    
    background: Rectangle
    {
        id: _bg
        implicitWidth: Kirigami.Units.gridUnit * 8
        color: control.Kirigami.Theme.backgroundColor
        radius: control.responsive ? 0 : Maui.Style.radiusV
        border.color: control.responsive ? "transparent" : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15);
        
        Behavior on color
        {
            ColorAnimation
            {
                easing.type: Easing.InQuad
                duration: Kirigami.Units.shortDuration
            }
        }
        Kirigami.Separator
        {
            visible: control.responsive
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 0.5
            weight: Kirigami.Separator.Weight.Light
        }
        
        layer.enabled: true
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
    
    //enter: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: ApplicationWindow.overlay.height
    //to: ApplicationWindow.overlay.height - _menu.height
    //duration: Kirigami.Units.shortDuration
    //easing.type: Easing.OutCubic
    //}
    //}
    
    //exit: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: _menu.y
    //to: ApplicationWindow.overlay.height
    //duration: Kirigami.Units.shortDuration
    
    //easing.type: Easing.OutCubic
    //}
    //}
    
    
    function show(x, y, parent)
    {
        if (control.responsive)
        {
            control.open()
        }
        else
        {
            control.popup(parent,x ,y)
        }
    }
    
    onOpened: control.forceActiveFocus()
}

