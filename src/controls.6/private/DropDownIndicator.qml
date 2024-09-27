import QtQuick
import org.mauikit.controls as Maui

Maui.Icon
{
    id: control
    property Item item
    x: item.mirrored ? item.leftPadding : item.width - width - item.rightPadding
    y: item.topPadding + (item.availableHeight - height) / 2
    visible: false
    color: item.color
    height: 8
    width: 8
    source: "qrc:/assets/arrow-down.svg"
}
