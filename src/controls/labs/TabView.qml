import QtQuick 2.15
import QtQml 2.14

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

Container
{
    id: control
    
    spacing: 0
    
    property alias holder : _holder
    property bool mobile : Kirigami.Settings.isMobile
    
    property bool overviewMode : false
    
    property bool tabBarVisible : true
    
    signal newTabClicked()
    signal closeTabClicked(int index)
    
    Keys.enabled: true
    Keys.onPressed:
    {
        if((event.key === Qt.Key_H) && (event.modifiers & Qt.ControlModifier))
        {
            control.findTab()
        }
    }
    
    Maui.ContextualMenu
    {
        id: _menu
        parent: control
        property int index //tabindex
        
        MenuItem
        {
            text: i18n("Open")
            onTriggered:
            {
                control.currentIndex = _menu.index
                control.overviewMode = false
            }
        }
        
        MenuItem
        {
            text: i18n("Close")
            onTriggered:
            {
                control.closeTabClicked(_menu.index)
            }
        }
        
        MenuItem
        {
            text: i18n("Close Other")
            onTriggered:
            {
                control.closeTabClicked(_menu.index)
            }
        }
        
        MenuItem
        {
            text: i18n("Close All")
            onTriggered:
            {
                control.closeTabClicked(_menu.index)
            }
        }
    }
    
    data: Loader
    {
        id: _loader    
    }
    
    Component
    {
        id: _quickSearchComponent
        
        Maui.Dialog
        {
            id: _quickSearch
            defaultButtons: false
                persistent: false
                headBar.visible: true
                
                onOpened: _quickSearchField.forceActiveFocus()
                
                function find(query)
                {
                    for(var i = 0; i < control.count; i ++)
                    {
                        var obj = control.contentModel.get(i)
                        if(obj.Maui.TabViewInfo.tabTitle)
                        {
                            console.log("Trying to find tab", i, query, obj.Maui.TabViewInfo.tabTitle, String(obj.Maui.TabViewInfo.tabTitle).indexOf(query))
                            
                            if(String(obj.Maui.TabViewInfo.tabTitle).toLowerCase().indexOf(query.toLowerCase()) !== -1)
                            {
                                return i
                            }
                        }
                    }
                    
                    return -1
                }
                
                Timer
                {
                    id: _typingTimer
                    interval: 250
                    onTriggered:
                    {
                        var index = _quickSearch.find(_quickSearchField.text)
                        if(index > -1)
                        {
                            _filterTabsList.currentIndex = index
                        }
                    }
                }
                
                headBar.middleContent: Maui.TextField
                {
                    id: _quickSearchField
                    Layout.fillWidth: true
                    Layout.maximumWidth: 500
                    
                    onTextChanged: _typingTimer.restart()
                    
                    onAccepted:
                    {
                        control.currentIndex = _filterTabsList.currentIndex
                        _quickSearch.close()
                        control.currentItem.forceActiveFocus()
                    }
                    
                    Keys.enabled: true
                    
                    Keys.onPressed:
                    {
                        if((event.key === Qt.Key_Up))
                        {
                            _filterTabsList.flickable.decrementCurrentIndex()
                        }
                        
                        if((event.key === Qt.Key_Down))
                        {
                            _filterTabsList.flickable.incrementCurrentIndex()
                        }
                    }
                }
                
                stack: Maui.ListBrowser
                {
                    id: _filterTabsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: control.currentIndex
                    
                    model: control.count
                    
                    delegate: Maui.ListDelegate
                    {
                        width: ListView.view.width
                        
                        label: control.contentModel.get(index).Maui.TabViewInfo.tabTitle
                        
                        onClicked:
                        {
                            currentIndex =index
                            control.currentIndex = index
                            _quickSearch.close()
                        }
                    }
                }
        }
    }
    
    contentItem: ColumnLayout
    {
        spacing: 0
        
        Loader
        {            
            asynchronous: false
            active: control.count > 1 && !control.mobile && control.tabBarVisible
            Layout.fillWidth: true
            visible: active
            
            sourceComponent: Maui.TabBar
            {        
                id: _tabBar
                position: TabBar.Header                
                
                Binding on currentIndex
                {
                    value: control.currentIndex
                    restoreMode: Binding.RestoreValue
                }
                
                onNewTabClicked: control.newTabClicked()
                
                Keys.onPressed:
                {
                    if(event.key == Qt.Key_Return)
                    {
                        control.currentIndex = currentIndex
                    }
                    
                    if(event.key == Qt.Key_Down)
                    {
                        control.currentItem.forceActiveFocus()
                    }
                }
                
                Repeater
                {
                    id: _repeater
                    model: control.count
                    
                    Maui.TabButton
                    {
                        id: _tabButton
                        property int mindex : index
                        
                        implicitHeight: ListView.view.height
                        width: Math.max(Math.floor((ListView.view.width / _repeater.count) -(_tabBar.spacing * _repeater.count)), 200)
                        checked: ListView.isCurrentItem
                        text: control.contentModel.get(index).Maui.TabViewInfo.tabTitle
                        
                        ToolTip.delay: 1000
                        ToolTip.timeout: 5000
                        ToolTip.visible: ( _tabButton.hovered )
                        ToolTip.text: control.contentModel.get(index).Maui.TabViewInfo.tabToolTipText
                        
                        onClicked:
                        {
                            control.currentIndex = index
                            control.currentItem.forceActiveFocus()
                        }
                        
                        onRightClicked:
                        {
                            _menu.index = index
                            _menu.show()
                        }
                        
                        onCloseClicked:
                        {
                            control.closeTabClicked(index)
                        }
                        
                        //Drag.active: dragArea.held
                        //Drag.source: _tabButton
                        //Drag.hotSpot.x: width / 2
                        //Drag.hotSpot.y: height / 2
                        //Drag.dragType: Drag.Automatic
                        
                        
                        //Label
                        //{
                            //color: "orange"
                            //text: mindex + " - " + _tabBar.currentIndex + " = " + control.currentIndex
                        //}
                        
                        //MouseArea
                        //{
                            //id: dragArea
                            //anchors.fill: parent
                            //property bool held: false
                            
                            //drag.target: held ? _tabButton : undefined
                            //drag.axis: Drag.XAxis
                            //drag.smoothed: false
                            //preventStealing: false
                            //propagateComposedEvents: true
                            //onPressAndHold: held = true
                            //onReleased:
                            //{
                                //held = false
                            //}
                            //onClicked:
                            //{
                                //control.currentIndex = index
                                //control.currentItem.forceActiveFocus()
                            //}
                        //}
                        
                        
                        Timer
                        {
                            id: _dropAreaTimer
                            interval: 250
                            onTriggered:
                            {
                                if(_dropArea.containsDrag)
                                {
                                    control.currentIndex = index
                                }
                            }
                        }
                        
                        DropArea
                        {
                            id: _dropArea
                            anchors.fill: parent
                            onEntered:
                            {
                                //console.log("Move ", drop.source.mindex,
                                            //_tabButton.mindex)
                                //const from = drop.source.mindex
                                //const to = _tabButton.mindex
                                
                                                                //control.moveItem(from , to)
                                                                //_tabBar.moveItem(from , to)
                                _dropAreaTimer.restart()
                            }
                            
                            onExited:
                            {
                                _dropAreaTimer.stop()
                            }
                        }
                        
                        //Kirigami.Separator
                        //{
                        
                        //height: 0.5
                        //weight: Kirigami.Separator.Weight.Light
                        //visible: index < control.count
                        //anchors
                        //{
                        //bottom: parent.bottom
                        //top: parent.top
                        //right: parent.right
                        //}
                        //}
                    }
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            visible: active && !control.overviewMode
            
            Layout.fillWidth: true
            active: control.count > 1 && control.mobile && control.tabBarVisible
            
            sourceComponent: Maui.TabBar
            {
                Kirigami.Theme.colorSet: Kirigami.Theme.Header
                Kirigami.Theme.inherit: false
                showNewTabButton: false
                position: ToolBar.Header
                
                Maui.TabButton
                {
                    implicitWidth: ListView.view.width
                    implicitHeight: ListView.view.height
                    closeButtonVisible: control.count > 1
                    text: control.currentItem.Maui.TabViewInfo.tabTitle
                    checked: true
                    centerLabel: false
                    onClicked: openOverview()
                    onCloseClicked:
                    {
                        control.closeTabClicked(control.currentIndex)
                    }
                    
                    leftContent: Item
                    {
                        height: parent.height
                        implicitWidth: height
                        
                        Maui.Badge
                        {
                            anchors.centerIn: parent
                            text: control.count
                            radius: Maui.Style.radiusV
                        }
                    }
                }
            }
        }
        

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

        ListView
        {
           height: parent.height
           width: parent.width
            model: control.contentModel
            interactive: false
            currentIndex: control.currentIndex
            spacing: 0
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            
            boundsBehavior: Flickable.StopAtBounds
            boundsMovement :Flickable.StopAtBounds
            
            preferredHighlightBegin: 0
            preferredHighlightEnd: width
            
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 0
            highlightFollowsCurrentItem: true
            highlightResizeDuration: 0
            highlightMoveVelocity: -1
            highlightResizeVelocity: -1
            
            maximumFlickVelocity: 4 * width
            
            cacheBuffer: control.count * width
            keyNavigationEnabled : false
            keyNavigationWraps : false
            
            Maui.Holder
            {
                id: _holder
                anchors.fill: parent
                visible: !control.count
                emojiSize: Maui.Style.iconSizes.huge
            }

            scale: control.overviewMode ? 0.5 : 1
            opacity: control.overviewMode ? 0  : 1
            Behavior on scale
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.longDuration 
                    easing.type: Easing.InOutQuad
                }
            }

            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
        
        Loader
        {
            active: (control.count > 1 && control.mobile) || item
            visible: active && control.overviewMode
            asynchronous: true
            anchors.fill: parent
           
            sourceComponent: Rectangle
            {
                Kirigami.Theme.colorSet: Kirigami.Theme.Window
                Kirigami.Theme.inherit: false
                
                color: Kirigami.Theme.backgroundColor
                
                Maui.GridView
                {
                    id: _overviewGrid
                    
                    anchors.fill: parent
                    model: control.count
                    currentIndex: control.currentIndex
                    itemSize: Math.floor(width / 3)
                    itemHeight:  Math.floor(height / 3)
                    
                    onAreaClicked:
                    {
                        control.overviewMode = false
                    }
                    
                    delegate: Item
                    {
                        height: GridView.view.cellHeight
                        width: GridView.view.cellWidth

                        Maui.GridBrowserDelegate
                        {
                            id: _delegate
                            anchors.centerIn: parent
                            width: _overviewGrid.itemSize - Maui.Style.space.small
                            height: _overviewGrid.itemHeight  - Maui.Style.space.small
                            
                            isCurrentItem : parent.GridView.isCurrentItem
                            label1.text: control.contentModel.get(index).Maui.TabViewInfo.tabTitle
                            iconSource: "tab-new"
                            
                            onRightClicked:
                            {
                                control.currentIndex = index
                                _menu.index = control.currentIndex
                                _menu.show()
                            }
                            
                            onClicked:
                            {
                                control.currentIndex = index
                                control.overviewMode = false
                                control.currentItem.forceActiveFocus()
                            }
                            
                            onPressAndHold:
                            {
                                control.currentIndex = index
                                _menu.index = control.currentIndex
                                _menu.show()
                            }
                            
                            template.iconComponent: Item
                            {
                                clip: true
                                
                                ShaderEffectSource
                                {
                                    id: _effect
                                    
                                    anchors.centerIn: parent
                                    
                                    height: _overviewGrid.itemHeight - 4
                                    width: _overviewGrid.itemSize - 4
                                    
                                    hideSource: visible
                                    live: true
                                    textureSize: Qt.size(width,height)
                                    sourceItem: control.contentModel.get(index)
                                    
                                }
                            }
                            
                            background: Kirigami.ShadowedRectangle
                            {
                                color: Qt.lighter(Kirigami.Theme.backgroundColor)
                                property int radius : Maui.Style.radiusV
                                border.color: _delegate.hovered || _delegate.containsPress? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
                                border.width: 1
                                corners
                                {
                                    topLeftRadius: radius
                                    topRightRadius: radius
                                    bottomLeftRadius: radius
                                    bottomRightRadius: radius
                                }
                                
                                shadow.xOffset: 0
                                shadow.yOffset: 0
                                shadow.color: Qt.rgba(0, 0, 0, 0.3)
                                shadow.size: 10
                            }
                        }
                    }
                }
            }
        }
        
    }
    }
    
    function closeTab(index)
    {
        control.removeItem(control.takeItem(index))
        control.currentItemChanged()
        control.currentItem.forceActiveFocus()
    }
    
    function addTab(component, properties)
    {
        const object = component.createObject(control.contentModel, properties);
        
        control.addItem(object)
        control.currentIndex = Math.max(control.count -1, 0)
        object.forceActiveFocus()
        
        return object
    }
    
    function findTab()
    {
        if(control.count > 1)
        {
            _loader.sourceComponent = _quickSearchComponent
            _loader.item.open()
        }
    }
    
    function openOverview()
    {
        control.overviewMode = !control.overviewMode
    }
}
