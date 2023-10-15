/*
 *  SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
 *  SPDX-FileCopyrightText: 2016 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Rectangle
 * @brief A visual separator.
 *
 * Useful as a visual hint for diciding grouped elements.
 *
 * @inherit QtQuick.Rectangle
 */
Rectangle
{
    id: root
    implicitHeight: 1
    implicitWidth: 1
    Accessible.role: Accessible.Separator

    /**
     * @brief Types of weight.
     */
    enum Weight {
        Light,
        Normal
    }

    /**
     * @brief This property holds the visual weight of the separator.
     * 
     * Weight values:
     * * `Separator.Weight.Light`
     * * `Separator.Weight.Normal`
     * 
     * The default is `Separator.Weight.Normal`
     */
    property int weight: Separator.Weight.Normal

    /* TODO: If we get a separator color role, change this to
     * mix weights lower than Normal with the background color
     * and mix weights higher than Normal with the text color.
     */
    color: Maui.ColorUtils.linearInterpolation(Maui.Theme.backgroundColor, Maui.Theme.textColor, weight == Separator.Weight.Light ? 0.07 : 0.15);
    
    Behavior on color
    {
        Maui.ColorTransition{}
    }    
}

