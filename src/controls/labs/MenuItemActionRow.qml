// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

T.MenuItem
{
    id: control
    default property list<Action> actions
    implicitHeight: Math.max( Maui.Style.rowHeight, _layoutLoader.item.implicitHeight) + topPadding + bottomPadding
    width: ListView.view.width
    background: null
    
    display : width > Kirigami.Units.gridUnit * 28 && control.actions.length <= 3 ?  ToolButton.TextBesideIcon : (Kirigami.Settings.isMobile ? ToolButton.TextUnderIcon : ToolButton.IconOnly)
    padding: 0

    contentItem: Loader
    {
        id: _layoutLoader
        asynchronous: true

        sourceComponent: RowLayout
        {
            spacing: Maui.Style.space.medium

            Repeater
            {
                id: _repeater
                model: control.actions

                delegate: ToolButton
                {
                    id: _delegate
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    action: modelData
                    display: control.display
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: ( _delegate.hovered ) && _delegate.text.length
                    ToolTip.text: modelData.text

                    Connections
                    {
                        target: _delegate.action
                        ignoreUnknownSignals: true
                        function onTriggered()
                        {
                            control.triggered()
                        }
                    }
                }
            }
        }
    }
}
