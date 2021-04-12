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
        asynchronous: false
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
            contentData: control.contentData
        }
    }
    
    Component
    {
        id: mobileMenu
        
        Menu
        {
            id:_mobileMenu
            parent: window()
            
            contentData: control.contentData
//             contentChildren: control.contentChildren
            
            x: 0
            y: window().height - height
            
            width: window().width
            height: Math.min(window().height * 0.5, contentHeight + Maui.Style.space.big)
            currentIndex: control.currentIndex
            modal: true
            margins: 0
            spacing: Maui.Style.space.medium
            
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            topPadding: Maui.Style.space.medium

            contentItem: ListView
            {
                implicitHeight: contentHeight
                spacing: _mobileMenu.spacing
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement :Flickable.StopAtBounds
                model: _mobileMenu.contentModel
                interactive: true
                clip: true
                currentIndex: _mobileMenu.currentIndex || 0
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

