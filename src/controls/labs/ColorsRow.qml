import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

Row
{
    id: control
    
    default property var colors : []
    property string defaultColor 
    property string currentColor

    spacing: Maui.Style.space.medium

    property int size : Maui.Handy.isMobile ? 26 : Maui.Style.iconSizes.medium
    signal colorPicked (string color)
    
    Repeater
    {
        model: control.colors

        AbstractButton
        {
            checked : control.currentColor === modelData
            implicitHeight: control.size
            implicitWidth: implicitHeight
            hoverEnabled: true
            onClicked: control.colorPicked(modelData)
            
            contentItem: Rectangle
            {
                radius: height/2
                color: enabled ? modelData : "transparent"
                border.color: Qt.darker(modelData, 2)
                border.width: parent.hovered ?  2 : 1
                
                Kirigami.Icon
                {
                    visible: opacity > 0
                    color: Maui.ColorUtils.brightnessForColor(parent.color) == Maui.ColorUtils.Light ? Qt.darker(parent.color, 2) :  Qt.lighter(parent.color, 2)
                    anchors.centerIn: parent
                    height: checked ? Math.round(parent.height * 0.9) : 0
                    width: height
                    opacity: checked ? 1 : 0
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
