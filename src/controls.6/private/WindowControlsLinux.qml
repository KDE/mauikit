import QtQuick
import QtQuick.Window

import org.mauikit.controls 1.3 as Maui

/**
  @since org.mauikit.controls.labs 1.0
  @brief The window control buttons for windows using client side decorations.
  
  @note Although this control name has the "Linux" suffix, the right name  for usage is WindowControls.
  @code
QQC2.Pane
{
    WindowControls
    {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.margins: Style.space.medium
    }  
}  
  @endcode
  
  This control takes care of drawing the window buttons, and when triggered it performs the associated actions such as close, minimize and maximize.
 
 It is loaded asynchronous, and only active if the client side decorations have been enabled and the form factor of the device is on desktop mode.
 Consider only using it in cases where the main application window container does not support the attached property Controls.showCSD.
 
 Some of the containers and items that support the formerly mentioned attached property are:
 - TabView
 - Page
 - AppViews
 - ToolBar
 - TabBar
 
 For more details on the implementation of this control and how to customize it you can refer to CSDControls.
 
   @image html WindowControls/themes.png
  @note There are different window control buttons themes, and new ones can be created.
 
 
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
