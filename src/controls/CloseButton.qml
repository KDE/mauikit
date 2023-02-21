import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

ToolButton
{
    id: control   
       
    icon.source: "qrc:/assets/close.svg"
    icon.color: control.hovered || control.containsPress ? control.Maui.Theme.negativeTextColor : control.Maui.Theme.textColor
           
    background: Rectangle
    {
        radius: height/2
        color: control.hovered || control.containsPress ? Maui.Theme.negativeBackgroundColor : "transparent"     
        
    }
}
