// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Layouts 1.10
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import QtQuick.Window 2.15

Container
{
    id: control
    visible: _loader.item ? _loader.item.visible : false
    spacing: Maui.Style.space.medium

    property bool responsive: Kirigami.Settings.isMobile
    
    signal opened()
    
    contentItem: Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
        sourceComponent: control.responsive ? mobileMenu : regularMenu
    }
    
    Connections
    {
        target : _loader.item
        function onOpened()
        {
            control.opened()
        }
    }
    
    Component
    {
        id: regularMenu
        
        Menu
        {
            id: _menu
            implicitWidth: Math.max(250,
                                    contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0)
            implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                     contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding
            
            margins: 0
            padding: 0
            spacing: 0
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
//            modal: true

            contentItem: ListView
            {
                id: _listView
                implicitHeight: contentHeight
                implicitWidth: {
                    var maxWidth = 0;
                    for (var i = 0; i < contentItem.children.length; ++i) {
                        maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
                    }
                    return maxWidth;
                }
                
                model: control.contentModel
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement :Flickable.StopAtBounds
                interactive: Window.window ? contentHeight > Window.window.height : false
                clip: true
                currentIndex: control.currentIndex || 0
                spacing: 0
                keyNavigationEnabled: true
                keyNavigationWraps: true
                
                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }
    }
    
    Component
    {
        id: mobileMenu
        
        Menu
        {
            id:_mobileMenu
            parent: window()
            
            x: 0
            y: window().height - height
            
            width: window().width
            height: Math.min(window().height * 0.5, contentHeight + Maui.Style.space.big)
            
            modal: true
            margins: 0
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            topPadding: Maui.Style.space.medium

            contentItem: ListView
            {
                implicitHeight: contentHeight
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement :Flickable.StopAtBounds
                model: control.contentModel
                interactive: true
                clip: true
                spacing: Maui.Style.space.medium
                currentIndex: control.currentIndex || 0
                keyNavigationEnabled: true
                keyNavigationWraps: true               
                
                ScrollBar.vertical: ScrollBar {}
            }
            
            enter: Transition
            {
                NumberAnimation
                {
                    property: "y"
                    from: window().height
                    to: window().height - _mobileMenu.height
                    easing.type: Easing.InOutQuad
                    duration: Kirigami.Units.shortDuration
                }
            }

            exit: Transition
            {
                NumberAnimation
                {
                    property: "y"
                    from: _mobileMenu.y
                    to: window().height
                    easing.type: Easing.InOutQuad
                    duration: Kirigami.Units.shortDuration
                }
            }
            
            background: Rectangle
            {
                implicitWidth: Kirigami.Units.gridUnit * 8
                color: Kirigami.Theme.backgroundColor
                
                Maui.Separator
                {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    edge: Qt.TopEdge
                }
            }
        }
    }
    
    function open(x, y, parent)
    {
        if (control.responsive)
        {
            _loader.item.open()
        }
        else
        {
            _loader.item.popup(parent,x,y)
        }
    }
    
    function close()
    {
        _loader.item.close()
    }
    
    function dismiss()
    {
        close()
    }
}

