import QtQuick 2.14
import org.mauikit.controls 1.2 as Maui

ColorAnimation
{
    easing.type: Easing.InQuad
                        //easing.type: Easing.OutCubic

    duration: Maui.Style.units.shortDuration
    //duration: 100
}

