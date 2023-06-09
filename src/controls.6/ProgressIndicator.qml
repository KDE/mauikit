import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

ProgressBar
{
    id: control
    
    indeterminate: true   
    implicitHeight: 6

    background: Rectangle
    {
        radius: 0
        color: Maui.Theme.backgroundColor
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
