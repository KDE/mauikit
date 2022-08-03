/****************************************************************************
 * *
 ** Copyright (C) 2017 The Qt Company Ltd.
 ** Contact: http://www.qt.io/licensing/
 **
 ** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
 **
 ** $QT_BEGIN_LICENSE:LGPL3$
 ** Commercial License Usage
 ** Licensees holding valid commercial Qt licenses may use this file in
 ** accordance with the commercial license agreement provided with the
 ** Software or, alternatively, in accordance with the terms contained in
 ** a written agreement between you and The Qt Company. For licensing terms
 ** and conditions see http://www.qt.io/terms-conditions. For further
 ** information use the contact form at http://www.qt.io/contact-us.
 **
 ** GNU Lesser General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU Lesser
 ** General Public License version 3 as published by the Free Software
 ** Foundation and appearing in the file LICENSE.LGPLv3 included in the
 ** packaging of this file. Please review the following information to
 ** ensure the GNU Lesser General Public License version 3 requirements
 ** will be met: https://www.gnu.org/licenses/lgpl.html.
 **
 ** GNU General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU
 ** General Public License version 2.0 or later as published by the Free
 ** Software Foundation and appearing in the file LICENSE.GPL included in
 ** the packaging of this file. Please review the following information to
 ** ensure the GNU General Public License version 2.0 requirements will be
 ** met: http://www.gnu.org/licenses/gpl-2.0.html.
 **
 ** $QT_END_LICENSE$
 **
 ****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Window 2.15
import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.0

T.Menu
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false
    
    property string subtitle
    property string titleImageSource
    property string titleIconSource
    
    readonly property bool responsive: Maui.Handy.isMobile
    
    readonly property size parentWindow : parent.Window.window ? Qt.size(parent.Window.window.width, parent.Window.window.height) : Qt.size(0,0)
    
    transformOrigin: !cascade ? Item.Top : (mirrored ? Item.TopRight : Item.TopLeft)
    
    readonly property int finalY : control.responsive ? parentWindow.height - height : 0
    y: finalY
    
    implicitWidth: control.responsive ? parentWindow.width :  Math.min(parentWindow.width,  Math.max(250, implicitContentWidth + leftPadding + rightPadding ))
    
    implicitHeight: control.responsive ? Math.min(parentWindow.height * 0.8, contentHeight + Maui.Style.space.huge) : implicitContentHeight + topPadding + bottomPadding
    
    focus: true
    modal: control.responsive
    cascade: !control.responsive
    overlap: cascade ? 0-Maui.Style.space.medium : 0
    
    spacing: control.responsive ? Maui.Style.space.medium : Maui.Style.space.small
    
    margins: 0
    rightMargin: leftMargin
    leftMargin: control.margins
    topMargin: control.margins
    bottomMargin: control.margins
    
    padding: control.responsive ? 0 : 1
    topPadding: control.responsive ? Maui.Style.space.big : Maui.Style.space.medium
    bottomPadding: Maui.Style.space.medium
    
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    delegate: MenuItem { }
    
    enter:  Maui.Style.enableEffects ? (control.responsive ? _responsiveEnterTransition : _enterTransition) : null
    exit: Maui.Style.enableEffects ? (control.responsive ? _responsiveExitTransition : _exitTransition) : null
    
    Transition
    {
        id: _enterTransition
        enabled: Maui.Style.enableEffects
        // grow_fade_in
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }
    
    
    Transition
    {
        id: _exitTransition
        enabled: Maui.Style.enableEffects
        
        // shrink_fade_out
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }
    
    Transition
    {
        id: _responsiveEnterTransition
        enabled: Maui.Style.enableEffects
        
        ParallelAnimation
        {
            //NumberAnimation { property: "y"; from: control.parentWindow.height; to: control.finalY; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }
    }
    
    Transition
    {
        id: _responsiveExitTransition
        enabled: Maui.Style.enableEffects
        
        ParallelAnimation
        {
            //NumberAnimation { property: "y"; from: control.finalY; to: control.parentWindow.height; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }
    }
    
    contentItem: Maui.ScrollView
    {
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        focus: true
        padding: Maui.Style.space.small
        
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
                height: visible ? 64 : 0
                padding: control.padding
              bottomPadding: control.topPadding + padding
              
                width: parent.width
//                 
//                            background: Rectangle
//                            {
//                                color: "pink"
//                                Maui.Separator
//                                {
//                                    width: parent.width
//                                    anchors.bottom: parent.bottom
//                                }
//                            }
                
                contentItem: Maui.ListItemTemplate
                {
                    label1.font.bold: true
                    label1.text: control.title
                    label2.text: control.subtitle
                    label1.font.pointSize: Maui.Style.fontSizes.big
                    label1.elide:Text.ElideMiddle
                    imageSource: control.titleImageSource
                    iconSource: control.titleIconSource
                    maskRadius: Maui.Style.radiusV
                    imageSizeHint: 42
                    iconSizeHint: 32
                }
            }
        }
    }
    
    background: Rectangle
    {
        id: _bg
        implicitWidth: Maui.Style.units.gridUnit * 8
        color: control.Maui.Theme.backgroundColor
        radius: control.responsive ? 0 : Maui.Style.radiusV
        property color borderColor: Maui.Theme.textColor
        
        border.color: control.responsive ? "transparent" : Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.2)
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Behavior on border.color
        {
            Maui.ColorTransition{}
        }
        
        Maui.Separator
        {
            visible: control.responsive
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            weight: Maui.Separator.Weight.Light
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
    
    T.Overlay.modal: Rectangle
    {
        color: Qt.rgba( control.Maui.Theme.backgroundColor.r,  control.Maui.Theme.backgroundColor.g,  control.Maui.Theme.backgroundColor.b, 0.4)
        
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
    
    T.Overlay.modeless: Rectangle
    {
        color: Qt.rgba( control.Maui.Theme.backgroundColor.r,  control.Maui.Theme.backgroundColor.g,  control.Maui.Theme.backgroundColor.b, 0.4)
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
    
    onOpened: _listView.forceActiveFocus()
    
}
