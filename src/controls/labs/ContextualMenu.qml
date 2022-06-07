// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import QtQuick.Templates 2.15 as T
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami


T.Menu
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false
    
    property bool responsive: true
    
    property string subtitle
    property string titleImageSource
    property string titleIconSource
    
    readonly property size parentWindow : parent.Window.window ? Qt.size(parent.Window.window.width, parent.Window.window.height) : Qt.size(0,0)
    
    //parent: control.responsive ?  parent.Window.window : undefined
    
    //     x: control.responsive ? 0 : 0
    y: control.responsive ? parentWindow.height - height : 0
    
    implicitWidth: control.responsive ? parentWindow.width :  Math.min(parentWindow.width,  Math.max(250, implicitContentWidth + leftPadding + rightPadding ))
    
    implicitHeight: control.responsive ? Math.min(parentWindow.height * 0.8, contentHeight + Maui.Style.space.huge) : implicitContentHeight + topPadding + bottomPadding
    
    focus: true
    modal: control.responsive
    
    spacing: control.responsive ? Maui.Style.space.medium : Maui.Style.space.small
    
    margins: 0
    rightMargin: leftMargin
    leftMargin: control.responsive ? Maui.Style.space.medium : control.margins
    topMargin: control.margins
    bottomMargin: control.margins
    
    padding: 1
    topPadding: control.responsive ? Maui.Style.space.big : Maui.Style.space.medium
    bottomPadding: Maui.Style.space.medium
    
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    delegate: MenuItem {}
    
    
    //Keys.forwardTo: _listView    
    
    contentItem: ScrollView
    {
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        focus: true
        
        ListView
        {
            id: _listView
            clip: true       
            focus: true 
            implicitHeight: contentHeight
            
            headerPositioning: ListView.InlineHeader
            
            model: control.contentModel
            spacing: control.spacing
            currentIndex: control.currentIndex 
            
            snapMode: ListView.NoSnap
            
            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration : 0
            
            keyNavigationEnabled : true
            keyNavigationWraps : true
            
            header: T.Control
            {
                visible: control.title && control.title.length
                height: visible ?  48 + topPadding + bottomPadding : 0
                padding: Maui.Style.space.tiny
                topPadding: 0
                bottomPadding: control.bottomPadding
                
                width: parent.width
                
                //            background: Item
                //            {
                //                Maui.Separator
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
                    label1.font.pointSize: Maui.Style.fontSizes.large
                    imageSource: control.titleImageSource
                    iconSource: control.titleIconSource
                    maskRadius: Maui.Style.radiusV
                    imageSizeHint: 42
                    iconSizeHint: 32                
                }
            }
        }
    }
    
    background: Kirigami.ShadowedRectangle
    {
        id: _bg
        implicitWidth: Maui.Style.units.gridUnit * 8
        color: control.Maui.Theme.backgroundColor
        
        corners
        {
            topLeftRadius:  control.responsive ? Maui.Style.radiusV : Maui.Style.radiusV
            topRightRadius:  control.responsive ? Maui.Style.radiusV : Maui.Style.radiusV
            bottomLeftRadius:  control.responsive ? 0 :  Maui.Style.radiusV
            bottomRightRadius: control.responsive ? 0 :  Maui.Style.radiusV
        }      
        
        property color borderColor: Maui.Theme.textColor
        
        border.color:  Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.2)
        
        shadow.xOffset: 0
        shadow.yOffset: 0
        shadow.color: Qt.rgba(0, 0, 0, 0.5)
        shadow.size: 10
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Behavior on border.color
        {
            Maui.ColorTransition{}
        }
    }
    
    //enter: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: ApplicationWindow.overlay.height
    //to: ApplicationWindow.overlay.height - _menu.height
    //duration: Maui.Style.units.shortDuration
    //easing.type: Easing.OutCubic
    //}
    //}
    
    //exit: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: _menu.y
    //to: ApplicationWindow.overlay.height
    //duration: Maui.Style.units.shortDuration
    
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
    
    onOpened: _listView.forceActiveFocus()
}

