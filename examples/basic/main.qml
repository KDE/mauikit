import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root
    Maui.Style.styleType: Maui.Style.Dark
    Maui.Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
    }
}

