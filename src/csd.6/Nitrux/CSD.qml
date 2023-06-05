import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

Control
{
    id: control

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    
    spacing: Maui.Style.space.small   
    padding: Maui.Style.defaultPadding
    
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

            implicitWidth: 22
            implicitHeight: 22

            focusPolicy: Qt.NoFocus
            
            Maui.CSDButton
            {
                id: button
                style: "Nitrux"
                type: mapType(modelData)
                isHovered: _button.hovered
                isPressed: _button.pressed
                isFocused:  isActiveWindow
                isMaximized: maximized
            }

            contentItem:  Maui.Icon
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
