import QtQuick 2.14
import QtQuick.Controls 2.14
import org.mauikit.controls 1.3 as Maui

ProgressBar
{
    id: control
    
    indeterminate: true
    
    contentItem: Item 
    {
        x: control.leftPadding
        y: control.topPadding
        width: control.availableWidth
        height: control.availableHeight
        
        scale: control.mirrored ? -1 : 1
        
        Repeater
        {
            model: 2
            
            Rectangle 
            {
                property real offset: 0
                
                x: (control.indeterminate ? offset * parent.width : 0)
                y: (parent.height - height) / 2
                width: offset * (parent.width - x)
                height: 4
                
                color: Maui.Theme.highlightColor
                
                Behavior on color
                {
                    Maui.ColorTransition{}
                }
                
                SequentialAnimation on offset
                {
                    loops: Animation.Infinite
                    running: control.indeterminate && control.visible
                    PauseAnimation { duration: index ? 520 : 0 }
                    NumberAnimation {
                        easing.type: Easing.OutCubic
                        duration: 1240
                        from: 0
                        to: 1
                    }
                    PauseAnimation { duration: index ? 0 : 520 }
                }
            }
        }
    }
    
    background: null
}
