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
    
    
    textColor: theme.txtColor
    disabledTextColor: "#9931363b"
    
    highlightColor: theme.accentColor
    //FIXME: something better?
    highlightedTextColor: isDark ? "#eff0f1" : "#eff0f1"
    backgroundColor: theme.bgColor
    alternateBackgroundColor: Qt.darker(theme.bgColor, 1.05)
    
    hoverColor: isDark ? Qt.lighter(theme.bgColor, 1.2) : Qt.darker(theme.bgColor, 1.1)
    focusColor: theme.accentColor
    
    activeTextColor: theme.accentColor
    activeBackgroundColor: isDark ? "red" : "yellow"
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
    
    buttonTextColor: theme.txtColor
    buttonBackgroundColor: isDark ? Qt.lighter(theme.bgColor, 1.05) : Qt.darker(theme.bgColor, 1.1)
    buttonAlternateBackgroundColor: Qt.darker(theme.buttonBackgroundColor, 1.05)
    buttonHoverColor: Qt.darker(theme.accentColor, 1.1)
    buttonFocusColor: theme.accentColor
    
    viewTextColor: theme.txtColor
    viewBackgroundColor: isDark ? Qt.darker(theme.backgroundColor, 1.1) : Qt.lighter(theme.backgroundColor, 1.1)
    viewAlternateBackgroundColor: Qt.darker(theme.viewBackgroundColor, 1.05)
    viewHoverColor: theme.hoverColor
    viewFocusColor: theme.focusColor
    
    selectionTextColor: isDark ? "#fcfcfc" : "#eff0f1"
    selectionBackgroundColor: theme.accentColor
    selectionAlternateBackgroundColor: Qt.darker(theme.selectionTextColor, 1.05)
    selectionHoverColor: theme.hoverColor
    selectionFocusColor: theme.focusColor
    
    tooltipTextColor: "#fafafa"
    tooltipBackgroundColor: "#333"
    tooltipAlternateBackgroundColor: Qt.darker(theme.tooltipBackgroundColor, 1.05)
    tooltipHoverColor: "#333"
    tooltipFocusColor: "#333"
    
    complementaryTextColor: isDark ? "#eff0f1" : "#fafafa"
    complementaryBackgroundColor: isDark ? "#31363b" : "#333"
    complementaryAlternateBackgroundColor: Qt.lighter(theme.complementaryBackgroundColor, 1.05)
    complementaryHoverColor: isDark ? "#3daee6" : "#3daee6"
    complementaryFocusColor: isDark ? "#1e92ff" : "#1e92ff"
    
    headerTextColor: isDark ? "#fcfcfc" : "#fcfcfc"
    headerBackgroundColor: isDark ? "#2b2c31" : "#eceff1"
    headerAlternateBackgroundColor: Qt.lighter(theme.headerBackgroundColor, 1.05)
    headerHoverColor: isDark ? "#3daee9" : "#3daee9"
    headerFocusColor: isDark ? "#3daee9" : "#3daee9"
    
    defaultFont: fontMetrics.font
        
        property color bgColor :  isDark ? "#3a3f41" : "#efefef"
        property color txtColor :  isDark ? "#f4f5f6" : "#31363b"
        property color accentColor : Maui.Style.accentColor 
        property bool isDark : Maui.Style.styleType === Maui.Style.Dark
        
        property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        }
        ]
        
        //    onSync: {
        //        //TODO: actually check if it's a dark or light color
        //        if (object.Maui.Theme.colorSet === Maui.Theme.Complementary) {
        //            object.Material.theme = Material.Dark
        //        } else {
        //            object.Material.theme = Material.Light
        //        }
        
        //        object.Material.foreground = object.Maui.Theme.textColor
        //        object.Material.background = object.Maui.Theme.backgroundColor
        //        object.Material.primary = object.Maui.Theme.highlightColor
        //        object.Material.accent = object.Maui.Theme.highlightColor
        //    }
}
