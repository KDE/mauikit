import QtQuick 2.9

import org.kde.kirigami 2.9 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtQuick.Templates 2.15 as T

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs

  An alternate style of list item.
*/
T.Control
{
    id: control

    default property alias content : _content.data
    /*!
      Whether or not this list item is the last list item in the view.
    */
    property bool lastOne : false
    
    hoverEnabled: false

    padding: Maui.Style.space.big
//     rightPadding: Maui.Style.space.big
    
    contentItem: Item
    {
        id: _content
    }

    background: Rectangle
    {
        color: control.hovered ? Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9)) : "transparent"
        opacity: control.hovered ? 0.5 : 1

        Kirigami.Separator
        {
            visible: !control.lastOne
            weight: Kirigami.Separator.Weight.Light
            height: 0.5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
