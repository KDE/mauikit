import QtQuick 
import QtQuick.Controls 

import org.mauikit.controls as Maui

Control
{
    id: control

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    spacing: 0

    background: null

    contentItem: Row
    {
        id: _layout
        spacing: control.spacing

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

            implicitWidth: 23
            implicitHeight: 14

            focusPolicy: Qt.NoFocus

            Maui.CSDButton
            {
                id: button
                style: "Lucid"
                type: mapType(modelData)
                isHovered: _button.hovered
                isPressed: _button.pressed
                isFocused:  isActiveWindow
                isMaximized: maximized
            }

            contentItem: Image
                {
                    smooth: true
                    source: button.source                 
                }

            onClicked: buttonClicked(button.type)

        }
    }
}
