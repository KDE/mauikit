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

import QtQuick
import QtQuick.Window
import QtQuick.Templates as T

import org.mauikit.controls as Maui
import Qt5Compat.GraphicalEffects

T.ComboBox
{
    id: control

    enabled: control.count > 0
    hoverEnabled: !Maui.Handy.isMobile
    
    opacity: control.enabled ? 1 : 0.5
    
    property alias popupContent: _popup.contentItem
    
    //NOTE: typeof necessary to not have warnings on Qt 5.7
    Maui.Theme.colorSet: typeof(editable) != "undefined" && editable ? Maui.Theme.View : Maui.Theme.Button
    Maui.Theme.inherit: false
    
    property alias icon : _icon
    
    readonly property bool responsive: Maui.Handy.isMobile
    
    readonly property size parentWindow : parent.Window.window ? Qt.size(parent.Window.window.width, parent.Window.window.height) : Qt.size(0,0)

    readonly property int preferredWidth : 200
    
    implicitWidth: Math.max(preferredWidth, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitContentHeight, Maui.Style.iconSize) + topPadding + bottomPadding

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    font: Maui.Style.defaultFont
    
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
        y: (control.topPadding + (control.availableHeight - height) / 2) - 2
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
        leftPadding : _icon.visible ? _icon.width + Maui.Style.space.medium : 0
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
        //        cursorDelegate: CursorDelegate { }
        
        Maui.Icon
        {
            id: _icon
            visible: source ? true : false
            height: visible ? Maui.Style.iconSize : 0
            width: height
            color: Maui.Theme.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    background: Rectangle
    {
        radius: Maui.Style.radiusV
        
        color: control.hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor
        
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
            
            onWheel: (wheel) =>
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
        id: _popup
        
        Maui.Theme.colorSet: Maui.Theme.Window
        Maui.Theme.inherit: false
        
        parent: control.responsive ? control.parent.Window.window.contentItem : control

        readonly property int finalY : control.responsive ? control.parentWindow.height - height : ( control.editable ? control.height - 5 : control.height)
        readonly property int preferredWidth: control.responsive ? 600 : 300
        
        y: finalY
        x: control.responsive ? Math.round(control.parentWindow.width/2 - width/2) : 0
        
        implicitWidth:  Math.min(control.parentWindow.width, Math.max(preferredWidth, implicitContentWidth + leftPadding + rightPadding ))
        
        implicitHeight: Math.min(implicitContentHeight + topPadding + bottomPadding, (control.responsive ? control.parentWindow.height *0.7 : control.parentWindow.height))
        
        transformOrigin: Item.Top
        
        padding: 0
        spacing: Maui.Style.defaultSpacing
        
        margins: Maui.Style.space.medium
        
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
            
            model: control.delegateModel
            spacing: control.spacing
            // padding: 0
            currentIndex: control.highlightedIndex
        }
        
        background: Rectangle
        {
            color: _popup.Maui.Theme.backgroundColor
            radius: Maui.Style.radiusV

            Behavior on color
            {
                Maui.ColorTransition{}
                
            }
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
    }
}
