import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

ToolButton
{
    id: control

    icon.source: "qrc:/assets/close.svg"
    icon.color: control.hovered || control.containsPress ? control.Maui.Theme.negativeTextColor : control.Maui.Theme.textColor

    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: control.hovered || control.containsPress ? Maui.Theme.negativeBackgroundColor : "transparent"
        
    }
}
