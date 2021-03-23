// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Layouts 1.10
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.10 as QQC2

import org.kde.mauikit 1.3 as Maui
import QtQuick.Window 2.15

QQC2.Container
{
    id: control
    visible: _loader.item ? _loader.item.visible : false
    spacing: Maui.Style.space.medium
    property bool responsive: true
    
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
        
        QQC2.Menu 
        {
            id: _menu
            implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                    contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0)
            implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                     contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding
            
            margins: 0
            padding: 0
            spacing: 0
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

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
                interactive: Window.window ? contentHeight > Window.window.height : false
                clip: true
                currentIndex: control.currentIndex || 0
                spacing: 0
                keyNavigationEnabled: true
                keyNavigationWraps: true
                
                QQC2.ScrollIndicator.vertical: QQC2.ScrollIndicator {}
            }
        }
    }
    
    Component 
    {
        id: mobileMenu
        
        QQC2.Menu
        {
            id:_mobileMenu
            parent: window()
            
            x: 0            
            y: window().height - height           
            
            width: window().width
            height: Math.min(window().height * 0.5, contentHeight)
            
            modal: true
            margins: 0        
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            contentItem: ListView 
            {
                implicitHeight: contentHeight                
                boundsBehavior: Flickable.StopAtBounds
                model: control.contentModel
                interactive: true
                clip: true
                currentIndex: control.currentIndex || 0
                keyNavigationEnabled: true
                keyNavigationWraps: true
                implicitWidth: 
                {
                    var maxWidth = 0;
                    for (var i = 0; i < contentItem.children.length; ++i) {
                        maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
                    }
                    return maxWidth;
                }
                
                QQC2.ScrollBar.vertical: QQC2.ScrollBar {}
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
    
    function open(x, y) 
    {
        if (control.responsive)
        {
            _loader.item.open()
        }
        else
        {
            _loader.item.popup(x,y)
        }
    }
    
    function close()
    {
        _loader.item.close()
    }
}

