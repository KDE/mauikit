import QtQuick
import QtQuick.Controls

import org.mauikit.controls 1.3 as Maui
import "private" as Private

/**
 * @brief A view with a collapsible sidebar.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-item.html">This controls inherits from QQC2 Item, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * The SideBarView is a convenient way for organizing the application contents into view alongside with a side-bar, which can be resized, collased, hidden and tweaked further. This control adapts to small screen spaces.
 *
 * @image html SideBarView/sidebar_empty.png
 *
 * @section sections Sections
 * The SideBarView is divided into two sections, the sidebar container and the main contents area.
 *
 * @subsection sidebar SideBar
 * The sidebar area can contain any number children items, and its positioning must be handled manually, either by anchoring or using the size and coordinates properties - anchoring to fill its parent is the best way to go, since the sidebar container can changed its size and positioning.
 *
 * Once a child item has been set, other properties can be visited, such as setting the sidebar preferred and minimum width, or deciding if the sidebar will be resize-able or not. Those properties can be accessed via the alias property of the sidebar.
 * @see sideBar
 *
 * The sidebar can be hidden at the application startup, to tweak this behaviour the auto hide properties can be set accordingly.
 * The sidebar can also be collapsed, and this behavior can be fine-tuned, by either deciding if when collapsing the sidebar should stay visible or not.
 *
 * Tweaking the look of the sidebar can also be achieved by changing its background and padding properties. Those all properties are accessible via the alias property `sideBar` - and a few more methods for closing or opening the sidebar.
 * @see SideBar
 *
 * @image html SideBarView/sidebar_collapsed.png "The sidebar is collapsed and expanded, shifting the main area content"
 *
 * @subsection maincontent Content
 * The position of the main content of the SideBarView has to be done by the child item.
 * The default behaviour of the main content is be to shifted/moved when the sidebar being collapsed is expanded.
 *
 * @code
 * Maui.SideBarView
 * {
 *    id: _sideBar
 *    anchors.fill: parent
 *
 *    sideBarContent: Maui.Page
 *    {
 *        Maui.Theme.colorSet: Maui.Theme.Window
 *        anchors.fill: parent
 *
 *        headBar.leftContent: Maui.ToolButtonMenu
 *        {
 *            icon.name: "application-menu"
 *            MenuItem
 *            {
 *                text: "About"
 *                icon.name: "info-dialog"
 *                onTriggered: root.about()
 *            }
 *        }
 *
 *        Maui.Holder
 *        {
 *            anchors.fill: parent
 *            title: "SideBar"
 *            body: "Collapsable."
 *            emoji: "folder"
 *        }
 *    }
 *
 *    Maui.Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *
 *        headBar.leftContent: ToolButton
 *        {
 *            icon.name: _sideBar.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
 *            onClicked: _sideBar.sideBar.toggle()
 *        }
 *
 *        Maui.Holder
 *        {
 *            anchors.fill: parent
 *            title: "Page"
 *            body: "Page main content."
 *            emoji: "application-x-addon-symbolic"
 *        }
 *    }
 * }
 * @endcode
 *
 * @section notes Notes
 *
 * The width of the sidebar section will always be restrained to a maximum value less than the window width - by reserving a sane margin to be able to close the sidebar by clicking/pressing outside of it.
 *
 * To place an item in the sidebar, use the exposed alias property.
 * @see sideBarContent
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SideBarView.qml">You can find a more complete example at this link.</a>
 *
 */
Item
{
    id: control

    /**
     * @brief
     * All child items declared will become part of the main area section.
     * @property list<QtObject> SideBarView::content
     */
    default property alias content : _content.data

        /**
         * @brief Convenient property to easily add items to the sidebar section.
         * @property list<QtObject> SideBarView::sideBarContent
         */
        property alias sideBarContent: _sideBar.content

        /**
         * @brief This is an alias exposed to access all the sidebar section properties.
         * To know more about the available properties visit the control documentation.
         * @see SideBar
         *
         * @code
         * SideBarView
         * {
         *      sideBar.collapsed: width < 800
         *      sideBar.resizeable: false
         *      sideBar.autoHide: true
         * }
         * @endcode
         */
        readonly property alias sideBar : _sideBar

        Private.SideBar
        {
            id: _sideBar
            height: parent.height
            collapsed: control.width < (preferredWidth * 2.5)
            sideBarView: control
        }

        Item
        {
            anchors.fill: parent
            clip: true
            transform: Translate
            {
                x: control.sideBar.collapsed ? control.sideBar.position * (control.sideBar.width) : 0
            }

            anchors.leftMargin: control.sideBar.collapsed ? 0 : control.sideBar.width  * control.sideBar.position

            Item
            {
                id: _content
                anchors.fill: parent
            }

            Loader
            {
                id: _overlayLoader

                anchors.fill: parent
                active: _sideBar.collapsed && _sideBar.position === 1
                asynchronous: true

                visible: active

                sourceComponent: MouseArea
                {
                    onClicked: _sideBar.close()

                    Rectangle
                    {
                        anchors.fill: parent
                        color: "#000"
                    }

                    OpacityAnimator on opacity
                    {
                        from: 0
                        to: 0.5
                        duration: Maui.Style.units.longDuration
                        running: parent.visible
                    }
                }
            }
        }
}

