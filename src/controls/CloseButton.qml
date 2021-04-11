 
 import QtQuick 2.14
 import QtQuick.Controls 2.14
 
 import org.kde.kirigami 2.7 as Kirigami
 import org.mauikit.controls 1.2 as Maui
 
 MouseArea
 {
     id: control     
       implicitWidth: Maui.Style.iconSizes.medium
                implicitHeight: Maui.Style.iconSizes.medium
     hoverEnabled: true     
  
     Rectangle
     {
        height: Maui.Style.iconSizes.small
        width: height
        anchors.centerIn: parent
         radius: height/2
         color: control.hovered || control.containsPress ? Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.9)) : "transparent"
         
         Maui.X
         {
             height: Maui.Style.iconSizes.tiny
             width: height
             anchors.centerIn: parent
             color: control.hovered || control.containsPress ? Kirigami.Theme.negativeTextColor : Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.2))
         }
     }
 }
