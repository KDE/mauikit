import QtQuick
import QtQuick.Controls
import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Controls.ProgressBar
 * @brief A QQC2 ProgressBar bu styled to be used as a indetermined progress indicator.
 * Usually used at the bottom of a view.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-progressbar.html">This control inherits from QQC2 ProgressBar, to checkout its inherited properties refer to the Qt Docs.</a>
 */
ProgressBar
{
    id: control
    
    indeterminate: true   
    implicitHeight: 6

    background: Rectangle
    {
        radius: 0
        color: Maui.Theme.backgroundColor
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
