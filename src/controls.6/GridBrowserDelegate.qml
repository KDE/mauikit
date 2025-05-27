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
import QtQml

import QtQuick.Controls
import org.mauikit.controls as Maui

/**
 * @inherit ItemDelegate
 * @brief A MauiKit ItemDelegate with some extra functionality and an informational column layout.
 *
 *  This controls inherits from MauiKit ItemDelegate, to checkout its inherited properties refer to docs.
 *
 *  @note This is essentially different from QQC2 ItemDelegate control, where the QQC2 can have a text, an icon etc; this one is only a container with some predefined behavior.
 *  @see ItemDelegate
 *
 * @image html Delegates/gridbrowserdelegate.png
 * @note An example of GridBrowserDelegates in the Index -file manager - application.
 *
 *  @section structure Structure
 *  The GridBrowserDelegate layouts the information vertically. It's composed of three main sections: the top icon header, a title label and finally an extra label message. Those sections are all handled by a MauiKit GridItemTemplate control, which is exposed by the alias property `template`.
 *  @see GridItemTemplate
 *
 *  The top icon section is handled by default by a MauiKit IconItem, which hosts an image or icon. Those can be set via the `imageSource` or the `iconSource` properties.
 *  @see IconItem
 *
 *  The top icon header can also be replaced by any other component using the `template.iconComponent` property. An example of a custom icon header is the Mauikit controls GalleryItem and CollageItem, both of which inherit from GridBrowserDelegate and set a custom `template.iconComponent`.
 *
 *  @section notes Notes
 *  This control can be `checkable`, and a CheckBox element will be placed on top of it. It also supports features from the Button type, such as the `autoExclusive`, `checked` properties and the press events.
 *
 *  By inheritance this component can be `dragable`.
 *
 *  @note This control is usually used as the delegate component for the GridBrowser or QQC2 GridView.
 *
 *  @subsection dnd Drag & Drop
 *  To set up the drag and drop, use the Drag attached properties.
 * The most relevant part for this control is to set the `Drag.keys` and `Drag.mimeData`
 *
 * @code
 * Drag.keys: ["text/uri-list"]
 * Drag.mimeData: Drag.active ?
 * {
 *    "text/uri-list": "" //here a list of file separated by a comma.
 * } : {}
 * @endcode
 *
 * @image html Delegates/gridbrowserdelegate2.png
 *
 * @code
 * Maui.GridBrowser
 * {
 *    id: _gridBrowser
 *    anchors.fill: parent
 *    model: 30
 *
 *    itemSize: 120
 *    itemHeight: 120
 *
 *    adaptContent: true
 *
 *    delegate: Item
 *    {
 *        width: GridView.view.cellWidth
 *        height: GridView.view.cellHeight
 *
 *        Maui.GridBrowserDelegate
 *        {
 *            width: _gridBrowser.itemSize
 *            height: width
 *
 *            iconSource: "folder"
 *            iconSizeHint: Maui.Style.iconSizes.big
 *            label1.text: "Title"
 *            label2.text: "Message"
 *
 *            anchors.centerIn: parent
 *        }
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/GridBrowserDelegate.qml">You can find a more complete example at this link.</a>
 */
