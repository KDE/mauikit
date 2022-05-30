import QtQuick 2.15
import QtQuick.Controls 2.15

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

AbstractButton
{
    id: control
    Maui.Theme.colorSet: Maui.Theme.Button
    
    implicitWidth: (icon.width)+ leftPadding + rightPadding
    implicitHeight: (icon.height) + topPadding + bottomPadding

    hoverEnabled: true

    padding: Maui.Style.space.small
    icon.width: Maui.Style.iconSizes.small
    icon.height: Maui.Style.iconSizes.small

    contentItem: Item
    {
        Kirigami.Icon
        {
            source: "qrc:/assets/close.svg"
            height: control.icon.height
            width: control.icon.width
            anchors.centerIn: parent
            color: control.hovered || control.containsPress ? control.Maui.Theme.negativeTextColor : control.Maui.Theme.textColor
            isMask: true
            
            Behavior on color
        {
            Maui.ColorTransition{}
        }
        }
    }
    
    background: Rectangle
    {
        radius: height/2
        color: control.hovered || control.containsPress ? Qt.tint(Maui.Theme.textColor, Qt.rgba(Maui.Theme.backgroundColor.r, Maui.Theme.backgroundColor.g, Maui.Theme.backgroundColor.b, 0.9)) : "transparent"     
        
         Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
