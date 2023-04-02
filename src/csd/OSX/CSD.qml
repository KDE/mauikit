import QtQuick 2.13
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    implicitHeight: visible ? _row.implicitHeight : 0
    implicitWidth: visible ? _row.implicitWidth : 0
    
    property bool hovered : false
    
    Row
    {
        id: _row
        anchors.fill: parent
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
            height: 22 
            
            Binding
            {
                target: control
                property: "hovered"
                value: _button.hovered               
            }
            
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
            
            contentItem: Item
            {
                Image
                {
                    width: 16
                    height: 16
                    smooth: true
                    source: button.source                  
                    anchors.centerIn: parent
                }
            }
            
            onClicked: buttonClicked(button.type)            
        }
    }
}
