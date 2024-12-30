// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtCore
import QtQuick.Controls

import org.mauikit.controls as Maui

QtObject
{
    id: control
    default property list<Action> actions : []

    property string title
    property string message
    property string iconSource
    property string iconName

    function dispatch()
    {
        Maui.App.rootComponent.notify(control.iconName, control.title, control.message, control.actions)
    }
}
