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
            implicitWidth: Maui.Handy.isTouch ? 10 : 6
            implicitHeight: Maui.Handy.isTouch ? 10 : 6

            color: SplitHandle.pressed ? Kirigami.Theme.highlightColor
                                       : (SplitHandle.hovered ? Qt.lighter(Kirigami.Theme.backgroundColor, 1.1) : Kirigami.Theme.backgroundColor)

            Rectangle
            {
                anchors.centerIn: parent
                height: parent.height
                width: 48
                color: _splitSeparator1.color
            }

            Kirigami.Separator
            {
                id: _splitSeparator1
                anchors.top: parent.top
                width: parent.width
            }

            Kirigami.Separator
            {
                id: _splitSeparator2
                anchors.top: parent.bottom
                width: parent.width
            }
        }
    }

    Component
    {
        id: _verticalHandleComponent

        Rectangle
        {
            implicitWidth: Maui.Handy.isTouch ? 10 : 6
            implicitHeight: Maui.Handy.isTouch ? 10 : 6

            color: SplitHandle.pressed ? Kirigami.Theme.highlightColor
                                       : (SplitHandle.hovered ? Qt.lighter(Kirigami.Theme.backgroundColor, 1.1) : Kirigami.Theme.backgroundColor)

            Rectangle
            {
                anchors.centerIn: parent
                height: 48
                width: parent.width
                color: _splitSeparator1.color
            }

            Kirigami.Separator
            {
                id: _splitSeparator1
                anchors.left: parent.left
                height: parent.height

            }

            Kirigami.Separator
            {
                id: _splitSeparator2
                anchors.right: parent.right
                height: parent.height
            }
        }
    }


    handle: Loader
    {
        //        asynchronous: true
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
