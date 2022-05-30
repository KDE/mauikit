import QtQuick 2.14

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

Item 
{
    id: control

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary
    
    implicitHeight: Maui.Style.iconSizes.medium
    implicitWidth: implicitHeight
    
    property bool checked : false
    property bool checkable: false

    signal toggled(bool state)
    
  
    Rectangle
    {
        anchors.fill: parent
        color: control.checked ? Maui.Theme.highlightColor : Qt.rgba(Maui.Theme.backgroundColor.r, Maui.Theme.backgroundColor.g, Maui.Theme.backgroundColor.b, 0.5)
        radius: height/2
        border.color: Maui.Theme.highlightedTextColor
        
        Kirigami.Icon
        {
            visible: opacity > 0
            color: Maui.Theme.highlightedTextColor
            anchors.centerIn: parent
            height: control.checked ? Math.round(parent.height * 0.9) : 0
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
        }
        
         Behavior on color
        {
            Maui.ColorTransition{}
        }
    }

    MouseArea
    {
        //enabled: control.checkable
        hoverEnabled: true

        readonly property int targetMargin:  Kirigami.Settings.hasTransientTouchInput ? Maui.Style.space.big : 0

        height: parent.height + targetMargin
        width: parent.width + targetMargin

        onClicked:
        {
            control.checked = !control.checked
            control.toggled(control.checked)
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
