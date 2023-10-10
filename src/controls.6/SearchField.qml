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

import QtQuick
import QtQuick.Controls

/**
 * @brief This is just a QQC2 TextField with a icon to more clearly indicate its intended use case for entering search queries
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-textfield.html">This control inherits from QQC2 TextField, to checkout its inherited properties refer to the Qt Docs.</a>
 *  
 *  @section notes Notes
 *  Some TextField properties have been added to the Maui Style, so they have been obscured, those properties are:
 *  
 *  - `spacing : int` The spacing between the action buttons, added via the `actions` property.
 *  - `menu : Menu` An alias to access the contextual menu, containing entries, such as Copy, Cut, Paste, etc. More entries could be dynamically added using the Menu methods.
 *  - `actions : list<Action>` A set of actions, that will be represented inside of the text field box as flat icons.
 *  - `icon : Icon` The icon to be used in the text field left area. This is an extra visual hint to let the user know what the text field is for, besides the use of the `placeholdertext` property.
 *  - `rightContent : list<QtObject>` An alias to allow adding arbitrary content inside of the right area of the text field box.
 *  
 *  - `cleared()` Emitted when the text field has been cleared using the clear action button.
 *  - `contentDropped(drop)` Emitted when some content has been drag and dropped on the text field area. The `drop` parameter has the information on the event.
 */
TextField
{
    id: control    
    icon.source: "edit-find"
}
