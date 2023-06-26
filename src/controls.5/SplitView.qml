// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

SplitView
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false
    clip: false
    focus: true
    
    onCurrentItemChanged:
    {
        currentItem.forceActiveFocus()
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
