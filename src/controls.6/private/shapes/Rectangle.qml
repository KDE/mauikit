import QtQuick 2.9
import QtQuick.Controls 2.2
import org.mauikit.controls 1.0 as Maui
import QtQuick.Shapes 1.12

Shape
{
    id: _shape

    /**
      * color : color
      */
    property color color : Maui.Theme.backgroundColor

    /**
      * borderColor : color
      */
    property color borderColor: Maui.Theme.backgroundColor

    /**
      * borderWidth : int
      */
    property int borderWidth: 1

    /**
      * solidBorder : bool
      */
    property bool solidBorder : true

    layer.enabled: true
    layer.samples: 4

    ShapePath
    {
        id: _path
        joinStyle: ShapePath.RoundJoin
        capStyle: ShapePath.RoundCap
        strokeWidth: _shape.borderWidth
        strokeColor: _shape.borderColor
        fillColor: _shape.color
        strokeStyle: _shape.solidBorder ? ShapePath.SolidLine : ShapePath.DashLine
        dashPattern: [ 1, 4 ]
        startX: 1; startY: 1
        PathLine { x: _shape.width-_path.startX; y:  _path.startY }
        PathLine { x: _shape.width- _path.startX; y: _shape.height-_path.startY;  }
        PathLine { x:  _path.startX; y: _shape.height - _path.startY}
        PathLine { x: _path.startX; y: _path.startY }
    }
}
