import QtQuick 2.15

import org.mauikit.controls 1.3 as Maui

Maui.PrivateIcon
{
    id: control
    implicitHeight: Maui.Style.iconSize
    implicitWidth: implicitHeight

//     Behavior on color
//     {
//         Maui.ColorTransition{}
//     }

    readonly property string currentIconTheme: Maui.Style.currentIconTheme

    onCurrentIconThemeChanged:
    {
        control.refresh();
    }
}

