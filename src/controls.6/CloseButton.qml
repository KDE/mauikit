import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.ToolButton
 * @brief The standard control for presenting a close button.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-toolbutton.html">This controls inherits from QQC2 ToolButton, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 *    This control is used to display a close button that is cohesive and uniform across all the different UI elements. 
 *    Consider using this component if your own custom control needs a close button.
 * 
 *    The close button presents to the user a clickable element which represents the intention to exit, quit, close or dismiss an action or visible item.
 * 
 *    It is used, for example, in the TabViewButton to close tabs, in the Chip element to dismiss it, and in some of the dialog.
 */ 
ToolButton
{
    id: control
    
    icon.source: "qrc:/assets/close.svg"
    icon.color: control.hovered || control.containsPress ? control.Maui.Theme.negativeTextColor : control.Maui.Theme.textColor
    
    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: control.hovered || control.containsPress ? Maui.Theme.negativeBackgroundColor : "transparent"        
    }
}
