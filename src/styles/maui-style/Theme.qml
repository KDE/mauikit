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
    
    highlightColor: Maui.Style.accentColor
    //FIXME: something better?
    highlightedTextColor: Maui.App.darkMode ? "#eff0f1" : "#eff0f1"
    backgroundColor: Maui.App.darkMode ? "#3a3f41" : "#efefef"
    alternateBackgroundColor: Qt.darker(theme.backgroundColor, 1.05)
    
    hoverColor: Maui.App.darkMode ? Qt.lighter(backgroundColor, 1.2) : Qt.darker(backgroundColor, 1.1)
    focusColor: Maui.Style.accentColor
    
    activeTextColor: Maui.Style.accentColor
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
    
    buttonTextColor: theme.textColor
    buttonBackgroundColor: Maui.App.darkMode ? Qt.lighter(theme.backgroundColor, 1.05) : Qt.darker(theme.backgroundColor, 1.1)
    buttonAlternateBackgroundColor: Qt.darker(theme.buttonBackgroundColor, 1.05)
    buttonHoverColor: Qt.darker(Maui.Style.accentColor, 1.1)
    buttonFocusColor: Maui.Style.accentColor
    
    viewTextColor: theme.textColor
    viewBackgroundColor: Maui.App.darkMode ? Qt.darker(theme.backgroundColor, 1.1) : Qt.lighter(theme.backgroundColor, 1.1)
    viewAlternateBackgroundColor: Qt.darker(theme.viewBackgroundColor, 1.05)
    viewHoverColor: theme.hoverColor
    viewFocusColor: theme.focusColor
    
    selectionTextColor: Maui.App.darkMode ? "#fcfcfc" : "#eff0f1"
    selectionBackgroundColor: Maui.Style.accentColor
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
        
        property color bgColor :  Maui.App.darkMode ? "#3a3f41" : "#fafafa"
        property bool adaptive : Maui.Style.adaptiveColorScheme
        property color txtColor : Maui.App.darkMode ? "#f4f5f6" : "#31363b"
        
        onAdaptiveChanged:
        {
            console.log("APDATIVE COLOR SCHEME VALUE CHANGED ")
            if(!Maui.Style.adaptiveColorScheme)
            {
                Maui.Style.accentColor = "#26c6da"
                theme.highlightedTextColor = Qt.binding( function() { return (Maui.App.darkMode ? "#eff0f1" : "#eff0f1")})
                theme.backgroundColor = Qt.binding(function() { return (Maui.App.darkMode ? "#3a3f41" : "#fafafa") })
                theme.textColor = Qt.binding( function() { return (Maui.App.darkMode ? "#f4f5f6" : "#31363b")})
            }else
            {
                _imageColors.update()
            }
        }
        
        property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        },       
                
        Kirigami.ImageColors
        {
            id: _imageColors
            source: Maui.Style.adaptiveColorSchemeSource
            onPaletteChanged:
            {
                if(Maui.Style.adaptiveColorScheme)
                {
                    Maui.App.darkMode = _imageColors.paletteBrightness === Kirigami.ColorUtils.Dark
                    Maui.Style.accentColor = _imageColors.highlight
                    theme.highlightedTextColor = Kirigami.ColorUtils.brightnessForColor(_imageColors.highlight) == Kirigami.ColorUtils.Light ? _imageColors.closestToBlack :  _imageColors.closestToWhite
                    theme.backgroundColor = Qt.tint(_imageColors.background, Qt.rgba(bgColor.r,bgColor.g,bgColor.b, 0.8))
                    theme.textColor =  _imageColors.foreground
                }
                
                Maui.Style.colorSchemeChanged()
            }
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
