import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.3 as FB

Row
{
    id: control
    
    default property var colors : []
    property string defaultColor : Kirigami.Theme.backgroundColor
    property string currentColor

    spacing: Maui.Style.space.medium

    signal colorPicked (string color)
    
    Repeater
    {
        model: control.colors

        MouseArea
        {
            readonly property bool checked : control.currentColor === modelData
            implicitHeight: Kirigami.Settings.isMobile ? Maui.Style.iconSizes.big : Maui.Style.iconSizes.medium
            implicitWidth: implicitHeight

            onClicked: control.colorPicked(modelData)
            
            Rectangle
            {
                anchors.fill: parent
                radius: height/2
                color: enabled ? modelData : "transparent"
                border.color: Qt.darker(modelData, 2)
                
                Kirigami.Icon
                {
                    visible: opacity > 0
                    color: "white"
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
                            duration: Kirigami.Units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
    
    Item
    {
        implicitHeight: Maui.Style.iconSizes.medium
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
