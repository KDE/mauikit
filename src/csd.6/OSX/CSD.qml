import QtQuick
import QtQuick.Controls
import QtQuick.Window

import org.mauikit.controls as Maui

Control
{
    id: control

    implicitHeight: _row.implicitHeight + topPadding + bottomPadding
    implicitWidth: _row.implicitWidth + leftPadding + rightPadding

    spacing: Maui.Style.space.small
    padding: Maui.Style.defaultPadding

    hoverEnabled: true

    contentItem: Row
    {
        id: _row
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
            
            width: height
            height: 16
            
            Maui.CSDButton
            {
                id: button
                style: "OSX"
                type: mapType(modelData)
                isHovered: control.hovered
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
