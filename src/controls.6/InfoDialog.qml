import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.Dialog
 * @brief A Dialog with a built-in template container for displaying information, with a title, image and message body.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-dialog.html">This controls inherits from QQC2 Dialog, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 *  @image html Misc/infodialog.png
 * 
 * @section structure Structure
 * The dialog container is handled by a MauiKit ScrollColumn - which by default is flickable - so any contents added as children of this dialog will be put inside of it and become scrollable/flickable.
 * 
 * @note For the scrollable behaviour to work correctly the child element needs to have an `implicitHeight` size set, and further positioning options should use the Layout attached properties: for filling the with use `Layout.fillWidth: true`.
 * 
 * The InfoDialog uses the ListItemTemplate control to display the information labels and image/icon, this  is exposed via the `template` property for further tweaking.
 * @see template
 * 
 * To set the title use the `title` property. For the message body use the exposed alias property `message`, or the `template.text2` property, which are the same. To set an icon or image use the alias `template` property, for example `template.iconSource: "dialog-warning"`.
 * @see ListItemTemplate
 * 
 * @attention By default the only action button is set to `standardButtons: Dialog.Close`. To know more about other standard button types checkout the Dialog documentation on Qt page.
 * 
 * And finally, the dialog can display an inline notification alert upon request via the `alert()` function.
 * 
 * @remark This alert message is positioned at the bottom part and colored according to the emergency level set.
 * This is useful when the dialog needs to warn the user about certain action.
 * @see alert
 * 
 * @image html Misc/infodialog2.png
 * 
 * @code
 * Maui.InfoDialog
 * {
 *    id: _dialog
 *    title: "Hello"
 *    message: "Information about some important action to be reviewed, or just plain information."
 * 
 *    template.iconSource: "dialog-warning"
 * 
 *    standardButtons: Dialog.Close | Dialog.Apply
 * 
 *    onRejected: close()
 *    onApplied: alert("Are you sure? Alert example.", 2)
 * 
 *    Rectangle //an extra child element
 *    {
 *        color: "yellow"
 *        Layout.fillWidth: true
 *        implicitHeight: 68
 *    }
 * }
 * @endcode
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/InfoDialog.qml">You can find a more complete example at this link.</a> 
 */
Dialog
{
    id: control
    
    /**
     * @brief The default content of the dialog. The children elements of this control will be positioned inside a Mauikit ScrollColumn. 
     * @note To position child elements use the Layout attached properties.
     * @see InfoDialog#structure
     * @property list<QtObject> InfoDialog::content
     */
    default property alias content: _content.content
        
        /**
         * @brief The message body.
         * @property string InfoDialog::message
         */ 
        property alias message : _template.label2.text
        
        /**
         * @brief The templated item used for the default dialog message, holding the icon emblem and the message body. 
         * This property gives access to the template for more detailed tweaking, by adding items or changing its properties.
         * @property ListItemTemplate InfoDialog::template
         */
        property alias template : _template
        
        standardButtons: Dialog.Close
        
        contentItem: Maui.ScrollColumn
        {
            id: _content
            clip: true
            spacing: control.spacing
            
            Maui.ListItemTemplate
            {
                id: _template
                visible: control.message.length
                Layout.fillWidth: true
                label2.textFormat : TextEdit.AutoText
                label2.wrapMode: TextEdit.WordWrap
                iconVisible: control.width > Maui.Style.units.gridUnit * 10
                
                iconSizeHint: Maui.Style.iconSizes.large
                spacing: Maui.Style.space.big
                
                leftLabels.spacing: control.spacing
            }
            
            Maui.Chip
            {
                id: _alertMessage
                
                visible: text.length > 0
                
                property int level : 0
                
                Layout.fillWidth: true
                
                color: switch(level)
                {
                    case 0: return Maui.Theme.positiveBackgroundColor
                    case 1: return Maui.Theme.neutralBackgroundColor
                    case 2: return Maui.Theme.negativeBackgroundColor
                }
                
                SequentialAnimation on x
                {
                    id: _alertAnim
                    // Animations on properties start running by default
                    running: false
                    loops: 3
                    NumberAnimation { from: 0; to: -10; duration: 100; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: -10; to: 0; duration: 100; easing.type: Easing.InOutQuad }
                    PauseAnimation { duration: 50 } // This puts a bit of time between the loop
                }
                
                function reset()
                {
                    _alertMessage.text = ""
                    _alertMessage.level = 0
                }            
            }
        }
        
        onClosed: _alertMessage.reset()
        
        /**
         * @brief Sends an inline alert notification that is displayed in the dialog.
         * @param message The text for the message. Keep it short if possible.
         * @param level Depending on the level the color may differ. The levels are:
         * - 0 positive
         * - 1 neutral
         * - 2 negative
         */
        function alert(message, level)
        {
            _alertMessage.text = message
            _alertMessage.level = level
        }
}
