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

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15

import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/*!
 * \ since or*g.mauikit.controls 1.0
 * \inqmlmodule org.mauikit.controls
 * \brief A window that provides some basic features needed for all apps
 * 
 * It's usually used as a root QML component for the application.
 * By default it makes usage of the Maui Page control, so it packs a header and footer bar.
 * The header can be moved to the bottom for better reachability in hand held devices.
 * The Application window has some components already built in like an AboutDialog, a main application menu,
 * and an optional property to add a global sidebar.
 * 
 * The application can have client side decorations CSD by setting the attached property Maui.App.enabledCSD  to true,
 * or globally by editing the configuration file located at /.config/Maui/mauiproject.conf.
 * 
 * For more details you can refer to the Maui Page documentation for fine tweaking the application window main content.
 * \code
 * ApplicationWindow {
 * id: root
 * 
 * AppViews {
 * anchors.fill: parent
 * }
 * }
 * \endcode
 */
Private.BaseWindow
{
    id: root
    
    isDialog: false      
       
    Settings
    {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }
            
        Loader
        {
            id: dialogLoader
        }
        
        Connections
        {
            target: Maui.Platform
            ignoreUnknownSignals: true
            
            function onShareFilesRequest(urls)
            {
                dialogLoader.source = "private/ShareDialog.qml"
                dialogLoader.item.urls = urls
                dialogLoader.item.open()
            }
        }
        
        Component.onCompleted:
        {
             Maui.App.rootComponent = root
            
            if(Maui.Handy.isAndroid)
            {
                setAndroidStatusBarColor()
            }
        }          
        
        Component
        {
            id: _aboutDialogComponent
            
            Private.AboutDialog
            {
                onClosed: destroy()
            }
        }
        
        function about()
        {
           var about = _aboutDialogComponent.createObject(root)
            about.open()
        }   

    function setAndroidStatusBarColor()
    {
        if(Maui.Handy.isAndroid)
        {
            const dark = Maui.Style.styleType === Maui.Style.Dark
            Maui.Android.statusbarColor(Maui.Theme.backgroundColor, !dark)
            Maui.Android.navBarColor( Maui.Theme.backgroundColor, !dark)
        }
    }
}
