import QtQuick 2.13
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import org.mauikit.controls 1.3 as Maui

Control
{
    id: control
    
    padding: Maui.Style.space.small
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    spacing: Maui.Style.space.medium
        
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
            hoverEnabled: true
            width: 18
            height: 18 
            
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
