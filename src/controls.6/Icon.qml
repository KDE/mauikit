import QtQuick
import org.mauikit.controls as Maui

/**
 * @inherit Icon
 * @brief An item for displaying an icon from an asset or from the icon theme, or from an image source.
 * 
 * @warning This element is just an alias around the Icon object. Checkout the Icon properties for more details.
 * @see Icon.
 */
Maui.PrivateIcon
{
    id: control
    
    implicitHeight: Maui.Style.iconSize
    implicitWidth: implicitHeight
    
    /**
     * @brief The current icon theme being used as part of the Maui Shell.
     * This is exposed to check changes on the used icon theme for hot reloading the icons.
     */
    readonly property string currentIconTheme: Maui.Style.currentIconTheme
    
    onCurrentIconThemeChanged:
    {
        control.refresh();
    }
}

