// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import QtQuick.Templates 2.15 as T
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

Menu
{
    id: control
    
    
    //enter: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: ApplicationWindow.overlay.height
    //to: ApplicationWindow.overlay.height - _menu.height
    //duration: Maui.Style.units.shortDuration
    //easing.type: Easing.OutCubic
    //}
    //}
    
    //exit: Transition
    //{
    //enabled: control.responsive
    
    //YAnimator {
    //from: _menu.y
    //to: ApplicationWindow.overlay.height
    //duration: Maui.Style.units.shortDuration
    
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

