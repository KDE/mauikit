import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.0 as Maui
import QtQuick.Shapes 1.12

Shape
{
    id: control

    /**
      * color : color
      */
    property color color : Maui.Theme.backgroundColor

    ShapePath
    {
        capStyle: ShapePath.SquareCap
        fillColor: control.color
        strokeColor: "transparent"
        strokeStyle: ShapePath.SolidLine
        startX: 0; startY: 0
        PathLine { x: control.width; y: control.height }
        PathLine { x: 0; y: control.height }
        PathLine { x: 0; y: 0 }
    }
}
