import QtQuick 2.13
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import org.mauikit.controls 1.3 as Maui

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Loader
{
    id: control
    asynchronous: true
    //active: buttonsModel.length
    //visible: active

   
    property bool maximized : Window.window.visibility === Window.Maximized
    property bool isActiveWindow : Window.window.active
    
    readonly property var buttonsModel : Maui.App.controls.rightWindowControls


    /**
     *
     */
    signal buttonClicked(var type)

    source: Maui.App.controls.source
}
