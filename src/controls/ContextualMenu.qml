// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Controls 2.15

Menu
{
    id: control
        
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

