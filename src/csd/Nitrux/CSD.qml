import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.7 as Kirigami

Item
{
    id: control

    property int iconSize : 24
    implicitHeight: visible ? control.iconSize + Maui.Style.space.medium : 0
    implicitWidth: visible ? _row.implicitWidth : 0

    Row
    {
        id: _row
        height: parent.height
        spacing: Maui.Style.space.small

        ToolSeparator
        {
            height: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        Repeater
        {
            model: buttonsModel
            delegate: pluginButton
        }
    }

    Component
    {
        id: pluginButton

        AbstractButton
        {
            id: _button
            hoverEnabled: true
            width: height
            height: control.iconSize + Maui.Style.space.medium
            focusPolicy: Qt.NoFocus
            
            Maui.CSDButton
            {
                id: button
                type: mapType(modelData)
                isHovered: _button.hovered
                isPressed: _button.pressed
                isFocused:  isActiveWindow
                isMaximized: maximized
            }

            contentItem: Item
            {
                Kirigami.Icon
                {
                    width: control.iconSize
                    height: control.iconSize
                    smooth: true
                    source: button.source
                    color: Maui.Theme.textColor
                    anchors.centerIn: parent
                    Behavior on color
                    {
                        Maui.ColorTransition{}
                    }
                }
            }
            
            onClicked: 
            {
                console.log("NITRUX CSD BUTTON CLICKED", button.type)
               buttonClicked(button.type)
            }
        }
    }
}
