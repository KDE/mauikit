/****************************************************************************
**
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

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

import org.mauikit.controls 1.2 as Maui
import QtGraphicalEffects 1.0

T.ComboBox
{
    id: control

    enabled: control.count > 0
    hoverEnabled: !Maui.Handy.isMobile
    
    opacity: control.enabled ? 1 : 0.5
    
    //NOTE: typeof necessary to not have warnings on Qt 5.7
    Maui.Theme.colorSet: typeof(editable) != "undefined" && editable ? Maui.Theme.View : Maui.Theme.Button
    Maui.Theme.inherit: false
    
    hoverEnabled: !Maui.Handy.isMobile
    opacity: enabled ? 1 : 0.5

    readonly property bool responsive: Maui.Handy.isMobile
    readonly property size parentWindow : parent.Window.window ? Qt.size(parent.Window.window.width, parent.Window.window.height) : Qt.size(0,0)
    
    
    readonly property int preferredWidth : 200
    readonly property int preferredHeight : Maui.Style.rowHeight
    
    implicitWidth: Math.max(preferredWidth, implicitContentWidth + leftPadding + rightPadding)    
    implicitHeight: Math.max(preferredHeight,implicitContentHeight + topPadding + bottomPadding)
        
    spacing: Maui.Style.space.small
    padding: Maui.Style.space.medium
    
           delegate: MenuItem
    {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        //        Material.foreground: control.currentIndex === index ? parent.Material.accent : parent.Material.foreground
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
        Maui.Theme.colorSet: control.Maui.Theme.inherit ? control.Maui.Theme.colorSet : Maui.Theme.View
        Maui.Theme.inherit: control.Maui.Theme.inherit
        
    }
    
    indicator: Maui.Icon
    {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding 
        y: control.topPadding + (control.availableHeight - height) / 2
        color: Maui.Theme.textColor
        source: "qrc:/assets/arrow-down.svg"
        height: 8
        width: 8
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }    
    }    

    contentItem: T.TextField
    {
        padding: 0
        leftPadding : 0
        rightPadding: control.indicator ? control.indicator.width : 0
        text: control.editable ? control.editText : control.displayText
        
        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
        selectByMouse: !Maui.Handy.isMobile
        
        font: control.font
        color: Maui.Theme.textColor
        selectionColor:  control.Maui.Theme.highlightColor
        selectedTextColor: control.Maui.Theme.highlightedTextColor
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1 : 0.5
        //        cursorDelegate: CursorDelegate { }
    }
    
    background: Rectangle
    {
        
        radius: Maui.Style.radiusV
        
        color: control.enabled ? (control.hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor) : "transparent"
        
        border.color: control.enabled ? ( control.editable && control.activeFocus ? Maui.Theme.highlightColor : color) : Maui.Theme.backgroundColor
        
        MouseArea
        {
            property int wheelDelta: 0
            
            anchors
            {
                fill: parent
                leftMargin: control.leftPadding
                rightMargin: control.rightPadding
            }
            
            acceptedButtons: Qt.NoButton
            
            onWheel:
            {
                var delta = wheel.angleDelta.y || wheel.angleDelta.x
                wheelDelta += delta;
                // magic number 120 for common "one click"
                // See: https://doc.qt.io/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                while (wheelDelta >= 120) {
                    wheelDelta -= 120;
                    control.decrementCurrentIndex();
                }
                while (wheelDelta <= -120) {
                    wheelDelta += 120;
                    control.incrementCurrentIndex();
                }
            }
        }
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
    }

    
    popup: T.Popup
    {
        parent: control.responsive ? control.parent.Window.window.contentItem : control
        x: 0
        y: control.responsive ? parentWindow.height - height : ( control.editable ? control.height - 5 : 0)
        
        implicitWidth: control.responsive ? parentWindow.width :  Math.min(parentWindow.width,  Math.max(250, implicitContentWidth + leftPadding + rightPadding ))
        
        implicitHeight: control.responsive ? Math.min(parentWindow.height * 0.8, contentHeight + Maui.Style.space.huge) : implicitContentHeight + topPadding + bottomPadding
        
        transformOrigin: Item.Top
        
        spacing: control.spacing
        modal: control.responsive
        margins: 0        
        
        padding: control.responsive ? 0 : 1
        topPadding: control.responsive ? Maui.Style.space.big : Maui.Style.space.medium
        bottomPadding: Maui.Style.space.medium
        
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
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
        
        contentItem: Maui.ListBrowser
        {
            clip: true
            
            implicitWidth: {
                var maxWidth = 0;
                for (var i = 0; i < contentItem.children.length; ++i) {
                    maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
                }
                return Math.min(250, maxWidth);
            }
            
            implicitHeight: contentHeight
            model: control.delegateModel
            spacing: control.spacing
            padding: Maui.Style.space.small
            currentIndex: control.highlightedIndex
        }
        
        background: Rectangle
        {
            id: _bg
            implicitWidth: Maui.Style.units.gridUnit * 8
            color: control.Maui.Theme.backgroundColor
            radius: control.responsive ? 0 : Maui.Style.radiusV
            
            readonly property color m_color : Qt.darker(Maui.Theme.backgroundColor, 2.2)
            border.color: control.responsive ? "transparent" : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.7)
            
            Behavior on color
            {
                Maui.ColorTransition{}
                
            }
            Rectangle
            {
                visible: !control.responsive
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                radius: parent.radius - 0.5
                border.color: Qt.lighter(Maui.Theme.backgroundColor, 2)
                opacity: 0.7
            }
            
            Maui.Separator
            {
                visible: control.responsive
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 0.5
                weight: Maui.Separator.Weight.Light
            }
            
            layer.enabled: control.responsive
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
    }
}
