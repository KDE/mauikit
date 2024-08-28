import QtQuick 
import QtQuick.Controls 

import org.mauikit.controls as Maui

Control
{
    id: control

    property int iconSize : 16

    padding: Maui.Style.space.small
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    spacing: Maui.Style.space.medium

    background: null

    contentItem: Row
    {
        id: _layout
        spacing: control.spacing

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

            visible: modelData === "A" ? canMaximize : true

            hoverEnabled: true

            implicitWidth:  control.iconSize
            implicitHeight: control.iconSize

            focusPolicy: Qt.NoFocus
            
            Maui.CSDButton
            {
                id: button
                style: "Default"
                type: mapType(modelData)
                isHovered: _button.hovered
                isPressed: _button.pressed
                isFocused:  isActiveWindow
                isMaximized: maximized
            }

            contentItem: Maui.Icon
                {
                    smooth: true
                    source: button.source

                    color: Maui.Theme.textColor

                    Behavior on color
                    {
                        Maui.ColorTransition{}
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
