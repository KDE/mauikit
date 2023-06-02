import QtQuick
import QtQuick.Controls
import QtQuick.Window

import org.mauikit.controls as Maui

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Loader
{
    id: control
    asynchronous: true
   
    property bool maximized : Window.window.visibility === Window.Maximized
    property bool isActiveWindow : Window.window.active
    property bool canMaximize: Window.window.minimumWidth !== Window.window.maximumWidth && Window.window.maximumHeight !== Window.window.minimumHeight
    readonly property var buttonsModel : Maui.App.controls.rightWindowControls


    /**
     * A window control button has been clicked. This signal is public and can be mapped to any arbitrary value. Be carefull.
     */
    signal buttonClicked(var type)
    source: Maui.App.controls.source
}
