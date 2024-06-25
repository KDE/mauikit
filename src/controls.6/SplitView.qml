// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.SplitView
 * @brief An extension to the QQC2 SplitView control, adding some extra functionality.
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-splitview.html">This controls inherits from QQC2 SplitView, to checkout its inherited properties refer to the Qt Docs.</a>
 * This control add a quick way to add split views and remove them.
 * @see addSplit
 * @see closeSplit
 *
 * @image html Misc/splitview.png
 *
 * @code
 * Maui.SplitView
 * {
 *    anchors.fill: parent
 *
 *    Maui.SplitViewItem
 *    {
 *        Rectangle
 *        {
 *            color: "orange"
 *            anchors.fill: parent
 *        }
 *    }
 *
 *    Maui.SplitViewItem
 *    {
 *        Rectangle
 *        {
 *            color: "yellow"
 *            anchors.fill: parent
 *        }
 *    }
 * }
 * @endcode
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/SplitView.qml">You can find a more complete example at this link.</a>
 */
SplitView
{
    id: control

    clip: false

    onCurrentItemChanged:
    {
        currentItem.forceActiveFocus()
    }

    /**
     * @brief Forces to close the split view at a given index.
     * If there is only one view at the time, then this method does nothing, in order to keep the control with at least one view.
     * @note This function calls to the SplitView `removeItem` function.
     * @param index the index of view to be closed
     */
    function closeSplit(index)
    {
        if(control.count === 1)
        {
            return // do not close all
        }

        control.removeItem(control.takeItem(index))
    }

    /**
     * @brief Adds a QQC2 Component as a view to the control.
     * @param component The QQC2 Component wrapping the view to be added. Consider using a MauiKit SplitViewItem control as the view root element.
     * @param properties an optional map of properties to be applied to the created view component
     * @return the newly created object view.
     */
    function addSplit(component, properties)
    {
        const object = component.createObject(control.contentModel, properties);

        control.addItem(object)
        control.currentIndex = Math.max(control.count -1, 0)

        object.forceActiveFocus()

        return object
    }
}
