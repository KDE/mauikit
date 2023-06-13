import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 * NewDialog
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.InfoDialog
{
    id: control
    property bool entryField: true
    property alias textEntry: _textEntry
    /**
      * finished :
      */
    signal finished(string text)

    standardButtons: Dialog.Ok | Dialog.Cancel
    
    TextField
    {
        id: _textEntry
        Layout.fillWidth: true
//        onAccepted: control.acceptButton.forceActiveFocus()
    }
    
    onAccepted: done()
    onRejected:
    {
        textEntry.clear()
        control.close()
    }
    
    onOpened:
    {
        textEntry.forceActiveFocus()
        textEntry.selectAll()
    }
    
    function done()
    {
        finished(textEntry.text)
        textEntry.clear()
        close()
    }
}
