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

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

/**
 * @inherit PopupPage
 *    @since org.mauikit.controls
 *    @brief A dialog for listing file URLs and for suggesting to perform an action[s].
 * 
 *    This controls inherits from MauiKit PopupPage, to checkout its inherited properties refer to the docs.
 *    @see PopupPage
 * 
 *    The listed files can also be removed from the dialog itself, and the `urls` property will be updated properly.
 *    The delegate used to display the files can be assigned to a custom element.
 * 
 *    To add actions use the inherited property `actions` from the PopupPage control.
 * 
 *    @image html Misc/filelistingdialog.png "Listing a group of files and three actions"
 * 
 *    @code
 *    Maui.FileListingDialog
 *    {
 *        id: _dialog
 *        title: "File Listing"
 *        message: "This is a file listing dialog. Used to list files and suggest to perfom an action upon them."
 * 
 *        urls: ["/home/camiloh/Downloads/premium_photo-1664203068007-52240d0ca48f.avif", "/home/camiloh/Downloads/ide_4x.webp", "/home/camiloh/Downloads/photo-app-fereshtehpb.webp", "/home/camiloh/Downloads/ide-reskin.webp", "/home/camiloh/Downloads/nx-software-center-latest-x86_64.AppImage", "/home/camiloh/Downloads/hand-drawn-flat-design-metaverse-background.zip"]
 * 
 *        actions: [
 *            Action
 *            {
 *                text: "Action1"
 *            },
 * 
 *            Action
 *            {
 *                text: "Action2"
 *            },
 * 
 *            Action
 *            {
 *                text: "Action3"
 *            }
 *        ]
 *    }
 *    @endcode
 * 
 *    @section notes Notes
 *    The title will not be visible by default as the `headBar` is hidden. To force show it use the `headBar.visible` property.
 * 
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/FileListingDialog.qml">You can find a more complete example at this link.</a>
 */
Maui.PopupPage
{
    id: control
    
    /**
     * @brief Any child item will be placed under the information section of this dialog. This is the default property and is handled by a ColumnLayout, so to place items use the Layout attached properties.
     * @property list<QtObject> FileListingDialog::content
     */
    default property alias content : _content.data
        
        /**
         * @brief The array of URLs to be listed. This will be used as the model for the file listing section.
         */
        property var urls: []
        
        /**
         * @brief The body of the message. This will go right under the title.
         */
        property string message : ""
        
        /**
         * @brief This is a information map of the first file in the `urls` list. It is used to display a miniature image in the dialog information section.
         */
        readonly property var singleItem : FB.FM.getFileInfo(control.urls[0])
        
        /**
         * @brief An alias for the template element handling the information section. This is exposed to access it and fine tune details, or embed more element into it. This template is handled by a ListItemTemplate.
         * @see ListItemTemplate
         * @property ListItemTemplate FileListingDialog::template.
         */
        readonly property alias template : _template
        
        hint: 1
        maxWidth: 350
        
        headBar.visible: false
        
        Maui.ListItemTemplate
        {
            id: _template
            visible: control.message.length
            Layout.fillWidth: true
            label2.text: message
            label2.textFormat : TextEdit.AutoText
            label2.wrapMode: TextEdit.WordWrap
            iconVisible: control.width > Maui.Style.units.gridUnit * 10
            
            iconSizeHint: Maui.Style.iconSizes.large
            spacing: Maui.Style.space.big
            
            leftLabels.spacing: control.spacing
            
            headerSizeHint: template.iconSizeHint + Maui.Style.space.big
            iconSource: singleItem.icon
            imageSource: singleItem.thumbnail
            implicitHeight: Math.max(template.leftLabels.implicitHeight, 64)
            
            leftLabels.data: ColumnLayout
            {
                id: _content
                Layout.fillWidth: true
                spacing: control.spacing
            }
            
            iconComponent: Item
            {
                Item
                {
                    height: Math.min(parent.height, 120, width)
                    width: parent.width
                    anchors.centerIn: parent
                    layer.enabled: true
                    
                    Rectangle
                    {
                        visible: control.urls ? control.urls.length > 1 : false
                        anchors.fill: parent
                        
                        anchors.leftMargin: Maui.Style.space.small
                        anchors.rightMargin: Maui.Style.space.small
                        
                        radius: Maui.Style.radiusV
                        color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
                        border.color: Maui.Theme.backgroundColor
                    }
                    
                    Rectangle
                    {
                        visible: control.urls ? control.urls.length > 1 : false
                        anchors.fill: parent
                        
                        anchors.topMargin: Maui.Style.space.tiny
                        anchors.leftMargin: Maui.Style.space.tiny
                        anchors.rightMargin: Maui.Style.space.tiny
                        
                        radius: Maui.Style.radiusV
                        color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
                        border.color: Maui.Theme.backgroundColor
                    }
                    
                    Rectangle
                    {
                        anchors.fill: parent
                        anchors.topMargin:  control.urls.length > 1 ? Maui.Style.space.small : 0
                        border.color: Maui.Theme.backgroundColor
                        
                        radius: Maui.Style.radiusV
                        color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
                        
                        Maui.GridItemTemplate
                        {
                            anchors.fill: parent
                            anchors.margins: Maui.Style.space.tiny
                            iconSizeHint: Math.min(height, width)
                            
                            iconSource: control.template.iconSource
                            imageSource:  control.template.imageSource
                        }
                    }
                }
            }
        }
        
        /**
         * @brief The list delegate item to be used to display the file URLs.
         * This is set to a MauiKit ListItemTemplate element by default with a image  or icon preview and the file name.
         * This can be changed to any other element. The model is populated by the `urls` property, so to extract information for a custom element, use the `modelData` attribute to get the URL for each instance.
         */
        property Component listDelegate : Maui.ListItemTemplate
        {
            width: ListView.view.width
            height: Maui.Style.rowHeight
            property var item : FB.FM.getFileInfo(modelData)
            label1.text: item.label
            label3.text: Maui.Handy.formatSize(item.size)
            rightLabels.visible: true
            iconVisible: true
            iconSource: item.icon
            imageSource: item.thumbnail
            iconSizeHint: Maui.Style.iconSizes.medium
            
            ToolButton
            {
                //text: i18nd("mauikit", "Clear")
                icon.name: "edit-clear"
                icon.width: Maui.Style.iconSizes.small
                icon.height: Maui.Style.iconSizes.small
                
                onClicked:
                {
                    var array = control.urls
                    const index = array.indexOf(modelData);
                    if (index > -1) {
                        array.splice(index, 1);
                    }
                    
                    if(array.length === 0)
                    {
                        control.close()
                        return
                    }
                    
                    control.urls = array
                }
            }
        }
        
        Loader
        {
            id: _listViewLoader
            
            asynchronous: true
            active: control.urls.length > 0
            visible: active
            
            Layout.fillWidth: true
            
            sourceComponent: Maui.ListBrowser
            {
                clip: true
                implicitHeight: Math.min(contentHeight, 300)
                model: urls
                spacing: Maui.Style.defaultSpacing
                padding: 0
                
                delegate: control.listDelegate
            }
        }
}
