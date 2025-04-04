import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui
import QtQuick.Shapes 1.12

Shape
{
    id: control

    /**
      * color : color
      */
    property color color : Maui.Theme.backgroundColor

    /**
      * borderWidth : int
      */
    property int borderWidth: 2

    layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
    layer.samples: 4
    
Behavior on color
        {
            Maui.ColorTransition{}
        }

    ShapePath
    {
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.RoundJoin
        strokeWidth: control.borderWidth
        strokeColor: control.color
        fillColor: "transparent"

        startX: control.width * 0.5; startY: 0
        PathLine { x: control.width * 0.5; y: control.height }
    }

    ShapePath
    {
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.RoundJoin
        strokeWidth: control.borderWidth
        strokeColor: control.color
        fillColor: "transparent"

        startX: 0; startY: control.height * 0.5
        PathLine { x: control.width; y: control.height * 0.5}
    }
}
