import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 * @inherit InfoDialog
 * @brief An InfoDialog with a text entry field.
 * 
 *  This control inherits from MauiKit InfoDialog, to checkout its inherited properties refer to docs.
 * 
 *  This dialog can have information labels and icon/image, any number of children, and more. Refer to the structure of the Info Dialog.
 *  @see InfoDialog::structure Structure
 *  
 *  @image html Misc/inputdialog.png
 *  
 * @code
 * Maui.InputDialog
 * {
 *    id: _dialog
 *    title: "Hello"
 *    message: "An input dialog that request some information ot be entered."
 * 
 *    template.iconSource: "dialog-question"
 *    textEntry.placeholderText: "Give me a name."
 * 
 *    onRejected: close()
 *    onFinished: (text) => console.log(text)
 * }
 * @endcode
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/InputDialog.qml">You can find a more complete example at this link.</a> 
 */
Maui.InfoDialog
{
    id: control
    
    /**
     * @brief An alias to acces the entry field handled by a QQC2 TextField control.
     * @note See Qt documentation on TextField for further information on its properties.
     * @property TextField InputDialog::textEntry
     */
    property alias textEntry: _textEntry
    
    /**
     * @brief Emitted when the dialog has been accepted. 
     * This will depend on keeping the `standardButtons` as they are, or setting one that triggers the accepted role.
     * @note For more information on the standard buttons ad their roles, checkout Qt Dialog docs.
     * @param The text entered in the text entry field.
     */
    signal finished(string text)
    
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    TextField
    {
        id: _textEntry
        Layout.fillWidth: true
        onAccepted: control.standardButton(Dialog.Ok).forceActiveFocus()
    }
    
    onAccepted: 
     {
        finished(textEntry.text)
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
