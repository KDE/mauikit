import QtQuick 2.15
import QtQml 2.14

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10
import QtGraphicalEffects 1.15

import org.mauikit.controls 1.3 as Maui

import QtQuick.Templates 2.15 as T

T.Container
{
    id: control
       
    property alias holder : _holder
    property bool mobile : control.width <= Maui.Style.units.gridUnit * 30
    property bool altTabBar : false
    
    readonly property bool overviewMode :  _stackView.depth === 2
    
    property alias tabBar: _tabBar    
    
    property alias menu :_menu
    
    property list<Action> menuActions
    
    property Component tabViewButton :  _tabButtonComponent
    
    onWidthChanged: _tabBar.positionViewAtIndex(control.currentIndex)
    onCurrentIndexChanged: _tabBar.positionViewAtIndex(control.currentIndex)
    
    background: Rectangle
    {
        color: Maui.Theme.backgroundColor
    }
    
    Component
    {
        id: _tabButtonComponent
        
        Maui.TabViewButton
        {
            id: _tabButton
            tabView: control
            tabBar: control.tabBar
            closeButtonVisible: !control.mobile
            
            leftContent: Maui.Badge
            {
                width: visible ? implicitWidth : 0
                visible: control.mobile && _tabButton.checked
                text: control.count
                radius: Maui.Style.radiusV
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
        }
    }
    
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
            text: i18nd("mauikit", "Open")
            icon.name: "tab-new"
            onTriggered:
            {
                control.setCurrentIndex(_menu.index)
                control.closeOverview()
            }
        }
        
        MenuItem
        {
            text: i18nd("mauikit", "Duplicate")
            icon.name: "tab-duplicate"
            onTriggered:
            {
            }
        }
        
        
        MenuItem
        {
            text: i18nd("mauikit", "Close")
            icon.name: "tab-close"
            onTriggered:
            {
                control.closeTabClicked(_menu.index)
            }
        }
        
        MenuItem
        {
            text: i18nd("mauikit", "Close Other")
            onTriggered:
            {
                control.closeTabClicked(_menu.index)
            }
        }
        
        MenuItem
        {
            text: i18nd("mauikit", "Close All")
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
                
                headBar.middleContent: TextField
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
                    
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 300; easing.type: Easing.InOutCubic }
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
                    
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.OutCubic }
                }
            }
            
            popEnter: Transition
            {
                ParallelAnimation
                {
                    PropertyAnimation
                    {
                        property: "scale"
                        from: 1
                        to: 1
                        duration: 0
                        easing.type: Easing.InOutCubic
                    }
                    
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutCubic }
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
                Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Maui.TabBar
                {
                    id: _tabBar
                    z : _listView.z+1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    
                    visible: control.count > 1   
                    
                    interactive: control.mobile
                                        
                    currentIndex: control.currentIndex                
                    showNewTabButton: !mobile
                    
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
                    
                    states: [  State
                    {
                        when: !control.altTabBar && control.tabBar.visible
                        
                        AnchorChanges
                        {
                            target: _tabBar
                            anchors.top: parent.top
                            anchors.bottom: undefined
                        }
                        
                        PropertyChanges
                        {
                            target: _tabBar
                            position: TabBar.Header
                        }
                    },
                    
                    State
                    {
                        when: control.altTabBar && control.tabBar.visible
                        
                        AnchorChanges
                        {
                            target: _tabBar
                            anchors.top: undefined
                            anchors.bottom: parent.bottom
                        }
                        
                        PropertyChanges
                        {
                            target: _tabBar
                            position: ToolBar.Footer
                        }
                    } ]
                }
                
                ListView
                {  
                    id: _listView
                    anchors.fill: parent
                    
                    anchors.bottomMargin: control.altTabBar && _tabBar.visible ? _tabBar.height : 0
                    anchors.topMargin: !control.altTabBar && _tabBar.visible ? _tabBar.height : 0 
                    
                    model: control.contentModel
                    interactive: false
                    currentIndex: control.currentIndex
                    
                    spacing: control.spacing
                    
                    clip: false
                    
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
            }
            Component
            {
                id: _overviewComponent
               
                Pane
                {
                    Maui.Theme.colorSet: Maui.Theme.View
                    Maui.Theme.inherit: false
                    
                    Maui.GridBrowser
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
                                
                                anchors.fill: parent
                                anchors.margins: Maui.Style.space.medium
                                
                                isCurrentItem : parent.GridView.isCurrentItem
                                label1.text: control.contentModel.get(index).Maui.TabViewInfo.tabTitle
//                                 template.labelSizeHint: 32
                                iconSource: "tab-new"
                                flat: false
                                
                                onRightClicked:
                                {
                                    control.setCurrentIndex(index)
                                    _menu.index = control.currentIndex
                                    _menu.show()
                                }
                                
                                onClicked:
                                {
                                    control.closeOverview()
                                    control.setCurrentIndex(index)                                    
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
                                        
                                        hideSource: false
                                        live: false
//                                        mipmap: true
                                        
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
        _tabBar.addItem(control.tabViewButton.createObject(_tabBar))
        
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
