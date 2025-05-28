import QtQuick
import QtQuick.Controls
import QtQuick.Window

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.Control
 * @since org.mauikit.controls
 * @brief CSD Window control buttons.
 * 
 * @warning This is an implementation template for the CSD window control buttons, for a complete and final implementation please use the WindowControls component.
 * @see WindowControlsLinux
 * 
 * @section notes Notes
 * 
 * @subsection customize Customize
 * The window control buttons can be customized, by creating a new theme of button assets, or by picking one from the existing ones. 
 * 
 * Creating a new theme is simple. There is three important aspects:
 * - The config file where the relative paths to the image assets is described.
 * 
 * The following snippet is an example of a config file for the Nitrux CSD theme. 
 * The file name must be named 'config.conf'
 * @code
 * [Close]
 * Normal=close.svg
 * Hover=close-hover.svg
 * Pressed=close-pressed.svg
 * Backdrop=close-backdrop.svg
 * 
 * [Maximize]
 * Normal=maximize.svg
 * Hover=maximize-hover.svg
 * Pressed=maximize-pressed.svg
 * Backdrop=maximize-backdrop.svg
 * 
 * [Restore]
 * Normal=restore.svg
 * Hover=restore-hover.svg
 * Pressed=restore-pressed.svg
 * Backdrop=restore-backdrop.svg
 * 
 * [Minimize]
 * Normal=minimize.svg
 * Hover=minimize-hover.svg
 * Pressed=minimize-pressed.svg
 * Backdrop=minimize-backdrop.svg
 * 
 * [FullScreen]
 * Normal=fullscreen.svg
 * 
 * [Decoration]
 * BorderRadius=8
 * Source=CSD.qml
 * @endcode
 * 
 * - The second part is the QML source file, named CSD.qml by convection. If the theme you imagine is not that different from the regular layout, the following snippet of code will do it.
 * 
 * The code consists of a horizontal row layout, where we feed the buttons model and set the component delegate to draw the button. 
 * @see CSDButton
 * @code
 * Control
 * {
 *    id: control
 * 
 *    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
 *    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
 *    
 *    spacing: Maui.Style.space.small   
 *    padding: Maui.Style.defaultPadding
 *    
 *    background: null
 * 
 *    contentItem: Row
 *    {
 *        id: _layout
 *        spacing: control.spacing
 * 
 *        ToolSeparator
 *        {
 *            height: 8
 *            anchors.verticalCenter: parent.verticalCenter
 *        }
 * 
 *        Repeater
 *        {
 *            model: buttonsModel
 *            delegate: pluginButton
 *        }
 *    }
 * 
 *    Component
 *    {
 *        id: pluginButton
 * 
 *        AbstractButton
 *        {
 *            id: _button
 * 
 *            visible: modelData === "A" ? canMaximize : true
 * 
 *            hoverEnabled: true
 * 
 *            implicitWidth: 22
 *            implicitHeight: 22
 * 
 *            focusPolicy: Qt.NoFocus
 *            
 *            Maui.CSDButton
 *            {
 *                id: button
 *                style: "Nitrux"
 *                type: mapType(modelData)
 *                isHovered: _button.hovered
 *                isPressed: _button.pressed
 *                isFocused:  isActiveWindow
 *                isMaximized: maximized
 *            }
 * 
 *            contentItem:  Maui.Icon
 *                {
 *                    smooth: true
 * 
 *                    source: button.source
 * 
 *                    color: Maui.Theme.textColor
 *                    Behavior on color
 *                    {
 *                        Maui.ColorTransition{}
 *                    }
 *                }
 *            
 *            
 *            onClicked:
 *            {
 *                console.log("NITRUX CSD BUTTON CLICKED", button.type)
 *                buttonClicked(button.type)
 *            }
 *        }
 *    }
 * }
 * @endcode
 * 
 * - And the last part are the actual image assets for the buttons.
 * 
 */
Loader
{
    id: control
    asynchronous: true
    
    property bool maximized : Window.window.visibility === Window.Maximized
    property bool isActiveWindow : Window.window.active
    readonly property bool canMaximize: !(Window.window.isDialog) && (Window.window.width !== Window.window.maximumWidth || Window.window.width !== Window.window.minimumWidth || Window.window.height !== Window.window.maximumHeight || Window.window.height !== Window.window.minimumHeight)
    readonly property bool canMinimize : !(Window.window.isDialog)
    readonly property var buttonsModel : Maui.CSD.rightWindowControls
    
    
    /**
     * A window control button has been clicked. This signal is public and can be mapped to any arbitrary value. Be carefull.
     */
    signal buttonClicked(var type)
    source: Maui.CSD.source
}
