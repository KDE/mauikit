import org.mauikit.controls 1.3 as Maui

/**
 * @inherit ScrollColumn
 * @brief A friend control for the SettingsDialog. Use for creating subpages for the SettingDialog.
 * 
 * The usage is quiet simple, just declare a list of children items and those will be positioned into a scrollable column layout. This is handled by a ColumnLayout, so the elements need to use the Layout attached properties.
 * 
 * @note Consider using the SectionGroup and FlexSectionItem as the children for a cohesive look.
 * 
 * Checkout the MauiKit ScrollColumn for more inherited properties.
 * 
 * @code
 * Component
 * {
 *    id: _settingsPage2
 * 
 *    Maui.SettingsPage
 *    {
 *        title: "Page2"
 * 
 *        Maui.FlexSectionItem
 *        {
 *            label1.text: "Configuration title"
 *            label2.text: "Description text"
 * 
 *            Switch {}
 *        }
 *    }
 * }
 * @endcode
 */
Maui.ScrollColumn
{
    id: control
    spacing: Maui.Style.defaultSpacing*2
    
    /**
     * @brief The title of the settings sub page.
     * By default this is set to english word `"Settings"`.
     */
    property string title : i18nd("mauikit", "Settings")
}
