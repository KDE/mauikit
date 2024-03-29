import QtQuick
import org.mauikit.controls as Maui

import QtQuick.Templates as T

T.StackView
{
    id: control
    focus: true
    clip: false
    
    pushEnter: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 0
            to:1
            duration: 200
        }
    }
    
    pushExit: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 1
            to:0
            duration: 200
        }
    }
    
    popEnter: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 0
            to:1
            duration: 200
        }
    }
    
    popExit: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 1
            to:0
            duration: 200
        }
    }
}
