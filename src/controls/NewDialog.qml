import QtQuick 2.14
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.2 as Maui

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
Maui.Dialog
{
    id: control
   property bool entryField: true
property alias textEntry: _textEntry
    /**
      * finished :
      */
    signal finished(string text)

    acceptButton.text: i18nd("mauikit", "Accept")
    rejectButton.text: i18nd("mauikit", "Cancel")
    closeButtonVisible: false
    
    Maui.TextField
    {
        id: _textEntry
        Layout.fillWidth: true    
        onAccepted: control.acceptButton.forceActiveFocus()
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
