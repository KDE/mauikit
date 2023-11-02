import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui

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

    onAccepted: 
    {
        finished(control.textEntry.text)
        textEntry.clear()
        close()
    }
    
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
}
