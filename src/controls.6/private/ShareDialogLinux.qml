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
import QtQuick.Layouts

import org.mauikit.controls as Maui
import org.kde.purpose as Purpose

/**
 * @brief The Linux implementation for the ShareDialog
 */
Maui.PopupPage
{
    id: control
    
    /**
     * @brief The list of local file URLs to be shared to the selected services
     */
    property var urls : []
    
    /**
     * @brief The mime type of the set of URLs to perform the correct service lookup
     */
    property string mimeType
    
    widthHint: 0.9
    
    maxHeight: 400
    maxWidth: 350
    
    title: i18n("Share")
    
    headBar.leftContent: ToolButton
    {
        visible: _purpose.depth>1;
        icon.name: "go-previous"
        onClicked:
        {
            _purpose.reset()
            _purpose.error = false
        }
    }
    
    stack: Purpose.AlternativesView
    {
        id: _purpose
        property bool error : false
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: Maui.Style.space.medium
        pluginType: 'Export'
        clip: true
        spacing: Maui.Style.defaultSpacing
        
        header: Pane
        {
            width: parent.width
            background: null

            contentItem: Item
            {
                implicitHeight: 150

                Maui.GridItemTemplate
                {
                    readonly property var itemInfo : FB.FM.getFileInfo( control.urls[0])

                    anchors.fill: parent
                    anchors.margins: Maui.Style.space.tiny
                    iconSizeHint: Maui.Style.iconSizes.huge
                    fillMode: Image.PreserveAspectFit
                    iconSource: itemInfo.icon
                    imageSource:  itemInfo.thumbnail
                    text1: i18np("1 item", "%1 items", control.urls.length)
                }
            }
        }

        inputData :
        {
            'urls': control.urls,
            'mimeType':control.mimeType
        }
        
        delegate: Maui.ListBrowserDelegate
        {
            width: ListView.view.width
            
            label1.text: model.display
            iconSource: model.iconName
            iconSizeHint: Maui.Style.iconSizes.big
            onClicked: _purpose.createJob(index)
        }
        
        onFinished: (output, error, message) =>
                    {
                        if(error!=0)
                        {
                            _purpose.error = true
                            _holder.body = message
                            return
                        }

                        _purpose.error = false
                    }
        
        Maui.Holder
        {
            id: _holder
            anchors.fill: parent
            visible: _purpose.error
        }
    }
}

