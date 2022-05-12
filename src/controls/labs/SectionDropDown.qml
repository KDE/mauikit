import QtQuick 2.13
import QtQuick.Controls 2.13

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtQuick.Templates 2.15 as T

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/

T.ItemDelegate
{
    id: control
    checked : false
    checkable: false
    property alias template : _template
    property alias label1 : _template.label1
    property alias label2 : _template.label2
    
    implicitHeight: _template.implicitHeight + topPadding + bottomPadding
    hoverEnabled: true
    
   contentItem: Maui.ListItemTemplate
    {
        id: _template
      
        headerSizeHint: iconSizeHint + Maui.Style.space.big

        label1.font.pointSize: Maui.Style.fontSizes.large
        label1.font.bold: true
        label1.font.weight: Font.Bold
        label2.wrapMode: Text.WordWrap
        label1.color: Kirigami.Theme.textColor
//         leftMargin: 0
//         rightMargin: 0
//         
       Item
       {
           visible: control.checkable
           implicitHeight: Maui.Style.iconSizes.medium
           implicitWidth: implicitHeight
            
           Maui.Triangle
           {
               visible: control.hovered || control.pressed  
               anchors.centerIn: parent
               height: Maui.Style.iconSizes.tiny
               width: height
               rotation: !control.checked ? -225 : -45 
               color: Kirigami.Theme.textColor
               opacity: 0.7
           }
       }
    }
    
    onClicked: control.checked = !control.checked    
}
