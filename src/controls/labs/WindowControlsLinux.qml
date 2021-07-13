import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import org.mauikit.controls 1.3 as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Maui.CSDControls
{
    id: control
    onButtonClicked: performActiveWindowAction(type)

    /**
      *
      */
    function performActiveWindowAction(type)
    {
        if (type === Maui.CSDButton.Close) {
            root.close()
        } else if (type === Maui.CSDButton.Maximize || type === Maui.CSDButton.Restore) {
            root.toggleMaximized()
        } else if (type ===  Maui.CSDButton.Minimize) {
            root.showMinimized()
        }
    }
}
