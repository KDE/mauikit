import QtQuick
import org.mauikit.controls as Maui

Maui.PrivateIcon
{
    id: control

    implicitHeight: Maui.Style.iconSize
    implicitWidth: implicitHeight

    readonly property string currentIconTheme: Maui.Style.currentIconTheme

    onCurrentIconThemeChanged:
    {
        control.refresh();
    }
}

