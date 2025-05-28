import QtQuick.Controls

/**
 * @inherit QtQuick.Controls.Menu
 *    @brief A convergent contextual menu that adapats to the screen size and device input method.
 *
 *    <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-menu.html">This controls inherits from QQC2 Menu, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 *     @image html Misc/contextualmenu.png "The two displays modes"
 *
 *    @code
 *    Button
 *    {
 *        text: "Click Me!"
 *        onClicked: _contextualMenu.show()
 *
 *        Maui.ContextualMenu
 *        {
 *            id: _contextualMenu
 *
 *            title: "Menu Title"
 *            titleIconSource: "folder"
 *
 *            Action
 *            {
 *                text: "Action1"
 *                icon.name: "love"
 *            }
 *
 *            Action
 *            {
 *                text: "Action2"
 *                icon.name: "folder"
 *            }
 *
 *            MenuSeparator {}
 *
 *            MenuItem
 *            {
 *                text: "Action3"
 *                icon.name: "actor"
 *            }
 *
 *            MenuItem
 *            {
 *                text: "Action4"
 *                icon.name: "anchor"
 *            }
 *        }
 *    }
 *    @endcode
 *
 *    @section notes Notes
 *
 *    This control will depend on using the Maui Style, for the Menu to have the neded properties.
 *    The properties of the Menu control form the style are unique to Maui, and obscure the documentation of its functionality, this is done to support thoe properties to also the regular QQC2 Menu control.
 *
 *    The obscured properties are the following:
 *    - title ContextualMenu::title
 *    - titleImageSource ContextualMenu::titleImageSource
 *    - titleIconSource ContextualMenu::titleIconSource
 *
 *    There is also the readonyl property `responsive` which indicates if the menu is being shown in a "responsibe" manner. Resposinve is assigned to mobile devices, and it is positioned in the bottom part of the screen, while on desktop mode the menu popups from where it has been invoked from.
 *
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ContextualMenu.qml">You can find a more complete example at this link.</a>
 */
Menu
{
    id: control

    /**
     * @brief Instead of calling the `open()` function from the Menu control, you should invoke this function. This will take care of positioning the ContextualMenu popup in the right manner.
     * @param x The x coordinate where to show the menu popup. This is ignored if the menu is `responsive`.
     * @param y The y coordinate where to show the menu popup. This is ignored if the menu is `responsive`.
     * @param parent The parent item from where the coordinates are based on to popup the menu.
     */
    function show(x, y, parent)
    {
        if (control.responsive)
        {
            control.open()
        }
        else
        {
            control.popup()
        }
    }
}

