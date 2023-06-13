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

import QtQuick
import QtQuick.Templates as T
import QtQuick.Window
import org.mauikit.controls as Maui
import Qt5Compat.GraphicalEffects

T.Menu
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false
    
    property string subtitle
    property string titleImageSource
    property string titleIconSource: "application-menu"
    
    readonly property bool responsive: Maui.Handy.isMobile
    
    readonly property size parentWindow : parent.Window.window ? Qt.size(parent.Window.window.width, parent.Window.window.height) : Qt.size(0,0)
    
    transformOrigin: !cascade ? Item.Top : (mirrored ? Item.TopRight : Item.TopLeft)
    
    readonly property int finalY : control.responsive ? parentWindow.height - height : 0
    readonly property int preferredWidth: control.responsive ? 600 : 300

    y: finalY
    x: control.responsive ? Math.round(parentWindow.width/2 - control.width/2) : 0
    
    implicitWidth: Math.min(parentWindow.width, preferredWidth)
    
    implicitHeight: Math.min(contentHeight + topPadding + bottomPadding, (control.responsive ? parentWindow.height *0.7 : parentWindow.height))
    
    focus: true
    
    modal: control.responsive
    cascade: !control.responsive
    overlap: cascade ? 0-Maui.Style.space.medium : 0
    
    padding: 0
    spacing: Maui.Style.defaultSpacing
    
    margins: Maui.Style.space.medium
    
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
    
    contentItem: ScrollView
    {
        focus: true
        contentWidth: availableWidth
        padding: Maui.Style.contentMargins

        implicitHeight: _listView.contentHeight + topPadding+bottomPadding

        ListView
        {
            id: _listView

            clip: true
            focus: true

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

            header: Maui.SectionHeader
            {
                visible: control.title && control.title.length
                width: parent.width
                height: visible ? implicitContentHeight + topPadding + bottomPadding : 0
                padding: control.padding
                bottomPadding: padding * 2
                topPadding: 0

                label1.text: control.title
                label2.text: control.subtitle
                label1.elide:Text.ElideMiddle
                template.imageSource: control.titleImageSource
                template.iconSource: control.titleIconSource
                template.maskRadius: 0
                template.imageSizeHint: Maui.Style.iconSizes.big
                template.iconSizeHint: Maui.Style.iconSize
            }
        }
    }
    
    
    background: Rectangle
    {
        color: control.Maui.Theme.backgroundColor
        radius: Maui.Style.radiusV

        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Behavior on border.color
        {
            Maui.ColorTransition{}
        }
        
        layer.enabled: true
        layer.effect: DropShadow
        {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8
            samples: 16
            color: "#80000000"
            transparentBorder: true
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
