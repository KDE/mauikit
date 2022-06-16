import QtQuick 2.15

import org.mauikit.controls 1.3 as Maui
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
   
    hoverEnabled: false
    contentItem: MouseArea
    {
        id: _content
//         propagateComposedEvents: true
//         preventStealing: false
    }

    background: Rectangle
    {
        color: control.hovered ? Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9)) : "transparent"
        opacity: control.hovered ? 0.5 : 1

         Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
