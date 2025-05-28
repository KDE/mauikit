import QtQuick
import QtQml
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit Page
 * @since org.mauikit.controls 1.0
 *
 *    @brief A convinient way of switching between a grid an a list view.
 *
 *    This controls inherits from MauiKit Page, to checkout its inherited properties refer to the docs.
 *    @see Page
 *
 *    @note This control supports the attached `Controls.showCSD` property to display the window control buttons when using CSD.
 *
 *    The AltBrowser makes use of the GridView and ListBrowser components, there is a property to dinamically switch between the two.
 *
 *    For some navigation patterns is a good idea to provide a grid view when the application screen size is wide enough to fit numerous items and a list view when the space is contrained - since the list is much more compact - and makes navigation quicker.
 *    @see viewType
 *
 *    @image html AltBrowser/views.gif "Switching between the list and grid view"
 *
 *    @section notes Notes
 *    The data model is shared by both of the view types, but the delagates to be used have to be assigment for each one.
 *    @see listDelegate
 *    @see gridDelegate
 *
 *    There is a MauiKit Holder element that can be used to display a placeholder message, for example, when the views are empty.
 *    @see holder
 *
 *    @code
 *    Maui.AltBrowser
 *    {
 *        id: _altBrowser
 *        anchors.fill: parent
 *
 *        Maui.Controls.showCSD: true
 *        viewType: Maui.AltBrowser.ViewType.Grid
 *
 *        gridView.itemSize: 120
 *
 *        headBar.leftContent: ToolButton
 *        {
 *            icon.name: _altBrowser.viewType === Maui.AltBrowser.ViewType.Grid ? "view-list-details" : "view-list-icons"
 *            onClicked: _altBrowser.toggle()
 *        }
 *
 *        model: 20
 *
 *        listDelegate: Maui.ListBrowserDelegate
 *        {
 *            width:ListView.view.width
 *            label1.text: index
 *            label2.text: "Example"
 *            iconSource: "folder"
 *        }
 *
 *        gridDelegate: Maui.GridBrowserDelegate
 *        {
 *            height: GridView.view.cellHeight
 *            width: GridView.view.itemSize
 *
 *            iconSource: "folder"
 *            label1.text: index
 *            label2.text: "Example"
 *        }
 *    }
 *    @endcode
 *
 *      <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/AltBrowser.qml">You can find a more complete example at this link.</a>
 */
Maui.Page
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false

    focus: true
    clip: false

    /**
     * @brief The current view being used, the GridView or the ListBrowser.
     * To access the precise view use the aliases for the GridView or ListView.
     * @see listView
     * @see gridView
     */
    readonly property Item currentView : control.viewType === AltBrowser.ViewType.List ? _listView : _gridView

    onCurrentViewChanged: control.currentView.forceActiveFocus()

    /**
     * @brief The two different view types possible.
     * @enum Grid AltBrowser.Grid handled by the GridBrowser control.
     * @enum List AltBrowser.List hanlded by the ListBrowser control.
     */
    enum ViewType
    {
        Grid,
        List
    }

    /**
     * @brief Sets the view type that's going to be in use.
     *
     * The type can be one of:
     * - ViewType.Grid
     * - ViewType.List      The default
     *
     * @see ViewType
     */
    property int viewType: AltBrowser.ViewType.List

    /**
     * @brief The index of the current item selected in either view type.
     * This value is synced to both view types.
     */
    property int currentIndex : -1
    Binding on currentIndex
    {
        when: control.currentView
        value: control.currentView.currentIndex
    }

    /**
     * @brief The delegate to be used by the ListBrowser.
     */
    property Component listDelegate : null

    /**
     * @brief The delegate to be used by the GridView.
     */
    property Component gridDelegate : null

    /**
     * @brief The shared data model to be used by both view types.
     */
    property var model : null

    /**
     * @brief Allow the lasso selection for multiple items with mouse or track based input methods.
     */
    property bool enableLassoSelection: false

    /**
     * @brief Allow the selection mode, which sets the views in the mode to accept to select multiple items.
     */
    property bool selectionMode: false

    /**
     * @brief Item to set a place holder emoji and message.
     * For more details on its properties check the Holder component.
     * @property Holder AltBrowser::holder
     *
     * @see Holder
     */
    property alias holder : _holder

    /**
     * @brief The GridBrowser used as the grid view alternative.
     * @property GridBrowser AltBrowser::gridView
     */
    readonly property alias gridView : _gridView

    /**
     * The ListBrowser used as the list view alternative.
     * @property ListBrowser AltBrowser::listView
     */
    readonly property alias listView : _listView

    /**
     * @brief The total amount of items in the current view.
     */
    readonly property int count : currentView.count

    flickable:  currentView.flickable

    Maui.GridBrowser
    {
        id: _gridView

        focus: control.focus
        anchors.fill: parent
        visible: control.viewType === AltBrowser.ViewType.Grid
        currentIndex: control.currentIndex
        model: control.model
        delegate: control.gridDelegate
        enableLassoSelection: control.enableLassoSelection
        selectionMode: control.selectionMode
        adaptContent: true
        clip: control.clip

        OpacityAnimator on opacity
        {
            from: 0
            to: 1
            duration: Maui.Style.units.longDuration * 2
            running: _gridView.visible
            easing.type: Easing.OutInQuad
        }
    }

    Maui.ListBrowser
    {
        id: _listView

        anchors.fill: parent
        focus: control.focus
        visible: control.viewType === AltBrowser.ViewType.List
        currentIndex: control.currentIndex
        model: control.model
        delegate: control.listDelegate
        enableLassoSelection: control.enableLassoSelection
        selectionMode: control.selectionMode
        clip: control.clip

        OpacityAnimator on opacity
        {
            from: 0
            to: 1
            duration: Maui.Style.units.longDuration * 2
            running: _listView.visible
            easing.type: Easing.OutInQuad
        }
    }

    Maui.Holder
    {
        id: _holder
        anchors.fill: parent
        visible: false
        Keys.forwardTo: control.currentView
    }

    /**
     * @brief Toggle between the two views. If in list view then switches to grid, and from grid to list.
     */
    function toggle()
    {
        control.viewType = (control.viewType == Maui.AltBrowser.ViewType.Grid ? Maui.AltBrowser.ViewType.List : Maui.AltBrowser.ViewType.Grid)
    }
}
