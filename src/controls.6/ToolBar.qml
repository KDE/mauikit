/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Window

import org.mauikit.controls as Maui

import QtQuick.Layouts

import "private" as Private

/**
 * @inherit QtQuick.Controls.ToolBar
 * @brief An alternative to QQC2 ToolBar, with a custom horizontal layout - divided into three main sections - left, middle and right.
 *
 * This is a good companion to a page header or footer.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-toolbar.html">This control inherits from QQC2 ToolBar, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * @code
 * QQC2.Page
 * {
 *    header: ToolBar
 *    {
 *        width: parent.width
 *
 *        ToolButton
 *        {
 *            icon.name: "love"
 *        }
 *    }
 * }
 * @endcode
 *
 * The ToolBar sections are divided into five [5] sections, and each one can be easily populated via the alias property. The left and right areas are have two sections, the far-left and far-right, alongside with the left and right.
 * @see farLeftContent
 * @see leftContent
 * @see middleContent
 * @see rightContent
 * @see farRightContent
 *
 *  And lastly there's the middle section - the middle section contents can be centered using the Layout attached properties.
 *  When the left and right contents are not equal in size, the middle content can be forced to be centered using the force center property.
 *  @see forceCenterMiddleContent
 *
 *  @image html ToolBar/footbar_sections_color.png
 *  @note The ToolBar sections divided by colors. The middle section [green] is filling the available space.
 *
 *  The bar contents will become flickable/scrollable when the child items do not fit in the available space. There will be shadows indicating that there is content to be discovered to the left or right sides.
 *  @see fits
 *
 *  If the application window is using CSD - there is a useful property to allow dragging and moving the window by pressing the toolbar area. This can also be disabled if it is undesired.
 *  @see draggable
 *
 * @section notes Notes
 * The middle section is handled by a RowLayout, so child items placed in there can be positioned using the Layout attached properties, such as Layout.fillWidth, Layout.alignment, etc.
 *
 * The other sections will take the size of child items, so any item place into them need to have an implicit size or explicitly set one.
 *
 * The far left/right sections will not be hidden when the contents of the bar does not fit and becomes scrollable, They will remain in place, so place items in those section which are important to stay always visible, and do not over populate them, instead populate the left and right areas.
 *
 *  @image html ToolBar/footbar_fit.png
 *  @note Here the contents of the bar does not fit, so it becomes hidden and can be scrolled/flicked horizontally.
 *
 * @code
 * ToolBar
 * {
 *    farLeftContent: ToolButton
 *    {
 *        icon.name: "love"
 *    }
 *
 *    leftContent: ToolButton
 *    {
 *        icon.name: "folder"
 *    }
 *
 *    middleContent: ToolButton
 *    {
 *        icon.name: "folder-music"
 *        Layout.alignment: Qt.AlignHCenter
 *    }
 *
 *    rightContent: ToolButton
 *    {
 *        icon.name: "download"
 *    }
 *
 *    farRightContent: ToolButton
 *    {
 *        icon.name: "application-menu"
 *    }
 * }
 * @endcode
 *
 *   @note This control supports the attached Controls.showCSD property to display the window control buttons when using CSD.
 *
 *
 *  @image html ToolBar/footbar_sections.png
 *  @note Using the example as the footer of a page, ToolButtons are placed in the different sections.
 *
 */
