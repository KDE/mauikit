import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.9 as Kirigami
import org.kde.mauikit 1.2 as Maui

/*!
  \since org.kde.mauikit.labs 1.0
  \inqmlmodule org.kde.mauikit.labs

  An alternate style of list item.
*/
Maui.ItemDelegate
{
    id: control

    /*!
      Whether or not this list item should use an alternate background colour.
    */
    property bool alt : false

    /*!
      Whether or not this list item is the last list item in the view.
    */
    property bool lastOne : false

    leftPadding: Maui.Style.space.big
    rightPadding: Maui.Style.space.big

    background: Rectangle
    {
        color: control.Kirigami.Theme.backgroundColor 

        Maui.Separator
        {
            id: _sep
            visible: !control.lastOne
            edge: Qt.BottomEdge
            color: parent.color
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
