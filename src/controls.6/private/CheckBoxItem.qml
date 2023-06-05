import QtQuick
import org.mauikit.controls as Maui

Item 
{
    id: control
        
    implicitHeight: Maui.Style.iconSize + 2
    implicitWidth: implicitHeight
    
    property bool checked : false
    property bool checkable: false
    property bool autoExclusive: false
    property bool hovered: false
    //     signal toggled(bool state)    
    
    Rectangle
    {
        id: _rec
        anchors.fill: parent
        color: control.checked ? Maui.Theme.backgroundColor : Maui.Theme.backgroundColor
        radius: control.autoExclusive ? height/2 : 4
        border.color: control.checked ? Maui.Theme.highlightColor : Maui.ColorUtils.linearInterpolation(Maui.Theme.alternateBackgroundColor, Maui.Theme.textColor, 0.2) 
        border.width: 2
        
        Maui.Icon
        {
            visible: opacity > 0
            
            color: Maui.Theme.highlightColor
            
            anchors.centerIn: parent
            
            height: control.checked ? Math.round(parent.height*0.9) : 0
            width: height
            
            opacity: control.checked ? 1 : 0
            
            isMask: true
            
            source: "qrc:/assets/checkmark.svg"
            
            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Maui.Style.units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }
        }
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
    
    onCheckedChanged:
    {
        if(checked)
        {
            _checkAnimation.start()
        }else
        {
            _uncheckAnimation.start()
        }
    }
    
    NumberAnimation
    {
        id: _checkAnimation
        target: control
        property: "scale"
        from: 1.3
        to: 1
        duration: Maui.Style.units.longDuration
        easing.type: Easing.OutBack
    }
    
    NumberAnimation
    {
        id: _uncheckAnimation
        target: control
        property: "scale"
        from: 0.7
        to: 1
        duration: Maui.Style.units.longDuration
        easing.type: Easing.InBack
    }
}
