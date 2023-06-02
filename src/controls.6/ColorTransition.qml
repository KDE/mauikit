import QtQuick
import org.mauikit.controls as Maui

ColorAnimation
{
    easing.type: Easing.InQuad
    duration: Maui.Style.enableEffects ? Maui.Style.units.shortDuration : 0
}

