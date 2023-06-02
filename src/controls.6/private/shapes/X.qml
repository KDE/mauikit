import QtQuick 2.15

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

    layer.enabled: true
    layer.samples: 4
    
 Behavior on color
        {
            Maui.ColorTransition{}
        }

   ShapePath
    {
        capStyle: ShapePath.RoundCap
        strokeWidth: control.borderWidth
        strokeColor: control.color
        fillColor: "transparent"
        strokeStyle: ShapePath.SolidLine
        startX: 0; startY: 0
        PathLine { x: control.width; y: control.height }

    }


   ShapePath
    {
        capStyle: ShapePath.RoundCap
        strokeWidth: control.borderWidth
        strokeColor: control.color
        fillColor: "transparent"
        strokeStyle: ShapePath.SolidLine
        startX: control.width; startY: 0
        PathLine { x: 0; y: control.height }
    }

    }
