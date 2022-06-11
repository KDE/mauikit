import QtQuick 2.13
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    implicitHeight: visible ? 18 + Maui.Style.space.medium : 0
    implicitWidth: visible ? _row.implicitWidth : 0
    
    Row
    {
        id: _row
        height: parent.height
        spacing: Maui.Style.space.medium
        
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
            height: 18 + Maui.Style.space.medium
            
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
            
            contentItem: Item
            {
                Maui.Icon
                {
                    width: 18
                    height: 18
                    smooth: true
                    source: button.source
                    color: Maui.Theme.textColor
                    isMask: true
                    anchors.centerIn: parent
                }
            }
            onClicked: buttonClicked(button.type)
        }
    }
}
