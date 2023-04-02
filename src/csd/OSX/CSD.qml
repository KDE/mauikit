import QtQuick 2.13
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import org.mauikit.controls 1.3 as Maui

Control
{
    id: control
  
  implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
  implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
  spacing: Maui.Style.space.medium   
  padding: Maui.Style.space.small
  
    hoverEnabled: true    
   
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
