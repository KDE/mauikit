import QtQuick 2.9
import QtQuick.Controls 2.2

import org.kde.kirigami 2.9 as Kirigami
import org.mauikit.controls 1.2 as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs

  An alternate style of list item.
*/
Maui.ItemDelegate
{
    id: control

    /*!
      Whether or not this list item is the last list item in the view.
    */
    property bool lastOne : false
    
    hoverEnabled: false

    leftPadding: Maui.Style.space.big
    rightPadding: Maui.Style.space.big

    background: Rectangle
    {
        color: control.hovered ? Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9)) : control.Kirigami.Theme.backgroundColor 
opacity: control.hovered ? 0.5 : 1

        Kirigami.Separator
        {
            id: _sep
            visible: !control.lastOne
//             edge: Qt.BottomEdge
//             color: parent.color
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
