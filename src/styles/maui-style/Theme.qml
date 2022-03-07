/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.7
import org.kde.kirigami 2.16 as Kirigami
import org.mauikit.controls 1.3 as Maui
/**
 * \internal
 */
Kirigami.BasicThemeDefinition 
{
    id: theme

    textColor: Maui.App.darkMode ? "#f4f5f6" : "#31363b"
    disabledTextColor: "#9931363b"

    highlightColor: Maui.App.accentColor
    //FIXME: something better?
    highlightedTextColor: Maui.App.darkMode ? "#eff0f1" : "#eff0f1"
    backgroundColor: Maui.App.darkMode ? "#3a3f41" : "#fafafa"
    alternateBackgroundColor: Qt.darker(theme.backgroundColor, 1.05)

    hoverColor: Qt.darker(Maui.App.accentColor, 1.1)
    focusColor: Maui.App.accentColor

    activeTextColor: Maui.App.accentColor
    activeBackgroundColor: Maui.App.darkMode ? "red" : "yellow"
    linkColor: "#2980B9"
    linkBackgroundColor: "#2980B9"
    visitedLinkColor: "#7F8C8D"
    visitedLinkBackgroundColor: "#7F8C8D"
    negativeTextColor: "#DA4453"
    negativeBackgroundColor: "#DA4453"
    neutralTextColor: "#F67400"
    neutralBackgroundColor: "#F67400"
    positiveTextColor: "#27AE60"
    positiveBackgroundColor: "#27AE60"

    buttonTextColor: Maui.App.darkMode ? "#f4f5f6" : "#31363b"
    buttonBackgroundColor: Maui.App.darkMode ? "#3a3f41" : "#fcfdfd"
    buttonAlternateBackgroundColor: Qt.darker(theme.buttonBackgroundColor, 1.05)
    buttonHoverColor: Qt.darker(Maui.App.accentColor, 1.1)
    buttonFocusColor: Maui.App.accentColor

    viewTextColor: Maui.App.darkMode ? "#f4f5f6" : "#31363b"
    viewBackgroundColor: Maui.App.darkMode ? "#3b3f3f" : "#fafafa"
    viewAlternateBackgroundColor: Qt.darker(theme.viewBackgroundColor, 1.05)
    viewHoverColor: theme.hoverColor
    viewFocusColor: theme.focusColor

    selectionTextColor: Maui.App.darkMode ? "#fcfcfc" : "#eff0f1"
    selectionBackgroundColor: Maui.App.accentColor
    selectionAlternateBackgroundColor: Qt.darker(theme.selectionTextColor, 1.05)
    selectionHoverColor: theme.hoverColor
    selectionFocusColor: theme.focusColor

    tooltipTextColor: "#fafafa"
    tooltipBackgroundColor: "#333"
    tooltipAlternateBackgroundColor: Qt.darker(theme.tooltipBackgroundColor, 1.05)
    tooltipHoverColor: "#333"
    tooltipFocusColor: "#333"

    complementaryTextColor: Maui.App.darkMode ? "#eff0f1" : "#fafafa"
    complementaryBackgroundColor: Maui.App.darkMode ? "#31363b" : "#333"
    complementaryAlternateBackgroundColor: Qt.lighter(theme.complementaryBackgroundColor, 1.05)
    complementaryHoverColor: Maui.App.darkMode ? "#3daee6" : "#3daee6"
    complementaryFocusColor: Maui.App.darkMode ? "#1e92ff" : "#1e92ff"

    headerTextColor: Maui.App.darkMode ? "#fcfcfc" : "#fcfcfc"
    headerBackgroundColor: Maui.App.darkMode ? "#2b2c31" : "#eceff1"
    headerAlternateBackgroundColor: Qt.lighter(theme.headerBackgroundColor, 1.05)
    headerHoverColor: Maui.App.darkMode ? "#3daee9" : "#3daee9"
    headerFocusColor: Maui.App.darkMode ? "#3daee9" : "#3daee9"

    defaultFont: fontMetrics.font

    property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        }
    ]

//    onSync: {
//        //TODO: actually check if it's a dark or light color
//        if (object.Kirigami.Theme.colorSet === Kirigami.Theme.Complementary) {
//            object.Material.theme = Material.Dark
//        } else {
//            object.Material.theme = Material.Light
//        }

//        object.Material.foreground = object.Kirigami.Theme.textColor
//        object.Material.background = object.Kirigami.Theme.backgroundColor
//        object.Material.primary = object.Kirigami.Theme.highlightColor
//        object.Material.accent = object.Kirigami.Theme.highlightColor
//    }
}
