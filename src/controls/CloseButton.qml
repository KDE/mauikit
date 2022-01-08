import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

AbstractButton
{
    id: control
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
            color: control.hovered || control.containsPress ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
        }
    }
    
    background: Rectangle
    {
        radius: height/2
        color: control.hovered || control.containsPress ? Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.9)) : "transparent"
        
    }
}
