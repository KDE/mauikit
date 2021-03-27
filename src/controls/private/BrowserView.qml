import QtQuick 2.9
import QtQuick.Controls 2.9
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.3 as Maui

Maui.AltBrowser
{
    id: control
    
    headBar.visible: false
    title: currentFMList.pathName
    selectionMode: control.selectionMode
    enableLassoSelection: true
      
    gridView.itemSize : control.gridItemSize
    gridView.itemHeight: gridView.itemSize * 1.3
    
    Binding on currentIndex
    {
        when: control.currentView
        value: control.currentView.currentIndex
    }
    
    viewType: settings.viewType === Maui.FMList.ICON_VIEW ? Maui.AltBrowser.ViewType.Grid : Maui.AltBrowser.ViewType.List
    
    onPathChanged:
    {
        control.currentIndex = 0
        control.currentView.forceActiveFocus()        
    }    
    
    model: Maui.BaseModel
    {
        id: _browserModel
        list: Maui.FMList
        {
            id: _commonFMList
            path: control.path
            onSortByChanged: if(settings.group) groupBy()
            onlyDirs: settings.onlyDirs
            filterType: settings.filterType
            filters: settings.filters
            sortBy: settings.sortBy
            hidden: settings.showHiddenFiles
            foldersFirst: settings.foldersFirst
        }
        
        filter: control.filter
        recursiveFilteringEnabled: true
        sortCaseSensitivity: Qt.CaseInsensitive
        filterCaseSensitivity: Qt.CaseInsensitive
    }    
    
    /**
     * 
     */
    property url path
    
    /**
     * 
     */
    
    property int gridItemSize :  Maui.Style.iconSizes.large * 1.7
    property int listItemSize : Maui.Style.rowHeight
    
    /**
     * 
     */
    property alias settings : _settings
    
    
    /**
     * 
     */
    readonly property alias currentFMList : _commonFMList
    
    /**
     * 
     */
    readonly property alias currentFMModel : _browserModel
    
    
    /**
     * 
     */
    property string filter    
    
    signal itemClicked(int index)
    signal itemDoubleClicked(int index)
    signal itemRightClicked(int index)
    signal itemToggled(int index, bool state)
    signal itemsSelected(var indexes)
    signal keyPress(var event)
    signal areaClicked(var mouse)
    signal areaRightClicked(var mouse)

    Connections
    {
        target: control.currentView
        ignoreUnknownSignals: true
        
        function onKeyPress(event)
        {
            control.keyPress(event)
        }
        
        function onItemsSelected(indexes)
        {
            control.itemsSelected(indexes)
        }
        
        function onAreaClicked(mouse)
        {
            control.currentView.forceActiveFocus()
            control.areaClicked(mouse)
        }
        
        function onAreRightClicked(mouse)
        {
            control.currentView.forceActiveFocus()
            control.areaRightClicked(mouse)
        }
    }
    
    BrowserSettings
    {
        id: _settings
        onGroupChanged:
        {
            if(settings.group)
            {
                groupBy()
            }
            else
            {
                currentView.section.property = ""
            }
        }
    }
    
    BrowserHolder
    {
        id: _holder
        browser: _commonFMList
    }
    
    holder.visible: _holder.visible
    holder.emoji: _holder.emoji
    holder.title: _holder.title
    holder.body: _holder.body
    holder.emojiSize: _holder.emojiSize
    
    Menu
    {
        id: _dropMenu
        property string urls
        property url target
        
        enabled: Maui.FM.getFileInfo(target).isdir == "true" && !urls.includes(target.toString())
        
        MenuItem
        {
            text: i18n("Copy here")
            onTriggered:
            {
                const urls = _dropMenu.urls.split(",")
                Maui.FM.copy(urls, _dropMenu.target, false)
            }
        }
        
        MenuItem
        {
            text: i18n("Move here")
            onTriggered:
            {
                const urls = _dropMenu.urls.split(",")
                Maui.FM.cut(urls, _dropMenu.target)
            }
        }
        
        MenuItem
        {
            text: i18n("Link here")
            onTriggered:
            {
                const urls = _dropMenu.urls.split(",")
                for(var i in urls)
                    Maui.FM.createSymlink(url[i], _dropMenu.target)
            }
        }
        
        MenuSeparator {}
        
        MenuItem
        {
            text: i18n("Cancel")
            onTriggered: _dropMenu.close()
        }
    }
    
    listView.section.delegate: Maui.LabelDelegate
    {
        id: delegate
        width: parent ? parent.width : 0
        height: Maui.Style.toolBarHeightAlt
        
        label: _listViewBrowser.section.property == "date" || _listViewBrowser.section.property === "modified" ?  Qt.formatDateTime(new Date(section), "d MMM yyyy") : section
        labelTxt.font.pointSize: Maui.Style.fontSizes.big
        
        isSection: true
    }
    
    listDelegate: Maui.ListBrowserDelegate
    {
        id: delegate
        readonly property string path : model.path
        
        width: ListView.view.width
        height: control.listItemSize
        
        iconSource: model.icon
        
        label1.text: model.label ? model.label : ""
        label3.text : model.mime ? (model.mime === "inode/directory" ? (model.count ? model.count + i18n(" items") : "") : Maui.FM.formatSize(model.size)) : ""
        label4.text: model.modified ? Maui.FM.formatDate(model.modified, "MM/dd/yyyy") : ""
        
        iconSizeHint : Maui.Style.iconSizes.medium
        imageSizeHint : height * 0.8
        
        tooltipText: model.path
        
        checkable: control.selectionMode
        imageSource: settings.showThumbnails ? model.thumbnail : ""
        checked: selectionBar ? selectionBar.contains(model.path) : false
        opacity: model.hidden == "true" ? 0.5 : 1
        draggable: true
        
        Drag.keys: ["text/uri-list"]
        Drag.mimeData: Drag.active ?
        {
            "text/uri-list": filterSelection(control.path, model.path).join("\n")
        } : {}
        
        Item
        {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            visible: (model.issymlink == true) || (model.issymlink == "true")
            
            Kirigami.Icon
            {
                source: "link"
                height: Maui.Style.iconSizes.small
                width: Maui.Style.iconSizes.small
                anchors.centerIn: parent
                color: label1.color
            }
        }
        
        onClicked:
        {
            control.currentIndex = index
            
            if ((mouse.button == Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier))
            {
                control.itemsSelected([index])
            }else
            {
                control.itemClicked(index)
            }
        }
        
        onDoubleClicked:
        {
            control.currentIndex = index
            control.itemDoubleClicked(index)
        }
        
        onPressAndHold:
        {
            if(!Maui.Handy.isTouch)
                return
                
                control.currentIndex = index
                control.itemRightClicked(index)
        }
        
        onRightClicked:
        {
            control.currentIndex = index
            control.itemRightClicked(index)
        }
        
        onToggled:
        {
            control.currentIndex = index
            control.itemToggled(index, state)
        }
        
        onContentDropped:
        {
            _dropMenu.urls = drop.urls.join(",")
            _dropMenu.target = model.path
            _dropMenu.popup()
        }
        
        ListView.onRemove:
        {
            if(selectionBar && !Maui.FM.fileExists(delegate.path))
            {
                selectionBar.removeAtUri(delegate.path)
            }
        }
        
        Connections
        {
            target: selectionBar
            
            function onUriRemoved(uri)
            {
                if(uri === model.path)
                    delegate.checked = false
            }
            
            function onUriAdded(uri)
            {
                if(uri === model.path)
                    delegate.checked = true
            }
            
            function onCleared()
            {
                delegate.checked = false
            }
        }
    }
      
    gridDelegate: Item
    {
        
        property bool isCurrentItem : GridView.isCurrentItem
        height: gridView.cellHeight
        width: gridView.cellWidth
        
        GridView.onRemove:
        {
            if(selectionBar && !Maui.FM.fileExists(delegate.path))
            {
                selectionBar.removeAtUri(delegate.path)
            }
        }
        
        Maui.GridBrowserDelegate
        {
            id: delegate
            readonly property string path : model.path
            
            iconSizeHint: height * 0.4
            imageSource: settings.showThumbnails ? model.thumbnail : ""
            template.fillMode: Image.PreserveAspectFit
            iconSource: model.icon
            label1.text: model.label
            
            anchors.fill: parent
            anchors.margins: Maui.Style.space.medium
            padding: Maui.Style.space.tiny
            isCurrentItem: parent.isCurrentItem
            tooltipText: model.path
            checkable: control.selectionMode
            checked: (selectionBar ? selectionBar.contains(model.path) : false)
            draggable: true
            opacity: model.hidden == "true" ? 0.5 : 1
            
            Drag.keys: ["text/uri-list"]
            Drag.mimeData: Drag.active ?
            {
                "text/uri-list":  filterSelection(control.path, model.path).join("\n")
            } : {}
            
            Maui.Badge
            {
                iconName: "link"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Maui.Style.space.big
                visible: (model.issymlink == true) || (model.issymlink == "true")
            }
            
            template.content: Label
            {
                visible: delegate.height > 100
                opacity: 0.5
                color: Kirigami.Theme.textColor
                font.pointSize: Maui.Style.fontSizes.tiny
                horizontalAlignment: Qt.AlignHCenter
                Layout.fillWidth: true
                text: model.mime ? (model.mime === "inode/directory" ? (model.count ? model.count + i18n(" items") : "") : Maui.FM.formatSize(model.size)) : ""
            }
            
            onClicked:
            {
                control.currentIndex = index
                control.currentView.forceActiveFocus()
                
                if ((mouse.button == Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier))
                {
                    control.itemsSelected([index])
                }else
                {
                    control.itemClicked(index)
                }
            }
            
            onDoubleClicked:
            {
                control.currentIndex = index
                control.currentView.forceActiveFocus()
                control.itemDoubleClicked(index)
            }
            
            onPressAndHold:
            {
                if(!Maui.Handy.isTouch)
                    return
                    
                    control.currentIndex = index
                    control.currentView.forceActiveFocus()
                    control.itemRightClicked(index)
            }
            
            onRightClicked:
            {
                control.currentIndex = index
                control.currentView.forceActiveFocus()
                control.itemRightClicked(index)
            }
            
            onToggled:
            {
                control.currentIndex = index
                control.itemToggled(index, state)
            }
            
            onContentDropped:
            {
                _dropMenu.urls = drop.urls.join(",")
                _dropMenu.target = model.path
                _dropMenu.popup()
            }
            
            Connections
            {
                target: selectionBar
                
                function onUriRemoved(uri)
                {
                    if(uri === model.path)
                        delegate.checked = false
                }
                
                function onUriAdded(uri)
                {
                    if(uri === model.path)
                        delegate.checked = true
                }
                
                function onCleared(uri)
                {
                    delegate.checked = false
                }
            }
        }
    }
    
    
    /**
     * 
     */
    function groupBy()
    {
        var prop = ""
        var criteria = ViewSection.FullString
        
        switch(control.currentFMList.sortBy)
        {
            case Maui.FMList.LABEL:
                prop = "label"
                criteria = ViewSection.FirstCharacter
                break;
            case Maui.FMList.MIME:
                prop = "mime"
                break;
            case Maui.FMList.SIZE:
                prop = "size"
                break;
            case Maui.FMList.DATE:
                prop = "date"
                break;
            case Maui.FMList.MODIFIED:
                prop = "modified"
                break;
        }
        
        if(!prop)
        {
            control.currentView.section.property = ""
            return
        }
        
        control.settings.viewType = Maui.FMList.LIST_VIEW
        control.currentView.section.property = prop
        control.currentView.section.criteria = criteria
    }
}
