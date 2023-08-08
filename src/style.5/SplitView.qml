// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.15
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui

T.SplitView
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    clip: true
    focus: true
    padding: 0

    Component
    {
        id: _horizontalHandleComponent

        Rectangle
        {
            Maui.Theme.colorSet: Maui.Theme.Window
            Maui.Theme.inherit: false

            implicitWidth: Maui.Handy.isMobile ? 8 : 4
            implicitHeight: Maui.Handy.isMobile ? 8 : 4

            color: Maui.Theme.backgroundColor

            Behavior on color
            {
                Maui.ColorTransition{}
            }

            Rectangle
            {
                property int length: pressed ? 80 : 48

                Behavior on length
                {
                    NumberAnimation
                    {
                        duration: Maui.Style.units.shortDuration
                    }
                }

                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: Maui.Style.units.shortDuration
                    }
                }

                opacity: pressed ? 1 : 0.2

                anchors.centerIn: parent
                height: Maui.Handy.isMobile ? 6 : 4
                width: length
                radius: height

                color: pressed || control.T.SplitHandle.hovered  ? Maui.Theme.highlightColor : Maui.Theme.textColor

                Behavior on color
                {
                    Maui.ColorTransition{}
                }
            }
        }
    }

    Component
    {
        id: _verticalHandleComponent

        Rectangle
        {
            Maui.Theme.colorSet: Maui.Theme.Window
            Maui.Theme.inherit: false

            implicitWidth: Maui.Handy.isMobile ? 8 : 4
            implicitHeight: Maui.Handy.isMobile ? 8 : 4

            color: Maui.Theme.backgroundColor

            Behavior on color
            {
                Maui.ColorTransition{}
            }

            Rectangle
            {
                property int length: pressed ? 80 : 48

                Behavior on length
                {
                    NumberAnimation
                    {
                        duration: 100
                    }
                }

                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: 100
                    }
                }

                Behavior on color
                {
                    Maui.ColorTransition{}
                }

                opacity: pressed ? 1 : 0.2
                anchors.centerIn: parent
                height: length
                width: Maui.Handy.isMobile ? 6 : 4
                radius: width
                color: pressed || control.T.SplitHandle.hovered ? Maui.Theme.highlightColor : Maui.Theme.textColor
            }
        }
    }

    handle: Loader
    {
        //        asynchronous: true
        z: control.z +9999
        property bool pressed: T.SplitHandle.pressed
        sourceComponent: control.orientation === Qt.Horizontal ? _verticalHandleComponent : _horizontalHandleComponent
    }
}
