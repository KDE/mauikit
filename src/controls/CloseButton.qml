import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

AbstractButton
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.Button
    
    implicitWidth: (icon.width) + leftPadding + rightPadding
    implicitHeight: (icon.height) + topPadding + bottomPadding
    
    hoverEnabled: true
    
    padding: Maui.Style.space.small
    
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
        
    contentItem: Item
    {
        Maui.Icon
        {
            source: "qrc:/assets/close.svg"
            //source: button.source
            height: control.icon.height
            width: control.icon.width
            anchors.centerIn: parent
                        color: control.hovered || control.containsPress ? control.Maui.Theme.negativeTextColor : control.Maui.Theme.textColor
                        isMask: true
        }
    }
    
    background: Rectangle
    {
        radius: height/2
        color: control.hovered || control.containsPress ? Maui.Theme.negativeBackgroundColor : "transparent"     
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
