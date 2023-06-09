// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

SplitView
{
    id: control

    clip: false
    
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
}
