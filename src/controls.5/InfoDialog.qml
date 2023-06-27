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
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui


Dialog
{
    id: control

    default property alias content: _content.content

    /*!
     *    Default message text inside the scrollable layout.
     */
    property string message : ""

    /*!
     *    \qmlproperty ListItemTemplate ApplicationWindow::template
     *
     *    The templated item used for the default dialog message, holding the icon emblem and the message body.
     *    This property gives access to the template for more detailed tweaking, by adding items or changing its properties.
     */
    property alias template : _template

    standardButtons: Dialog.Close

    contentItem: Maui.ScrollColumn
    {
        id: _content
        clip: true
        spacing: control.spacing

        Maui.ListItemTemplate
        {
            id: _template
            visible: control.message.length
            Layout.fillWidth: true
            label2.text: message
            label2.textFormat : TextEdit.AutoText
            label2.wrapMode: TextEdit.WordWrap
            iconVisible: control.width > Maui.Style.units.gridUnit * 10

            iconSizeHint: Maui.Style.iconSizes.large
            spacing: Maui.Style.space.big

            leftLabels.spacing: control.spacing
        }

        Maui.Chip
        {
            id: _alertMessage

            visible: text.length > 0

            property int level : 0

            Layout.fillWidth: true

            color: switch(level)
                   {
                   case 0: return Maui.Theme.positiveBackgroundColor
                   case 1: return Maui.Theme.neutralBackgroundColor
                   case 2: return Maui.Theme.negativeBackgroundColor
                   }

            SequentialAnimation on x
            {
                id: _alertAnim
                // Animations on properties start running by default
                running: false
                loops: 3
                NumberAnimation { from: 0; to: -10; duration: 100; easing.type: Easing.InOutQuad }
                NumberAnimation { from: -10; to: 0; duration: 100; easing.type: Easing.InOutQuad }
                PauseAnimation { duration: 50 } // This puts a bit of time between the loop
            }
        }
    }

    /**
     * Send an alert message that is shown inline in the dialog.
     * Depending on the level the color may differ.
     */
    function alert(message, level)
    {
        _alertMessage.text = message
        _alertMessage.level = level
    }
}
