import QtQuick
import org.mauikit.controls as Maui

import QtQuick.Templates as T

T.StackView
{
    id: control
    focus: true
    clip: false
    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false

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

    background:Rectangle
    {
        color: Maui.Theme.backgroundColor
    }
}
