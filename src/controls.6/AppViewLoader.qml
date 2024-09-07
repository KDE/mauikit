/*
 *   Copyright 2020 Camilo Higuita <milo.h@aol.com>
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
import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Loader
 * @since org.mauikit.controls 1.0
 *
 * @brief A companion for the AppViews control, for lazy-loading the views to not drain too much resources.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-loader.html">This controls inherits from QQC2 Loader, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * This element wraps a component into a loader that is active only if it is the next, current or previous view in use, or if it has already been created once.
 * This component is useful when the AppViews has more then 4 different views to relief the loading of many views at the same time all at once.
 *
 * This control will also display a progress bar element at the bottom of the view - indicating the progress of loading the hosted component.
 * @see ProgressIndicator
 *
 * @note Remember to set the Controls metadata information, such as title and icon, using the attached properties.
 * @see AppView
 *
 * @code
 * AppViews
 * {
 *    AppViewLoader
 *    {
 *        Controls.title: i18n("Songs")
 *        Controls.iconName: "view-media-track"
 *
 *        Item { } ///The child element to be used as the Component to be loaded.
 *    }
 * }
 * @endcode
 *
 * @note To improve the efficiency of loading time, this control will load its component asynchronously. This can be disabled by setting `asynchronous: false`
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/AppViewLoader.qml">You can find a more complete example at this link.</a>
 *
 *
 */
Loader
{
    id: control

    asynchronous: true
    active: (SwipeView.view.visible && SwipeView.isCurrentItem) || item

    /**
     * @brief By default the single element declared as the child will be used as the component to be loaded.
     * @property Component AppViewLoader::content
     */
    default property alias content : control.sourceComponent

        OpacityAnimator on opacity
        {
            from: 0
            to: 1
            duration: Maui.Style.units.longDuration
            running: control.status === Loader.Ready
        }

        Maui.ProgressIndicator
        {
            width: parent.width
            anchors.bottom: parent.bottom
            visible: control.status === Loader.Loading
        }
}
