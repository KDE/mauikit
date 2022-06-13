import QtQuick 2.14
import org.mauikit.controls 1.2 as Maui

ColorAnimation
{
    easing.type: Easing.InQuad
                        //easing.type: Easing.OutCubic

    duration: Maui.Style.enableEffects ? Maui.Style.units.shortDuration : 0
    //duration: 100
}

