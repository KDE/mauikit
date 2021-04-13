// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Layouts 1.10
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import QtQuick.Window 2.15
import QtGraphicalEffects 1.0

Item
{
    id: control
    //     visible: _loader.item ? _loader.item.visible : false

    default property alias contentData: _menu.contentData
    visible : _menu.visible

    property bool responsive: false

    signal opened()
    signal closed()

    Menu
    {
        id: _menu
        onOpened: control.opened()
        onClosed: control.closed()

        spacing: control.responsive ?  Maui.Style.space.medium : 0

        parent: control.responsive ?  window() : undefined

        x: control.responsive ? 0 : 0
        y: control.responsive ? window().height - height : 0

        width: control.responsive ? window().width :  Math.max(250,
                                                               contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0)

        height: control.responsive ? Math.min(window().height * 0.5, contentHeight + Maui.Style.space.big) :  Math.max(background ? background.implicitHeight : 0,
                                                                                                                       contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding

        modal: control.responsive
        margins: 0
        //             spacing: Maui.Style.space.medium

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        topPadding: Maui.Style.space.medium
        bottomPadding: Maui.Style.space.medium
        padding: 2

        enter: Transition
        {
            NumberAnimation
            {
                property: control.responsive ? "y" : ""
                from: window().height
                to: window().height - _menu.height
                easing.type: Easing.InOutQuad
                duration: Kirigami.Units.shortDuration
            }
        }

        exit: Transition
        {
            enabled: control.responsive

            NumberAnimation
            {
                property: control.responsive ? "y" : ""
                from: _menu.y
                to: window().height
                easing.type: Easing.InOutQuad
                duration: Kirigami.Units.shortDuration
            }
        }



        background: Rectangle
        {
            implicitWidth: Kirigami.Units.gridUnit * 8
            color: Kirigami.Theme.backgroundColor
            radius: control.responsive ? 0 : Maui.Style.radiusV

            Rectangle
            {
                anchors.fill: parent
                radius: Maui.Style.radiusV
                color: "transparent"
                border.color: Qt.darker(Kirigami.Theme.backgroundColor, 2.7)
                opacity: 0.6

                Rectangle
                {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    radius: parent.radius - 0.5
                    border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
                    opacity: 0.7
                }

            }
            
            Maui.Separator
            {
                visible: control.responsive
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                edge: Qt.TopEdge
            }
        }

    }

    function open(x, y, parent)
    {
        if (control.responsive)
        {
            _menu.open()
        }
        else
        {
            _menu.popup(parent,x ,y)
        }
    }

    function close()
    {
        _menu.close()
    }

    function insertItem(index, item)
    {
        _menu.insertItem(index, item)
    }

    function addItem( item)
    {
        _menu.addItem(item)
    }
}

