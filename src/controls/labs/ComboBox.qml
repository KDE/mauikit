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
import QtQuick.Window 2.2

import QtQuick.Templates 2.12 as T

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import QtGraphicalEffects 1.0

T.ComboBox
{
    id: control
    
    enabled: control.count > 0
    //NOTE: typeof necessary to not have warnings on Qt 5.7
    Maui.Theme.colorSet: typeof(editable) != "undefined" && editable ? Maui.Theme.View : Maui.Theme.Button
    Maui.Theme.inherit: false
    
    property bool responsive: Kirigami.Settings.hasTransientTouchInput
    
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    
    //    topInset: Maui.Style.space.small
    //    bottomInset: Maui.Style.space.small
    
    spacing: control.responsive ? Maui.Style.space.medium : Maui.Style.space.small
    
    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    
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
    
    indicator: Kirigami.Icon
    {
        x: control.mirrored ? control.padding : control.width - width - control.padding - Maui.Style.space.small
        y: control.topPadding + (control.availableHeight - height) / 2
        color: control.enabled ? control.Maui.Theme.textColor : control.Maui.Theme.highlightColor
        source: "go-down"
        height: Maui.Style.iconSizes.small
        width: height
        Behavior on color
        {
            Maui.ColorTransition{}
        }    
    }
    
    contentItem: T.TextField
    {
        padding: Maui.Style.space.small
        leftPadding: (control.editable ? Maui.Style.space.medium : control.mirrored ? 0 : Maui.Style.space.medium) + control.leftPadding
        rightPadding: (control.editable ? Maui.Style.space.medium : control.mirrored ? Maui.Style.space.medium : 0) + control.rightPadding
        text: control.editable ? control.editText : control.displayText
        
        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
        selectByMouse: !Kirigami.Settings.tabletMode
        
        font: control.font
        color: control.Maui.Theme.textColor
        selectionColor:  control.Maui.Theme.highlightColor
        selectedTextColor: control.Maui.Theme.highlightedTextColor
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1 : 0.5
        //        cursorDelegate: CursorDelegate { }
    }
    
    background: Rectangle
    {
        implicitWidth: 200
        implicitHeight: Maui.Style.rowHeight
        
        radius: Maui.Style.radiusV
        
        color: control.enabled ? (control.editable ? Maui.Theme.backgroundColor : Maui.Theme.backgroundColor) : "transparent"
        
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
        parent: control.responsive ? window() : control
        x: control.responsive ? 0 : 0
        y: control.responsive ? window().height - height : ( control.editable ? control.height - 5 : 0)
        
        implicitWidth: control.responsive ? window().width :  Math.min(window().width,  Math.max(250, contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0))
        
        implicitHeight: control.responsive ? Math.min(window().height * 0.5, contentHeight + Maui.Style.space.huge) :  Math.min(contentHeight + topPadding + bottomPadding, window().height * 0.7)
        
        transformOrigin: Item.Top
        
        spacing: control.spacing
        modal: control.responsive
        margins: 0
        
        padding: 1
        topPadding: control.responsive ? Maui.Style.space.big : Maui.Style.space.medium
        bottomPadding: Maui.Style.space.medium
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }
        
        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
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
            padding: control.margins
            currentIndex: control.highlightedIndex
            topPadding: 0
            bottomPadding: 0
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
            layer.effect: Kirigami.ShadowedRectangle
            {
                color: Maui.Theme.backgroundColor
                shadow.xOffset: 0
                shadow.yOffset: -2
                shadow.color: Qt.rgba(0, 0, 0, 0.3)
                shadow.size: 8
                
                corners
                {
                    topLeftRadius: _bg.radius
                    topRightRadius: _bg.radius
                    bottomLeftRadius: _bg.radius
                    bottomRightRadius: _bg.radius
                }
            }
        }
    }
}
