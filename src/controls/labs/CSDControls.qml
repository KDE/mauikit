import QtQuick 2.13
import QtQuick.Controls 2.3

import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import org.mauikit.controls 1.0 as Maui
import org.kde.kirigami 2.7 as Kirigami
import org.kde.appletdecoration 0.1 as AppletDecoration
// import org.kde.plasma.plasmoid 2.0

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Loader
{
    id: control
    
    active: Maui.App.enableCSD 
    visible: model.length && active
    
    required property int side 
    
    readonly property var model : control.side === Qt.LeftEdge ?  Maui.App.leftWindowControls :  Maui.App.rightWindowControls
    
    
    /**
     * 
     */
    signal buttonClicked(var type)
    
    
    sourceComponent: Item 
    {
        implicitHeight: visible ? Maui.Style.iconSizes.medium : 0
        implicitWidth: visible ? _row.implicitWidth : 0
        
        visible: control.model.length > 0
        
        Row
        {
            id: _row
            height: parent.height
            spacing: Maui.Style.space.medium
            
            Repeater
            {
                model: control.model
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
                scheme: plasmaThemeExtended.colors.schemeFile
                
                //                 isOnAllDesktops: root.isLastActiveWindowPinned
                isMaximized: root.visibility === Window.Maximized
                //                 isKeepAbove: root.isLastActiveWindowKeepAbove
                
                //                 localX: x
                //                 localY: y
                isActive: root.active
                onClicked: buttonClicked(type)            
            }
        }
        
        Component
        {
            id: auroraeButton
            Item {}
            //         AppletDecoration.AuroraeButton
            //         {
            //             width: 22
            //             height: 22
            //
            //             isMaximized: Window.window.visibility === Window.Maximized
            //             //                 isKeepAbove: root.isLastActiveWindowKeepAbove
            //
            //             //                 localX: x
            //             //                 localY: y
            //             isActive: Window.window.active
            //
            //             onClicked: performActiveWindowAction(buttonType)
            //
            //             buttonType: mapControl(modelData)
            //             auroraeTheme: auroraeThemeEngine
            //
            //         }
        }
        
        AppletDecoration.WindowSystem
        {
            id: windowSystem
        }
        
        AppletDecoration.PlasmaThemeExtended
        {
            id: plasmaThemeExtended
            
            readonly property bool isActive: true
            
            function triggerUpdate()
            {
                if (isActive)
                {
                    //                             initButtons();
                    sharedDecorationItem.createDecoration();
                }
            }
            
            onThemeChanged: triggerUpdate();
            onColorsChanged: triggerUpdate();
        }
        
        AppletDecoration.Bridge
        {
            id: bridgeItem
            plugin: decorations.currentPlugin
            theme: decorations.currentTheme
        }
        
        AppletDecoration.Settings
        {
            id: settingsItem
            bridge: bridgeItem.bridge
            borderSizesIndex: 0 // Normal
        }
        
        AppletDecoration.SharedDecoration
        {
            id: sharedDecorationItem
            bridge: bridgeItem.bridge
            settings: settingsItem
        }
        
        AppletDecoration.DecorationsModel
        {
            id: decorations
        }
        
        AppletDecoration.AuroraeTheme
        {
            id: auroraeThemeEngine
            theme: isEnabled ? decorations.currentTheme : ""
            
            readonly property bool isEnabled: decorations.isAurorae(decorations.currentPlugin, decorations.currentTheme);
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
    
    
    
    
}
