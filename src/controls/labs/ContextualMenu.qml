// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Controls 2.15

import QtQuick.Templates 2.15 as T

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

T.Menu
{
    id: control
    
    property bool responsive: Kirigami.Settings.hasTransientTouchInput
    
    
    parent: control.responsive ?  window() : undefined
    
    x: control.responsive ? 0 : 0
    y: control.responsive ? window().height - height : 0
    
    implicitWidth: control.responsive ? window().width :  Math.min(window().width,  Math.max(250, contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0))
    
    implicitHeight: control.responsive ? Math.min(window().height * 0.5, contentHeight + Maui.Style.space.huge) :  Math.min(contentHeight + topPadding + bottomPadding, window().height * 0.7)
    
    modal: control.responsive
    
    spacing: control.responsive ? Maui.Style.space.medium : Maui.Style.space.small
    
    margins: 0
    
    padding: 1
    topPadding: control.responsive ? Maui.Style.space.big : Maui.Style.space.medium
    bottomPadding: Maui.Style.space.medium
    
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    delegate: MenuItem {}

    contentItem: Maui.ListBrowser
    {
        id: _listView
        clip: true
        
        implicitWidth: {
            var maxWidth = 0;
            for (var i = 0; i < contentItem.children.length; ++i) {
                maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
            }
            return Math.min(250, maxWidth);
        }
        
        implicitHeight: contentHeight
        model: control.contentModel
        spacing: control.spacing
        padding: control.margins
        currentIndex: control.currentIndex || 0
    }
    
    background: Rectangle
    {
        id: _bg
        implicitWidth: Kirigami.Units.gridUnit * 8
        color: control.Kirigami.Theme.backgroundColor
        radius: control.responsive ? 0 : Maui.Style.radiusV
        
        readonly property color m_color : Qt.darker(Kirigami.Theme.backgroundColor, 2.2)
        border.color: control.responsive ? "transparent" : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.7)
        
        Rectangle
        {
            visible: !control.responsive
            anchors.fill: parent
            anchors.margins: 1
            color: "transparent"
            radius: parent.radius - 0.5
            border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
            opacity: 0.7
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

        layer.enabled: control.responsive
        layer.effect: Kirigami.ShadowedRectangle
        {
            color: Kirigami.Theme.backgroundColor
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
    
    
    
    //enter: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: window().height
    //to: window().height - _menu.height
    //duration: Kirigami.Units.shortDuration
    //easing.type: Easing.OutCubic
    //}
    //}
    
    //exit: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: _menu.y
    //to: window().height
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
}

