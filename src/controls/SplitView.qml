// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

SplitView
{
    id: control

    clip: true
    focus: true

    onCurrentItemChanged:
    {
        currentItem.forceActiveFocus()
    }

    Component
    {
        id: _horizontalHandleComponent
        
        Rectangle
        {
            implicitWidth: Maui.Handy.isTouch ? 20 : 12
            implicitHeight: Maui.Handy.isTouch ? 20 : 12
            
            color: Kirigami.Theme.backgroundColor

            Rectangle
            {
                property int length: pressed ? 80 : 48
                
                Behavior on length {
                    NumberAnimation {
                        duration: 100
                    }
                }                
                      
                      Behavior on opacity {
                          NumberAnimation {
                              duration: 100
                          }
                      }  
                      
                      opacity: pressed ? 1 : 0.4
                      
                anchors.centerIn: parent
                height: 8
                width: length
                radius: height
               
                color: pressed ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
            }

            //Kirigami.Separator
            //{
                //anchors.top: parent.top
                //width: parent.width
            //}

            //Kirigami.Separator
            //{
                //anchors.top: parent.bottom
                //width: parent.width
            //}
        }
    }

    Component
    {
        id: _verticalHandleComponent

        Rectangle
        {
            implicitWidth: Maui.Handy.isTouch ? 20 : 12
            implicitHeight: Maui.Handy.isTouch ? 20 : 12

            color: Kirigami.Theme.backgroundColor

            Rectangle
            {
                property int length: pressed ? 80 : 48
                
                Behavior on length {
                    NumberAnimation {
                        duration: 100
                    }
                }    
                
                Behavior on opacity {
                    NumberAnimation {
                        duration: 100
                    }
                }  
                
                opacity: pressed ? 1 : 0.4
                anchors.centerIn: parent
                height: length
                width: 8
                radius: width
                color: pressed ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
            }

            //Kirigami.Separator
            //{
                //anchors.left: parent.left
                //height: parent.height
            //}

            //Kirigami.Separator
            //{
                //anchors.right: parent.right
                //height: parent.height
            //}
        }
    }


    handle: Loader
    {
        //        asynchronous: true
        property bool pressed: SplitHandle.pressed
        sourceComponent: control.orientation === Qt.Horizontal ? _verticalHandleComponent : _horizontalHandleComponent
    }

    function closeSplit(index)
    {
        if(control.count === 1)
        {
            return // do not close aall
        }

        control.removeItem(control.takeItem(index))
    }

    function addSplit(component, properties)
    {
        const object = component.createObject(control.contentModel, properties);

        control.addItem(object)
        control.currentIndex = Math.max(control.count -1, 0)
        object.forceActiveFocus()

        return object
    }

//    Component.onCompleted: control.restoreState(settings.splitView)
//    Component.onDestruction: settings.splitView = control.saveState()

//    Settings {
//        id: settings
//        property var splitView
//    }

}
