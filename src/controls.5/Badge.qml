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

import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

/*!
\since org.mauikit.controls 1.0
\inqmlmodule org.mauikit.controls
\brief Badge to show a counter or an icon as a notification hint.
*/
Rectangle
{
    id: control

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Complementary

    /*!
      \qmlproperty bool ApplicationWindow::item

      The current item being used, a label or an icon
    */
    property alias item : loader.item

    /*!
      \qmlproperty bool ApplicationWindow::hovered

      If the badge is hovered by a cursor
    */
    readonly property alias hovered : mouseArea.containsMouse

    /*!
      \qmlproperty bool ApplicationWindow::pressed

      If the badge is pressed
    */
    readonly property alias pressed : mouseArea.pressed

    /*!
      \qmlproperty MouseArea ApplicationWindow::mouseArea
    */
    property alias mouseArea : mouseArea

    /*!
      Size of the badge. Can be used as width and height, unless the implicitWidth is wider.
    */
    property int size: Maui.Style.iconSizes.medium

    /*!
      Name of the icon to be used by the badge
    */
    property string iconName : ""

    /*!
      Text to be used by the badge
    */
    property string text : ""

    property font font

    font.weight: Font.Bold
    font.bold: true
    font.pointSize: Maui.Style.fontSizes.small


    /**
      * clicked :
      */
    signal clicked()

    /**
      * hovered :
      */
    signal hovered()

    /**
      * released :
      */
    signal released()

    implicitHeight: size
    implicitWidth: loader.sourceComponent == labelComponent ? Math.max(loader.implicitWidth, size) : size

    radius: Math.min(width, height)
    color: Maui.Theme.backgroundColor

    Behavior on color
    {
        Maui.ColorTransition{}
    }
    
    Loader
    {
        id: loader
        anchors.fill: parent
        asynchronous: true
        sourceComponent: control.text.length && !control.iconName.length ? labelComponent : (!control.text.length && control.iconName.length ? iconComponent : undefined)
    }

    Component
    {
        id: labelComponent
        
        Label
        {
            text: control.text
            font: control.font
            color: Maui.Theme.textColor
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }
    }

    Component
    {
        id: iconComponent
        Maui.Icon
        {
            anchors.centerIn: parent
            source: control.iconName
            color: Maui.Theme.textColor
            width: control.size
            height: width
            isMask: true
        }
    }

    MouseArea
    {
        id: mouseArea
        hoverEnabled: true

        readonly property int targetMargin:  Maui.Handy.isTouch ? Maui.Style.space.big : 0

        height: parent.height + targetMargin
        width: parent.width + targetMargin

        anchors.centerIn: parent
        onClicked: control.clicked()
        onReleased: control.released()
    }
}
