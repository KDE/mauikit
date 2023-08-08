/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.15
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui


T.TabBar
{
    id: controlRoot

    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding

    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small

    font: Maui.Style.defaultFont

    contentItem: ListView
    {
        implicitWidth: contentWidth
        implicitHeight: controlRoot.contentModel.get(0).height

        model: controlRoot.contentModel
        currentIndex: controlRoot.currentIndex

        spacing: controlRoot.spacing
        orientation: ListView.Horizontal

        interactive: Maui.Handy.isMobile
        snapMode: ListView.SnapOneItem

        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        highlightResizeDuration : 0

        boundsBehavior: Flickable.StopAtBounds
        boundsMovement: Flickable.StopAtBounds
    }

    background: Rectangle
    {
        color: Maui.Theme.backgroundColor

        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
