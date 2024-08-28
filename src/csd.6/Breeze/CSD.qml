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

    contentItem: Row
    {
        id: _row
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
            visible: switch(modelData)
            {
                case "A" : return canMaximize 
                case "I": return canMinimize
                default: return true
            }
            
            hoverEnabled: true
            width: 16
            height: 16
            
            Maui.CSDButton
            {
                id: button
                style: "Breeze"
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
                isMask: false
            }
            
            onClicked: buttonClicked(button.type)
        }
    }
}
