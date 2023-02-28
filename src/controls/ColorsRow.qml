import QtQuick 2.14
import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui

Flow
{
    id: control
    
    default property var colors : []
    property string defaultColor 
    property string currentColor

    spacing: Maui.Style.defaultSpacing
    
    property int size : Maui.Handy.isMobile ? 26 : Maui.Style.iconSizes.medium
    signal colorPicked (string color)
    
    Repeater
    {
        model: control.colors

        AbstractButton
        {
            id: _button
            checked : control.currentColor === modelData
            implicitHeight: control.size + topPadding + bottomPadding
            implicitWidth: implicitHeight + leftPadding + rightPadding
            hoverEnabled: true
            onClicked: control.colorPicked(modelData)
            
            property color color : modelData
            
            contentItem: Item
            {                
                Maui.Icon
                {
                    visible: opacity > 0
                    color: Maui.ColorUtils.brightnessForColor(_button.color) === Maui.ColorUtils.Light ? "#333" : "#fff"
                    anchors.centerIn: parent
                    height: Math.round(parent.height * 0.9)
                    width: height
                    opacity: checked || hovered ? 1 : 0
                    isMask: true
                    
                    source: "qrc:/assets/checkmark.svg"
                    
                    Behavior on opacity
                    {
                        NumberAnimation
                        {
                            duration: Maui.Style.units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                } 
            }
            
            background: Rectangle
            {
                radius: Maui.Style.radiusV
                color: enabled ? modelData : "transparent"
                
            }
        }
    }
    
    Loader
    {
        asynchronous: true
        active: control.defaultColor.length
        sourceComponent: Item
        {
            implicitHeight: control.size
            implicitWidth: implicitHeight
            
            ToolButton
            {
                flat: true
                anchors.centerIn: parent
                icon.name: "edit-clear"
                onClicked:
                {
                    control.colorPicked(control.defaultColor)
                }
            }
        }
    }
   
}