QQC.ToolBar
{
    id: control

    implicitHeight: preferredHeight + topPadding + bottomPadding

    /**
     * @brief By default any child item of the ToolBar will be positioned at the left section in a row. So using the leftContent property or just declaring the child items without it will have the same effect.
     * @see leftContent
     */
    default property alias content : leftRowContent.content

    /**
         * @brief Set the preferred height of the toolbar. This is the preferred way to set a custom height, instead of setting it up explicitly via the height property. This is used, for example, on the Page control for the pull-back bars feature.
         */
    property int preferredHeight: implicitContentHeight

    /**
         * @brief Forces the middle content to be centered by adding extra space at the left and right sections to match the maximum width, so both left/right side have the same width.
         */
    property bool forceCenterMiddleContent : true

    /**
         * @brief Alias to add items to the left section. Multiple items can be added, separated by a coma and wrapped in brackets [].
         * @property list<QtObject> ToolBar::leftContent
         *
         * @code
         * leftContent: [
         *            Button
         *            {
         *                text: "Test"
         *            },
         *
         *           Button
         *           {
         *               text: "Hello"
         *           }
         *           ]
         * @endcode
         */
    property alias leftContent : leftRowContent.content

    /**
         * @brief Alias to add items to the middle section. Multiple items can be added, separated by a coma and wrapped in brackets [].
         * The container used to host the child items is a ColumnLayout, so child items need to be positioned using the Layout attached properties.
         * @property list<QtObject> ToolBar::middleContent
         */
    property alias middleContent : middleRowContent.data

    /**
         * @brief Alias to add items to the right section. Multiple items can be added, separated by a coma and wrapped in brackets [].
         * @property list<QtObject> ToolBar::rightContent
         */
    property alias rightContent : rightRowContent.content

    /**
         * @brief Alias to add items to the far left section. Multiple items can be added, separated by a coma and wrapped in brackets [].
         * @property list<QtObject> ToolBar::farLeftContent
         */
    property alias farLeftContent : farLeftRowContent.content

    /**
         * @brief Alias to add items to the far right section. Multiple items can be added, separated by a coma and wrapped in brackets [].
         * @property list<QtObject> ToolBar::farRightContent
         */
    property alias farRightContent : farRightRowContent.content

    /**
         * @brief The container for the middle section. Some of its properties can be tweaked, such as the spacing and visibility.
         * @property ColumnLayout ToolBar::middleLayout
         */
    readonly property alias middleLayout : middleRowContent

    /**
         * @brief The container for the left section. Some of its properties can be tweaked, such as the spacing and visibility.
         * @property Item ToolBar::leftLayout
         */
    readonly property alias leftLayout : leftRowContent

    /**
         * @brief The container for the right section. Some of its properties can be tweaked, such as the spacing and visibility.
         * @property Item ToolBar::rightLayout
         */
    readonly property alias rightLayout : rightRowContent

    /**
         * @brief The container for the far right section. Some of its properties can be tweaked, such as the spacing and visibility.
         * @property Item ToolBar::farRightLayout
         */
    readonly property alias farRightLayout : farRightRowContent

    /**
         * @brief The container for the far left section. Some of its properties can be tweaked, such as the spacing and visibility.
         * @property Item ToolBar::farLeftLayout
         */
    readonly property alias farLeftLayout : farLeftRowContent

    /**
         * @brief The ColumnLayout that contains all the sections of the toolbar.
         * @property ColumnLayout ToolBar::layout
         */
    readonly property alias layout : layout

    /**
         * @brief If the contents width is currently smaller then the available area it means that it fits, otherwise the content is wider then the available area and overflowing and has become scrollable/flickable.
         */
    readonly property alias fits : _scrollView.fits

    /**
         * @brief The total amount of items in the toolbar sections, items can be non-visible and sum-up.
         */
    readonly property int count : leftContent.length + middleContent.length + rightContent.length + farLeftContent.length + farRightContent.length

    /**
         * @brief The total amount of visible items in the tool bar sections.
         */
    readonly property int visibleCount : leftRowContent.visibleChildren.length + middleRowContent.visibleChildren.length  + rightRowContent.visibleChildren.length + farLeftRowContent.visibleChildren.length  + farRightRowContent.visibleChildren.length

    /**
         * @brief Allow to move the window around by dragging from the toolbar area.
         * By default this is set to `!Maui.Handy.isMobile`
         */
    property bool draggable : !Maui.Handy.isMobile

    Loader
    {
        asynchronous: true
        width: Maui.Style.iconSizes.medium
        height: parent.height
        active: !mainFlickable.atXEnd && !control.fits
        visible: active
        z: 999
        parent: control.background
        anchors
        {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        sourceComponent: Maui.EdgeShadow
        {
            edge: Qt.RightEdge
        }
    }

    Loader
    {
        parent: control.background
        asynchronous: true
        width: Maui.Style.iconSizes.medium
        height: parent.height
        active: !mainFlickable.atXBeginning && !control.fits
        visible: active
        z: 999
        anchors
        {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        sourceComponent: Maui.EdgeShadow
        {
            edge: Qt.LeftEdge
        }
    }

    contentItem: Item
    {
        implicitWidth: _mainLayout.implicitWidth
        implicitHeight: _mainLayout.implicitHeight
        clip: true

        Item
        {
            id: _container
            height: control.preferredHeight
            width: parent.width

            property bool isHeader: control.position === ToolBar.Header
            state: isHeader? "headerState" : "footerState"

            Loader
            {
                active: control.draggable
                asynchronous: true
                anchors.fill: parent
                sourceComponent: Item
                {
                    TapHandler
                    {
                        onTapped: if (tapCount === 2) toggleMaximized()
                        gesturePolicy: TapHandler.DragThreshold
                    }

                    DragHandler
                    {
                        target: null
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        grabPermissions: TapHandler.CanTakeOverFromAnything
                        onActiveChanged: if (active) {  control.Window.window.startSystemMove(); }
                    }
                }
            }

            states: [State
                {
                    name: "headerState"

                    AnchorChanges
                    {
                        target: _container
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                    }
                },

                State
                {
                    name: "footerState"

                    AnchorChanges
                    {
                        target: _container
                        anchors.top: parent.top
                        anchors.bottom: undefined
                    }
                }
            ]

            RowLayout
            {
                id: _mainLayout
                anchors.fill: parent
                spacing: control.spacing

                Private.ToolBarSection
                {
                    id: farLeftRowContent
                    Layout.fillHeight: true
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumWidth: implicitWidth
                    spacing: control.spacing
                    Layout.preferredWidth: visible ? implicitWidth: -control.spacing
                }

                QQC.ScrollView
                {
                    id: _scrollView
                    padding: 0
                    implicitHeight: layout.implicitHeight + topPadding + bottomPadding
                    readonly property bool fits : contentWidth < width
                    onFitsChanged: mainFlickable.returnToBounds()

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    contentWidth: layout.implicitWidth
                    contentHeight: availableHeight

                    Maui.Controls.orientation : Qt.Horizontal
                    
                    QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff
                    QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AlwaysOff

                    Flickable
                    {
                        id: mainFlickable

                        flickableDirection: Flickable.HorizontalFlick
                        interactive: !control.fits && Maui.Handy.isTouch

                        boundsBehavior: Flickable.StopAtBounds
                        boundsMovement :Flickable.StopAtBounds

                        clip: true

                        RowLayout
                        {
                            id: layout

                            width: _scrollView.availableWidth
                            height: _scrollView.availableHeight

                            spacing: control.spacing

                            Private.ToolBarSection
                            {
                                id: leftRowContent

                                Layout.fillHeight: true

                                Layout.maximumWidth: implicitWidth
                                Layout.minimumWidth: implicitWidth
                                Layout.preferredWidth: visible ? implicitWidth: -control.spacing
                                //
                                spacing: control.spacing
                            }

                            // Item //helper to force center middle content
                            // {
                            //     id: _h1
                            //     visible: middleRowContent.visibleChildren.length && control.forceCenterMiddleContent
                            // 
                            //     readonly property int mwidth : visible ? Math.max((rightRowContent.implicitWidth + farRightRowContent.implicitWidth) - (leftRowContent.implicitWidth + farLeftRowContent.implicitWidth), 0) : 0
                            // 
                            //     Layout.minimumWidth: 0
                            // 
                            //     Layout.preferredWidth: mwidth
                            //     Layout.maximumWidth: mwidth
                            // 
                            //     Layout.fillHeight: true
                            //     Layout.fillWidth: true
                            // }

                            Item
                            {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumWidth: implicitWidth
                                implicitWidth: middleRowContent.implicitWidth
                                implicitHeight: middleRowContent.implicitHeight
                                //                                color: "yellow"
                                RowLayout
                                {
                                    id: middleRowContent
                                    anchors.fill: parent
                                    spacing: control.spacing
                                }
                            }

                            // Item //helper to force center middle content
                            // {
                            //     id: _h2
                            //     visible: middleRowContent.visibleChildren.length && control.forceCenterMiddleContent
                            // 
                            //     readonly property int mwidth : visible ? Math.max(( leftRowContent.implicitWidth + farLeftRowContent.implicitWidth) - (rightRowContent.implicitWidth + farRightRowContent.implicitWidth), 0) : 0
                            // 
                            //     Layout.minimumWidth: 0
                            // 
                            //     Layout.fillHeight: true
                            //     Layout.fillWidth: true
                            // 
                            //     Layout.preferredWidth: mwidth
                            //     Layout.maximumWidth: mwidth
                            // }

                            Private.ToolBarSection
                            {
                                id: rightRowContent

                                Layout.fillHeight: true

                                Layout.maximumWidth: implicitWidth
                                Layout.minimumWidth: implicitWidth
                                Layout.preferredWidth: visible ? implicitWidth: -control.spacing
                                
                                spacing: control.spacing
                            }
                        }
                    }
                }

                Private.ToolBarSection
                {
                    id: farRightRowContent
                    Layout.fillHeight: true
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumWidth: implicitWidth
                    spacing: control.spacing
                    Layout.preferredWidth: visible ? implicitWidth: -control.spacing                    
                }

                Loader
                {
                    id: _csdLoader
                    active: control.Maui.Controls.showCSD === true && control.position === ToolBar.Header
                    visible: active

                    OpacityAnimator on opacity
                    {
                        from: 0
                        to: 1
                        duration: Maui.Style.units.longDuration * 2
                        running: _csdLoader.status === Loader.Ready
                    }

                    asynchronous: true

                    sourceComponent: Maui.WindowControls {}
                }
            }
        }
    }
}
