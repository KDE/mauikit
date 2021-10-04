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

import QtQuick 2.14
import QtQuick.Controls 2.14

import org.mauikit.controls 1.2 as Maui

/**
 * SideBar
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.AbstractSideBar
{
    id: control

    /**
      * model : var
      */
    property alias model : _listBrowser.model

    /**
      * count : int
      */
    property alias count : _listBrowser.count

    /**
      * section : ListView.section
      */
    property alias section : _listBrowser.section

    /**
      * currentIndex : int
      */
    property alias currentIndex: _listBrowser.currentIndex

    /**
     *
     */
    property alias listView : _listBrowser

    /**
      * delegate : Component
      */
    property Component delegate : Maui.ListDelegate
    {
        id: itemDelegate
        width: ListView.view.width
        iconSize: Maui.Style.iconSizes.small
        label: model.label
        iconName: model.icon +  (Qt.platform.os == "android" || Qt.platform.os == "osx" ? ("-sidebar") : "")
        iconVisible: true
        template.leftMargin: Maui.Style.space.medium

        onClicked:
        {
            control.currentIndex = index
            control.itemClicked(index)
        }

        onRightClicked:
        {
            control.currentIndex = index
            control.itemRightClicked(index)
        }

        onPressAndHold:
        {
            control.currentIndex = index
            control.itemRightClicked(index)
        }
    }

    /**
      * itemClicked :
      */
    signal itemClicked(int index)

    /**
      * itemRightClicked :
      */
    signal itemRightClicked(int index)

    Maui.ListBrowser
    {
        id: _listBrowser
        anchors.fill: parent
        topPadding: 0
        bottomPadding: 0
        verticalScrollBarPolicy: ScrollBar.AlwaysOff

        delegate: control.delegate

        onKeyPress:
        {
            if(event.key == Qt.Key_Return)
            {
                control.itemClicked(control.currentIndex)
            }
        }
    }
}

