import QtQuick 2.15
import QtQml 2.14

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

import QtQuick.Templates 2.15 as T

T.Container
{
    id: control
       
    property alias holder : _holder
    property bool mobile : control.width <= Maui.Style.units.gridUnit * 30
    
    readonly property bool overviewMode :  _stackView.depth === 2
    
    property alias tabBar: _tabBar
    
    property list<Action> menuActions
    
    spacing: 0
        
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
        
        Repeater
        {
            model: control.menuActions
            delegate: MenuItem
            {
                action: modelData
            }
        }
        
        MenuItem
        {
            text: i18n("Open")
            icon.name: "tab-new"
            onTriggered:
            {
                control.setCurrentIndex(_menu.index)
                control.closeOverview()
            }
        }
        
        MenuItem
        {
            text: i18n("Duplicate")
            icon.name: "tab-duplicate"
            onTriggered:
            {
            }
        }
        
        
        MenuItem
        {
            text: i18n("Close")
            icon.name: "tab-close"
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
                        control.setCurrentIndex(_filterTabsList.currentIndex)
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
                            control.setCurrentIndex(index)
                            _quickSearch.close()
                        }
                    }
                }
        }
    }
    
    contentItem: Item
    {
        StackView
        {
            anchors.fill: parent
            id: _stackView
            
            pushExit: Transition
            {
                ParallelAnimation
                {
                    PropertyAnimation
                    {
                        property: "scale"
                        from: 1
                        to: 0
                        duration: 200
                        easing.type: Easing.InOutCubic
                    }
                    
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.InOutCubic }
                }
                
            }
            
            pushEnter: Transition
            {
                ParallelAnimation
                {
                    PropertyAnimation
                    {
                        property: "scale"
                        from: 4
                        to: 1
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                    
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutCubic }
                }
            }
            
            popEnter: Transition
            {
                ParallelAnimation
                {
                    PropertyAnimation
                    {
                        property: "scale"
                        from: 0.5
                        to: 1
                        duration: 200
                        easing.type: Easing.InOutCubic
                    }
                    
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.InOutCubic }
                }
            }
            
            popExit: Transition
            {
                ParallelAnimation
                {
//                     //PropertyAnimation
//                     //{
//                     //property: "scale"
//                     //from: 1
//                     //to: 4
//                     //duration: 200
//                     //easing.type: Easing.OutCubic
//                     //}
//                     
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200; easing.type: Easing.OutCubic }
                }
                
            }
            
            initialItem: ColumnLayout
            {
                spacing: 0
                
                Maui.TabBar
                {
                    id: _tabBar
                    Layout.fillWidth: true
                    visible: control.count > 1    
                    interactive: control.mobile
                    
                    position: TabBar.Header
                    
                    currentIndex: control.currentIndex                
                    
                    onNewTabClicked: control.newTabClicked()
                    onNewTabFocused: control.setCurrentIndex(index)
                    
                    Keys.onPressed:
                    {
                        if(event.key == Qt.Key_Return)
                        {
                            control.setCurrentIndex(currentIndex)                        
                        }
                        
                        if(event.key == Qt.Key_Down)
                        {
                            control.currentItem.forceActiveFocus()
                        }
                    }    
                   
                    Component
                    {
                        id: _tabButtonComponent
                        
                        Maui.TabButton
                        {
                            id: _tabButton
                            
                            readonly property int mindex : _tabButton.TabBar.index
                            
                            implicitHeight: ListView.view.height
                            
                            width: control.mobile ? ListView.view.width : Math.max(Math.floor((ListView.view.width / _tabButton.TabBar.tabBar.count) -(_tabBar.spacing * control.count)), 200)
                            
                            checked: _tabButton.mindex === control.currentIndex
                            text: control.contentModel.get(mindex).Maui.TabViewInfo.tabTitle
                            
                            ToolTip.delay: 1000
                            ToolTip.timeout: 5000
                            ToolTip.visible: ( _tabButton.hovered )
                            ToolTip.text: control.contentModel.get(mindex).Maui.TabViewInfo.tabToolTipText
                                                    
                            leftContent: Maui.Badge
                            {
                                width: visible ? implicitWidth : 0
                                visible: control.mobile && _tabButton.checked
                                text: control.count
                                radius: Maui.Style.radiusV
                                anchors.verticalCenter: parent.verticalCenter
                            }                            
                            
                            onClicked:
                            {
                                if(_tabButton.mindex === control.currentIndex)
                                {
                                    control.openOverview()
                                    return
                                }
                                
                                control.setCurrentIndex(_tabButton.mindex)
                                control.currentItem.forceActiveFocus()
                            }
                            
                            onRightClicked:
                            {
                                _menu.index = _tabButton.mindex
                                _menu.show()
                            }
                            
                            onCloseClicked:
                            {
                                control.closeTabClicked(_tabButton.mindex)
                            }
                            
                            Drag.active: dragArea.active
                            Drag.source: _tabButton
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.dragType: Drag.Automatic
                            Drag.proposedAction: Qt.IgnoreAction
                            
                            //                         Label
                            //                         {
                            //                             color: "orange"
                            //                             text: mindex + " - " + _tabBar.currentIndex + " = " + control.currentIndex
                            //                         }
                            
                            DragHandler
                            {
                                id: dragArea
                                enabled: !control.mobile
                                acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus | PointerDevice.GenericPointer
                                target: null
                                xAxis.enabled: true
                                yAxis.enabled: false
                                cursorShape: Qt.OpenHandCursor
                                
                                onActiveChanged:
                                {
                                    if (active) 
                                    {
                                        _tabButton.grabToImage(function(result)
                                        {
                                            _tabButton.Drag.imageSource = result.url;
                                        })
                                    }
                                }
                            }                        
                            
                            Timer
                            {
                                id: _dropAreaTimer
                                interval: 250
                                onTriggered:
                                {
                                    if(_dropArea.containsDrag)
                                    {
                                        control.setCurrentIndex(mindex)
                                    }
                                }
                            }
                            
                            DropArea
                            {
                                id: _dropArea
                                property int dropSide : -1
                                anchors.fill: parent
                                onDropped:
                                {                             
                                    const from = drop.source.mindex
                                    const to = _tabButton.mindex
                                    
                                    if(to === from)
                                    {
                                        return
                                    }
                                    
                                    console.log("Move ", drop.source.mindex,
                                                _tabButton.mindex)
                                    
                                    dropSide = from > to ? 1 : 0
                                    
                                    control.moveItem(from , to)
                                    _tabBar.moveItem(from , to)
                                    
                                    _tabBar.setCurrentIndex(to)
                                    control.setCurrentIndex(to)                                    
                                    
                                    control.currentItemChanged()
                                    control.currentItem.forceActiveFocus()
                                }
                                
                                onEntered: 
                                {
                                    if(drag.source &&  drag.source.mindex >= 0)
                                    {
                                        return
                                    }
                                    _dropAreaTimer.restart()    
                                }
                                
                                onExited:
                                {
                                    _dropAreaTimer.stop()
                                }
                            }
                        }
                    }
                }
                
                ListView
                {  
                    Layout.fillWidth: true
                    Layout.fillHeight: true            
                    
                    model: control.contentModel
                    interactive: false
                    currentIndex: control.currentIndex
                    
                    spacing: control.spacing
                    
                    clip: true
                    
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
                }
            }  
            
            Component
            {
                id: _overviewComponent
               
                Pane
                {
                    Maui.Theme.colorSet: Maui.Theme.View
                    Maui.Theme.inherit: false
                    
                    Maui.GridView
                    {
                        id: _overviewGrid
                        
                        anchors.fill: parent
                        
                        model: control.count
                        
                        currentIndex: control.currentIndex
                        
                        itemSize: Math.floor(width / 3)
                        itemHeight:  Math.floor(height / 3)
                        
                        Maui.FloatingButton
                        {
                            icon.name: "list-add"
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.margins: Maui.Style.space.big
                            onClicked: control.newTabClicked()
                        }
                        
                        onAreaClicked:
                        {
                            control.closeOverview()
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
//                                 template.labelSizeHint: 32
                                iconSource: "tab-new"
//                                 flat: true
                                
                                onRightClicked:
                                {
                                    control.setCurrentIndex(index)
                                    _menu.index = control.currentIndex
                                    _menu.show()
                                }
                                
                                onClicked:
                                {
                                    control.setCurrentIndex(index)
                                    control.closeOverview()
                                    control.currentItem.forceActiveFocus()
                                }
                                
                                onPressAndHold:
                                {
                                    control.setCurrentIndex(index)
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
                                        
                                        height: Math.round(sourceItem.height * (parent.height/control.height))
                                        width: Math.round(sourceItem.width * (parent.width/control.width))
                                        
                                        hideSource: true
                                        live: false
                                        mipmap: true
                                        
                                        textureSize: Qt.size(width,height)
                                        sourceItem: control.contentModel.get(index)
                                        layer.enabled: true
                                        layer.effect: OpacityMask
                                        {
                                            maskSource: Rectangle
                                            {
                                                width: _effect.width
                                                height: _effect.height
                                                radius: Maui.Style.radiusV
                                            }            
                                        }
                                    }
                                                                        
                                    Maui.CloseButton
                                    {
                                        id: _closeButton
                                        visible: _delegate.isCurrentItem || _delegate.hovered || Maui.Handy.isMobile
                                        anchors.top: parent.top
                                        anchors.right: parent.right
//                                         anchors.margins: Maui.Style.space.small
                                        
                                        onClicked: control.closeTab(index)
                                        
                                        background: Rectangle
                                        {
                                            radius: height/2
                                            color: _closeButton.hovered || _closeButton.containsPress ? Maui.Theme.negativeBackgroundColor : Maui.Theme.backgroundColor  
                                            
                                            Behavior on color
                                            {
                                                Maui.ColorTransition{}
                                            }
                                        }
                                    }
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
        control.removeItem(control.itemAt(index))
        _tabBar.removeItem(_tabBar.itemAt(index))
        
        control.currentItemChanged()
        control.currentItem.forceActiveFocus()
    }
    
    function addTab(component, properties)
    {
        if(control.overviewMode)
        {
            control.closeOverview()
        }
        
        const object = component.createObject(control.contentModel, properties);
        
        control.addItem(object)
        _tabBar.addItem(_tabButtonComponent.createObject(_tabBar))
        
        control.setCurrentIndex(Math.max(control.count -1, 0))
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
        if(_stackView.depth === 2)
        {
            return
        }
        _stackView.push(_overviewComponent)
    }
    
    function closeOverview()
    {
        if(_stackView.depth === 1)
        {
            return
        }
        
        _stackView.pop()
    }
}
