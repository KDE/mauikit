import QtQuick
import QtQuick.Window

import org.mauikit.controls as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Loader
{
    id: control
    
    active: Maui.App.controls.enableCSD && Maui.Handy.formFactor === Maui.Handy.Desktop && control.Window.window.visibility !== Window.FullScreen
    
    visible: active
    width: visible ? implicitWidth:  0
    sourceComponent: Maui.CSDControls
    {
        onButtonClicked: (type) => performActiveWindowAction(type)

        /**
      *
      */
        function performActiveWindowAction(type)
        {
            switch(type)
            {
            case Maui.CSDButton.Close :  Window.window.close(); break;
            case Maui.CSDButton.Maximize :
            case Maui.CSDButton.Restore : Window.window.toggleMaximized(); break;
            case Maui.CSDButton.Minimize: Window.window.showMinimized(); break;
            default: console.error("CSD Button clicked type not recognized.")
            }
        }
    }
}
