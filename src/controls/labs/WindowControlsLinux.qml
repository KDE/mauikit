import org.mauikit.controls 1.3 as Maui
import QtQuick.Window 2.15
import QtQuick 2.15

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/

Loader
{
    id: control
    
    active: Maui.App.controls.enableCSD  && Maui.Handy.isLinux && control.Window.window.visibility !== Window.FullScreen
    
    visible: active
    width: visible ? implicitWidth:  0
    sourceComponent: Maui.CSDControls
{
    onButtonClicked: performActiveWindowAction(type)

    /**
      *
      */
    function performActiveWindowAction(type)
    {
        console.log("WINDOW CSD CLICKED", type)
        if (type === Maui.CSDButton.Close) {
            Window.window.close()
        } else if (type === Maui.CSDButton.Maximize || type === Maui.CSDButton.Restore) {
            Window.window.toggleMaximized()
        } else if (type ===  Maui.CSDButton.Minimize) {
            Window.window.showMinimized()
        }
    }
}
}
