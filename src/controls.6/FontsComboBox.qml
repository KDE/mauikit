/****************************************************************************
 * *
 ** Copyright (C) 2017 The Qt Company Ltd.
 ** Contact: http://www.qt.io/licensing/
 **
 ** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
 **
 ** $QT_BEGIN_LICENSE:LGPL3$
 ** Commercial License Usage
 ** Licensees holding valid commercial Qt licenses may use this file in
 ** accordance with the commercial license agreement provided with the
 ** Software or, alternatively, in accordance with the terms contained in
 ** a written agreement between you and The Qt Company. For licensing terms
 ** and conditions see http://www.qt.io/terms-conditions. For further
 ** information use the contact form at http://www.qt.io/contact-us.
 **
 ** GNU Lesser General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU Lesser
 ** General Public License version 3 as published by the Free Software
 ** Foundation and appearing in the file LICENSE.LGPLv3 included in the
 ** packaging of this file. Please review the following information to
 ** ensure the GNU Lesser General Public License version 3 requirements
 ** will be met: https://www.gnu.org/licenses/lgpl.html.
 **
 ** GNU General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU
 ** General Public License version 2.0 or later as published by the Free
 ** Software Foundation and appearing in the file LICENSE.GPL included in
 ** the packaging of this file. Please review the following information to
 ** ensure the GNU General Public License version 2.0 requirements will be
 ** met: http://www.gnu.org/licenses/gpl-2.0.html.
 **
 ** $QT_END_LICENSE$
 **
 ****************************************************************************/

import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.ComboBox
 * @brief A combo-box element to list the system fonts with a inline style preview. 
 * 
 *  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-combobox.html">This controls inherits from QQC2 ComboBox, to checkout its inherited properties refer to the Qt Docs.</a>
 *  
 *  The default model is set to `Qt.fontFamilies`. If a custom model is to be used instead, set the right role to pick up the data using the `textRole` inherited property.
 *  
 *  @image html Misc/fontscombobox.png
 */

ComboBox
{
    id: control
    
    font.family: control.displayText
    model: Qt.fontFamilies()
    Maui.Controls.iconName: "font"
    
    delegate: MenuItem
    {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.family: text      
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
        Maui.Theme.colorSet: control.Maui.Theme.inherit ? control.Maui.Theme.colorSet : Maui.Theme.View
        Maui.Theme.inherit: control.Maui.Theme.inherit
    }
}
