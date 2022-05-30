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
    /*!
      Whether or not this list item is the last list item in the view.
    */
    property bool lastOne : false
    
    hoverEnabled: false

    padding: Maui.Style.space.big
//     rightPadding: Maui.Style.space.big
    
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
        
        //Maui.Separator
        //{
            //visible: !control.lastOne
            //weight: Maui.Separator.Weight.Light
            //height: 0.5
            //anchors.left: parent.left
            //anchors.right: parent.right
            //anchors.bottom: parent.bottom
        //}
    }
}
