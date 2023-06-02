import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.0 as Maui
import QtQuick.Shapes 1.12

Shape
{
    id: _shape

    /**
      * arrowWidth : int
      */
    property int arrowWidth : 8

    /**
      * color : color
      */
    property color color : Maui.Theme.backgroundColor

    /**
      * borderColor : color
      */
    property color borderColor: "transparent"

    /**
      * borderWidth : int
      */
    property int borderWidth: -1

    layer.enabled: smooth
    layer.samples: 16

    smooth: true
    asynchronous: true
    containsMode: Shape.FillContains

    ShapePath
    {
        id: _path
        joinStyle: ShapePath.RoundJoin
        capStyle: ShapePath.RoundCap
        strokeWidth: _shape.borderWidth
        strokeColor: _shape.borderColor
        fillColor: _shape.color

        startX: 0; startY: 0
        PathLine { x: _shape.width - _shape.arrowWidth; y: _path.startY }
        PathLine { x: _shape.width; y: Math.floor(_shape.height / 2) }
        PathLine { x: _shape.width - _shape.arrowWidth; y: _shape.height}
        PathLine { x: _path.startX; y: _shape.height}
        PathLine { x: _shape.arrowWidth; y: Math.floor(_shape.height / 2)}
        PathLine { x: _path.startX; y: _path.startY }
    }
}
