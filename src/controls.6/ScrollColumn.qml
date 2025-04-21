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

import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.ScrollView
 * @brief A QQC2 ScrollView setup ready for adding any children into a column layout that is scrollable.
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-scrollview.html">This control inherits from QQC2 ScrollView, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * @note The children content is added to a ColumnLayout, so to position the elements use the Layout attached properties.
 *
 * @image html Misc/scrollcolumn.gif
 *
 * @code
 * Maui.ScrollColumn
 * {
 *    anchors.fill: parent
 *
 *    Rectangle
 *    {
 *        implicitHeight: 600
 *        Layout.fillWidth: true
 *        color: "purple"
 *    }
 *
 *    Rectangle
 *    {
 *        implicitHeight: 200
 *        Layout.fillWidth: true
 *        color: "orange"
 *    }
 *
 *    Rectangle
 *    {
 *        implicitHeight: 300
 *        Layout.fillWidth: true
 *        color: "yellow"
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ScrollColumn.qml">You can find a more complete example at this link.</a>
 */
ScrollView
{
    id: control

    /**
     * @brief The default content declared as the children is placed unser a ColumnLayout.
     * @property list<QtObject> ScrollColumn::content
     */
    default property alias content : _pageContent.data

        /**
         * @brief An alias to the children container hanlded by a QQC2 ColumnLayout.
         * @property ColumnLayout ScrollColumn::container
         */
        readonly property alias container : _pageContent

        /**
         * @brief An alias to the QQC2 Flickable element that allows to flick the content. This is exposed to allow to access the Flcikable properties.
         * @note See Qt documentation on the Flickable type.
         *@property Flickable ScrollColumn::flickable
         */
        readonly property alias flickable: _flickable

        padding: Maui.Style.contentMargins
        // bottomPadding: 0 //is this a bug? why does the padding seems to be doubled on the bottom?

        contentWidth: availableWidth
        contentHeight: _pageContent.implicitHeight

        implicitHeight: contentHeight + topPadding + bottomPadding
        implicitWidth: _pageContent.implicitWidth + leftPadding + rightPadding

        spacing: Maui.Style.defaultSpacing

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        Flickable
        {
            id: _flickable

            interactive: Maui.Handy.hasTransientTouchInput

            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds

            ColumnLayout
            {
                id: _pageContent
                width: control.availableWidth
                spacing: control.spacing
            }
        }
}

