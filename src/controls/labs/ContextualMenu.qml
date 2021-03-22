// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Layouts 1.10
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.10 as QQC2

import org.kde.mauikit 1.3 as Maui
import QtQuick.Window 2.15

QQC2.Container {
    id: control
    
    spacing: Maui.Style.space.medium
    
    
    contentItem: Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
//         sourceComponent: Kirigami.Settings.isMobile && Kirigami.Settings.hasTransientTouchInput ? mobileMenu : regularMenu
        sourceComponent: mobileMenu
        
    }
    
    Component {
        id: regularMenu
        
        QQC2.Menu {
            contentData: control.contentData
            //contentModel: control.contentModel
        }
    }
    
    Component {
        id: mobileMenu
        
        QQC2.Drawer {
            width: window().width
            height: Math.min(window().height * 0.5, _listView.contentHeight+ Maui.Style.space.big)
            edge: Qt.BottomEdge
            padding: 0
            interactive: opened
            dragMargin: 0
            modal: true
            closePolicy: Popup.CloseOnPressOutside
            
            ListView 
            {
                id: _listView
                model: control.contentModel
                anchors.fill: parent
                clip: true
                currentIndex: -1
                boundsBehavior: Flickable.StopAtBounds
                implicitWidth: width
                implicitHeight: contentHeight
                interactive: Window.window ? contentHeight > Window.window.height : false
                spacing: control.spacing
                keyNavigationEnabled: true
                keyNavigationWraps: true
                
                QQC2.ScrollIndicator.vertical: QQC2.ScrollIndicator {}                
            }
        }
    }    
    
    function open() {
        //if (Kirigami.Settings.isMobile)
			_loader.item.open()
// 		else
			//_loader.item.popup()
    }
    
    function close()
    {
        _loader.item.close()
    }
}