Maui.ItemDelegate
{
    id: control

    isCurrentItem : GridView.isCurrentItem || checked
    flat : !Maui.Handy.isMobile

    implicitHeight: _template.implicitHeight + topPadding + bottomPadding
    implicitWidth: _template.implicitWidth + leftPadding + rightPadding

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.medium

    radius: Maui.Style.radiusV

    focus: true
    focusPolicy: Qt.TabFocus

    /**
     * @brief An alias to access the GridItemTemplate control properties. This is the template element that layouts all the information: labels and icon/image.
     * @see GridItemTemplate
     * @property GridItemTemplate GridBrowserDelegate::template.
     */
    readonly property alias template : _template

    /**
     * @see GridItemTemplate::label1
     */
    readonly property alias label1 : _template.label1

    /**
     * @see GridItemTemplate::label2
     */
    readonly property alias label2 : _template.label2

    /**
     * @see GridItemTemplate::iconItem
     */
    property alias iconItem : _template.iconItem

    /**
     * @see GridItemTemplate::iconVisible
     */
    property alias iconVisible : _template.iconVisible

    /**
     * @see GridItemTemplate::imageSizeHint
     */
    property alias imageSizeHint : _template.imageSizeHint

    /**
     * @see GridItemTemplate::iconSizeHint
     */
    property alias iconSizeHint : _template.iconSizeHint

    /**
     * @see GridItemTemplate::imageSource
     */
    property alias imageSource : _template.imageSource

    /**
     * @see GridItemTemplate::iconSource
     */
    property alias iconSource : _template.iconSource

    /**
     * @see GridItemTemplate::labelsVisible
     */
    property alias labelsVisible : _template.labelsVisible

    /**
     * @brief Whether the control is checked or not.
     * By default this is set to `false`.
     */
    property bool checked : false

    /**
     * @see GridItemTemplate::fillMode
     */
    property alias fillMode : _template.fillMode

    /**
     * @see GridItemTemplate::maskRadius
     */
    property alias maskRadius : _template.maskRadius

    /**
     * @brief Whether the control should become checkable. If it is checkable a CheckBox element  will become visible to allow to toggle between the checked states.
     * By default this is set to `false`.
     */
    property bool checkable: false

    /**
     * @brief Whether the control should be auto exclusive, this means that among other related elements - sharing the same parent- only one can be selected/checked at the time.
     * By default this is set to `false`.
     */
    property bool autoExclusive: false

    /**
     * @brief An alias to expose the DropArea component in charge of the drag&drop events.
     * @see contentDropped
     */
    readonly property alias dropArea : _dropArea

    /**
     * @see GridItemTemplate::imageWidth
     */
    property alias imageWidth : _template.imageWidth

    /**
     * @see GridItemTemplate::imageHeight
     */
    property alias imageHeight : _template.imageHeight

    /**
     * @brief Emitted when a drop event has been triggered on this control.
     * @param drop The object with information about the event.
     */
    signal contentDropped(var drop)

    /**
     * @brief Emitted when the control checked state has been changed.
     * @param state The checked state value.
     */
    signal toggled(bool state)

    background: Rectangle
    {
        color: (control.isCurrentItem || control.containsPress ? Maui.Theme.highlightColor : ( control.hovered ? Maui.Theme.hoverColor : (control.flat ? "transparent" : Maui.Theme.alternateBackgroundColor)))

        radius: control.radius

        Behavior on color
        {
            enabled: !control.flat
            Maui.ColorTransition{}
        }
    }

    DropArea
    {
        id: _dropArea
        width: parent.width
        height: parent.height
        Rectangle
        {
            anchors.fill: parent
            radius: control.radius
            color:  control.Maui.Theme.backgroundColor
            border.color: control.Maui.Theme.highlightColor
            visible: parent.containsDrag
        }

        onDropped:
        {
            control.contentDropped(drop)
        }
    }

    Maui.GridItemTemplate
    {
        id: _template
        anchors.fill: parent
        iconContainer.scale: _dropArea.containsDrag  || _checkboxLoader.active ? 0.8 : 1
        hovered: control.hovered
        maskRadius: control.radius
        spacing: control.spacing
        isCurrentItem: control.isCurrentItem
        highlighted: control.containsPress
    }

    Loader
    {
        id: _badgeLoader
        asynchronous: true
        active: control.Maui.Controls.badgeText && control.Maui.Controls.badgeText.length > 0 && control.visible

        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenterOffset: -5

        OpacityAnimator on opacity
        {
            from: 0
            to: 1
            duration: Maui.Style.units.longDuration
            running: _badgeLoader.status === Loader.Ready
        }

        ScaleAnimator on scale
        {
            from: 0.5
            to: 1
            duration: Maui.Style.units.longDuration
            running: _badgeLoader.status === Loader.Ready
            easing.type: Easing.OutInQuad
        }

        sourceComponent: Maui.Badge
        {
            text: control.Maui.Controls.badgeText

            padding: 2
            font.pointSize: Maui.Style.fontSizes.tiny
            Maui.Controls.status: Maui.Controls.Negative
        }
    }

    Loader
    {
        id: _checkboxLoader
        asynchronous: true
        active: control.checkable || control.checked

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: Maui.Style.space.medium

        scale: active ? 1 : 0

        Behavior on scale
        {
            NumberAnimation
            {
                duration: Maui.Style.units.longDuration*2
                easing.type: Easing.OutBack
            }
        }

        sourceComponent: CheckBox
        {
            checkable: control.checkable
            autoExclusive: control.autoExclusive

            Binding on checked
            {
                value: control.checked
                restoreMode: Binding.RestoreBinding
                delayed: true
            }

             onToggled:
             {
                 console.log("CHECKEDDDD STATE")
                  control.toggled(checked)
             }
        }
    }
}
