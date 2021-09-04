// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

MenuItem
{
    id: control
    default property list<Action> actions
    implicitWidth: ListView.view.width
    implicitHeight: Maui.Style.rowHeight
    background: null

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: Maui.Style.space.medium
        anchors.rightMargin: Maui.Style.space.medium
        spacing: Maui.Style.space.medium

        Repeater
        {
            model: control.actions

            delegate: ToolButton
            {
                id: _delegate
                Layout.fillWidth: true
                action: modelData
                display: ToolButton.IconOnly
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: ( _delegate.hovered ) && _delegate.text.length 
                ToolTip.text: modelData.text
                
                Connections
                {
                    target: _delegate.action
                    ignoreUnknownSignals: true
                    onTriggered: control.triggered()
                }
            }
        }
    }
}
