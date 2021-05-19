import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

Maui.ItemDelegate {

    id: control

    Drag.active: mouseArea.drag.active && control.draggable
    Drag.dragType: Drag.Automatic
    Drag.supportedActions: Qt.MoveAction
    Drag.hotSpot.x: control.width / 2
    Drag.hotSpot.y: control.height / 2
}
