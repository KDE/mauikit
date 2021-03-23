import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.9 as Kirigami
import org.kde.mauikit 1.2 as Maui

Maui.ItemDelegate
{
    id: control

    /**
      *
      */
    property bool lastOne : false
    hoverEnabled: false

    leftPadding: Maui.Style.space.big
    rightPadding: Maui.Style.space.big

    background: Rectangle
    {
        color: control.hovered ? Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9)) : control.Kirigami.Theme.backgroundColor 
opacity: control.hovered ? 0.5 : 1
        Maui.Separator
        {
            id: _sep
            visible: !control.lastOne
            edge: Qt.BottomEdge
//             color: parent.color
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
