/****************************************************************************
**
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
import QtQuick.Templates as T
import org.mauikit.controls as Maui

T.Pane
{
    id: control

    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Maui.Style.contentMargins
    // bottomInset: 10
    background: Rectangle
    {
        color: control.Maui.Controls.level && control.Maui.Controls.level === Maui.Controls.Secondary ? Maui.Theme.backgroundColor: Maui.Theme.backgroundColor

        Behavior on border.color
        {
            Maui.ColorTransition{}
        }

        border.color: switch(control.Maui.Controls.status)
        {
                                  case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
                                  case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
                                  case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
                                  default: return "transparent"
                              }
        Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
}
