import QtQuick 2.15

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

Kirigami.Icon
{
    id: control
    implicitHeight: Maui.Style.iconSize
    implicitWidth: implicitHeight
    color: Maui.Theme.textColor
    
    Behavior on color
    {
        Maui.ColorTransition{}
    }
}
