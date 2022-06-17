import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import org.mauikit.controls 1.3 as Maui

import org.kde.appletdecoration 0.1 as AppletDecoration
//import org.kde.plasma.plasmoid 2.0
//import org.kde.plasma.core 2.0 as PlasmaCore

Item
{
    id: control
    implicitHeight: visible ? 18 + Maui.Style.space.medium : 0
    implicitWidth: visible ? _row.implicitWidth : 0

    property string currentPlugin: decorations.currentPlugin
    property string currentTheme: decorations.currentTheme

    Maui.CSDButton
    {
        id: button
    }

    Row
    {
        id: _row
        height: parent.height
        spacing: Maui.Style.space.medium

        ToolSeparator
        {
            height: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        Repeater
        {
            model: buttonsModel
            delegate: pluginButton
        }
    }

    Component
    {
        id: pluginButton

        AppletDecoration.Button
        {
            width: 22
            height: 22
            type:  mapControl(modelData)
            anchors.verticalCenter: parent.verticalCenter
            bridge: bridgeItem.bridge
            sharedDecoration: sharedDecorationItem
            scheme: colorsModel.defaultSchemeFile()

            //                 isOnAllDesktops: root.isLastActiveWindowPinned
            isMaximized: Window.window.visibility === Window.Maximized
            //                 isKeepAbove: root.isLastActiveWindowKeepAbove

            //                 localX: x
            //                 localY: y
            isActive: Window.window.active
            onClicked: buttonClicked(button.mapType(modelData))
        }
    }

    //Component {
        //id: auroraeButton
        //AppletDecoration.AuroraeButton {
            //id: aButton
            //width: 22
            //height: 22



            //isMaximized: root.visibility === Window.Maximized

            //localX: x
            //localY: y
            //isActive: root.active

            //buttonType: mapControl(modelData)
            //auroraeTheme: auroraeThemeEngine

            //monochromeIconsEnabled: auroraeThemeEngine.hasMonochromeIcons
            //monochromeIconsColor: "transparent"


            //onClicked: buttonClicked(button.mapType(modelData))

        //}
    //}

    ///Decoration Items
    AppletDecoration.Bridge {
        id: bridgeItem
        plugin: currentPlugin
        theme: currentTheme
    }

    AppletDecoration.Settings {
        id: settingsItem
        bridge: bridgeItem.bridge
        borderSizesIndex: 0 // Normal
    }

    AppletDecoration.SharedDecoration {
        id: sharedDecorationItem
        bridge: bridgeItem.bridge
        settings: settingsItem
    }

    AppletDecoration.DecorationsModel {
        id: decorations
    }

    AppletDecoration.ColorsModel {
        id: colorsModel
    }

    //     AppletDecoration.PlasmaThemeExtended {
    //         id: plasmaThemeExtended
    //
    //         readonly property bool isActive: plasmoid.configuration.selectedScheme === "_plasmatheme_"
    //     }

    AppletDecoration.AuroraeTheme {
        id: auroraeThemeEngine
        theme: isEnabled ? currentTheme : ""

        readonly property bool isEnabled: decorations.isAurorae(currentPlugin, currentTheme);
    }

    AppletDecoration.WindowSystem {
        id: windowSystem
    }
    //     PlasmaTasksModel{id: windowInfo}

    function mapControl(key)
    {
        switch(key)
        {
            case "X": return  AppletDecoration.Types.Close;
            case "I": return  AppletDecoration.Types.Minimize;
            case "A": return  AppletDecoration.Types.Maximize;
            case "F": return  AppletDecoration.Types.KeepAbove;
            case "S": return  AppletDecoration.Types.OnAllDesktops;
            default: return null;
        }
    }
}



