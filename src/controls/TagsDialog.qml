import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.14 as Kirigami
import org.kde.mauikit 1.3 as Maui

import TagsList 1.0

/**
 * TagsDialog
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.Dialog
{
    id: control
    
    /**
     * taglist : TagsList
     */
    property alias taglist : _tagsList
    
    /**
     * listView : ListView
     */
    property alias listView: _listView
    
    /**
     * composerList : TagsList
     */
    property alias composerList: tagListComposer.list
    
    /**
     * tagsReady :
     */
    signal tagsReady(var tags)
    closeButton.visible: false
    defaultButtons: true
        maxHeight: 500
        maxWidth: 400
        page.margins: 0
        
        acceptButton.text: i18n("Save")
        rejectButton.text: i18n("Cancel")
        
        onAccepted: setTags()
        onRejected: close()
        
        headBar.visible: true
        
        headBar.middleContent: Maui.TextField
        {
            id: tagText
            Layout.fillWidth: true
            Layout.maximumWidth: 500
            placeholderText: i18n("Filter or add a new tag")
//             validator: RegExpValidator { regExp: /[0-9A-F]+/ }
            onAccepted:
            {
                const tags = tagText.text.split(",")
                for(var i in tags)
                {
                    const myTag = tags[i].trim()
                    _tagsList.insert(myTag)
                    tagListComposer.list.append(myTag)
                }
                clear()
                _tagsModel.filter = ""
            }
            
            onTextChanged:
            {
                _tagsModel.filter = text
            }
        }
        
        Maui.NewTagDialog
        {
            id: _newTagDialog
        }
        
        Maui.Dialog
        {
         id: _deleteDialog
         
         page.margins: Maui.Style.space.big
         property string tag
         title: i18n("Delete %1", tag)
         message: i18n("Are you sure you want to delete this tag? This action can not be undone.")
         template.iconSource: "tag"
         onAccepted: 
         {
             Maui.Tagging.removeTag(tag)
             _deleteDialog.close()
         }
         
         onRejected: _deleteDialog.close()         
        }
        
        Menu
        {
            id: _menu
            
            MenuItem
            {
            text: i18n("Edit")
            icon.name: "document-edit"
            }
            
            MenuItem
            {
                text: i18n("Delete")
                icon.name: "delete"
                onTriggered:
                {
                    _deleteDialog.tag = _tagsModel.get(_listView.currentIndex).tag
                    _deleteDialog.open()
                }
            }
        }
        
        stack: [
     
        Maui.ListBrowser
        {
            id: _listView
            
            Layout.fillHeight: true
            Layout.fillWidth: true
            
            currentIndex: -1
            
            holder.emoji: "qrc:/assets/Electricity.png"
            holder.visible: _listView.count === 0
            holder.isMask: false
            holder.title : i18n("No tags!")
            holder.body: i18n("Start by creating tags")
            holder.emojiSize: Maui.Style.iconSizes.huge
            
            model: Maui.BaseModel
            {
                id: _tagsModel
                sort: "tag"
                sortOrder: Qt.AscendingOrder
                recursiveFilteringEnabled: true
                sortCaseSensitivity: Qt.CaseInsensitive
                filterCaseSensitivity: Qt.CaseInsensitive
                list: TagsList
                {
                    id: _tagsList
                    strict: false
                }
            }
            
            delegate: Maui.ListDelegate
            {
                id: delegate
                width: ListView.view.width
                label: model.tag
                iconName: model.icon
                iconSize: Maui.Style.iconSizes.small
                
                template.content: Rectangle
                {
                    color: model.color ? model.color : "transparent"
                    height: Maui.Style.iconSizes.small
                    radius: height/2
                    width: height
                }
                
                onClicked:
                {
                    _listView.currentIndex = index
                    if(Maui.Handy.singleClick)
                    {
                        tagListComposer.list.appendItem(_tagsList.get(_listView.currentIndex))                        
                    }
                }
                
                onDoubleClicked:
                {
                    _listView.currentIndex = index
                    if(!Maui.Handy.singleClick)
                    {
                        tagListComposer.list.appendItem(_tagsList.get(_listView.currentIndex))                        
                    }
                }
                
                onPressAndHold:
                {
                    _listView.currentIndex = index                    
                    _menu.popup()
                }
                
                onRightClicked:
                {
                    _listView.currentIndex = index                    
                    _menu.popup()
                }
            }
        },
        
        Maui.ListItemTemplate
        {
            id: _info
            visible: tagListComposer.list.urls.length > 1
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            property var itemInfo : Maui.FM.getFileInfo( tagListComposer.list.urls[0])
            label1.text: i18n("Tagging %1 files", tagListComposer.list.urls.length)
            label2.text: i18n("Add new tags or compose the tags for the files.")
            label2.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            iconSource : itemInfo.icon
            imageSource: itemInfo.thumbnail
            iconSizeHint: Maui.Style.iconSizes.huge
            
            iconComponent: Item
            {
                Item
                {
                    anchors.fill: parent
                    layer.enabled: true
                    
                    Rectangle
                    {
                        anchors.fill: parent
                        anchors.leftMargin: Maui.Style.space.small
                        anchors.rightMargin: Maui.Style.space.small
                        radius: Maui.Style.radiusV
                        color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
                        border.color: Kirigami.Theme.backgroundColor
                    }
                    
                    Rectangle
                    {
                        anchors.fill: parent
                        anchors.topMargin: Maui.Style.space.tiny
                        anchors.leftMargin: Maui.Style.space.tiny
                        anchors.rightMargin: Maui.Style.space.tiny
                        radius: Maui.Style.radiusV
                        color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
                        border.color: Kirigami.Theme.backgroundColor                    
                    }
                    
                    Rectangle
                    {
                        anchors.fill: parent
                        anchors.topMargin: Maui.Style.space.small
                        border.color: Kirigami.Theme.backgroundColor
                        
                        radius: Maui.Style.radiusV
                        color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))        
                        
                        Maui.GridItemTemplate
                        {
                            anchors.fill: parent
                            anchors.margins: Maui.Style.space.tiny
                            iconSizeHint: height
                            
                            iconSource: _info.iconSource
                            imageSource:  _info.imageSource                 
                        }
                    }
                }
            }
        }       
        ]
        
        page.footer: Maui.TagList
        {
            id: tagListComposer
            width: parent.width
            visible: count > 0
           
            onTagRemoved: list.remove(index)
            placeholderText: i18n("No tags yet.")
        }
        
        onClosed:
        {
            composerList.urls = []
            tagText.clear()
            _tagsModel.filter = ""
        }
        
        onOpened: tagText.forceActiveFocus()
        
        /**
         * 
         */
        function setTags()
        {
            var tags = []
            
            for(var i = 0; i < tagListComposer.count; i++)
                tags.push(tagListComposer.list.get(i).tag)
                control.tagsReady(tags)
                close()
        }
}
