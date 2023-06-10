import QtQuick
import QtQml

import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import org.mauikit.controls as Maui

Pane
{
    id: control

    default property alias content: _listView.contentData
    property alias contentModel: _listView.contentModel
    property alias currentIndex: _listView.currentIndex
    property alias currentItem: _listView.currentItem
    property alias count: _listView.count

    property alias holder : _holder
    property bool mobile : control.width <= Maui.Style.units.gridUnit * 30
    property bool altTabBar : false
    property bool interactive: Maui.Handy.isTouch

    readonly property bool overviewMode :  _stackView.depth === 2

    property alias tabBar: _tabBar
    
    property alias menu :_menu
    
    property list<Action> menuActions
    
    property Component tabViewButton :  _tabButtonComponent
    
    onWidthChanged: _tabBar.positionViewAtIndex(control.currentIndex)
    onCurrentIndexChanged: _tabBar.positionViewAtIndex(control.currentIndex)

    spacing: 0

    Component
    {
        id: _tabButtonComponent
        
        Maui.TabViewButton
        {
            id: _tabButton
            tabView: control
            closeButtonVisible: !control.mobile
            
            leftContent: Maui.Badge
            {
                width: visible ? implicitWidth : 0
                visible: control.mobile && _tabButton.checked && control.count > 1
                text: control.count
            }
            
            onClicked:
            {
                if(_tabButton.mindex === control.currentIndex)
                {
                    control.openOverview()
                    return
                }
                
                _listView.setCurrentIndex(_tabButton.mindex)
            }
            
            onRightClicked:
            {
                openTabMenu(_tabButton.mindex)
            }
            
            onCloseClicked:
            {
                control.closeTabClicked(_tabButton.mindex)
            }
        }
    }

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
                _listView.setCurrentIndex(_menu.index)
                control.closeOverview()
            }
        }
        
        MenuItem
        {
            text: i18nd("mauikit", "Duplicate")
            icon.name: "tab-duplicate"
            onTriggered: {}
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
        
        Maui.PopupPage
        {
            id: _quickSearch
            persistent: false
            headBar.visible: true

            onOpened: _quickSearchField.forceActiveFocus()

            function find(query)
            {
                for(var i = 0; i < control.count; i ++)
                {
                    var obj = _listView.contentModel.get(i)
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
                currentIndex: _listView.currentIndex

                model: _listView.count

                delegate: Maui.ListDelegate
                {
                    width: ListView.view.width

                    label: _listView.contentModel.get(index).Maui.TabViewInfo.tabTitle

                    onClicked:
                    {
                        currentIndex =index
                        _listView.setCurrentIndex(index)
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
            
            initialItem:  Item
            {
                Maui.TabBar
                {
                    id: _tabBar
                    
                    z : _listView.z+1
                    
                    anchors.left: parent.left
                    anchors.right: parent.right
                    
                    visible: _listView.count > 1
                    
                    interactive: control.interactive
                    showNewTabButton: !control.mobile
                    
                    onNewTabClicked: control.newTabClicked()
                    onNewTabFocused:
                    {
                        if(control.mobile)
                        {
                            _listView.setCurrentIndex(index)
                        }
                    }
                    
                    position: control.altTabBar ? TabBar.Footer : TabBar.Header
                    
                    Repeater
                    {
                        model: control.count
                        delegate: control.tabViewButton
                    }
                    
                    Keys.onPressed:
                    {
                        if(event.key == Qt.Key_Return)
                        {
                            _listView.setCurrentIndex(currentIndex)
                        }
                        
                        if(event.key == Qt.Key_Down)
                        {
                            _listView.currentItem.forceActiveFocus()
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
                
                SwipeView
                {
                    id: _listView
                    anchors.fill: parent
                    
                    anchors.bottomMargin: control.altTabBar && _tabBar.visible ? _tabBar.height : 0
                    anchors.topMargin: !control.altTabBar && _tabBar.visible ? _tabBar.height : 0
                    
                    interactive: false
                    
                    spacing: control.spacing
                    
                    clip: control.clip
                    
                    orientation: ListView.Horizontal
                    background: null
                    
                    contentItem: ListView
                    {
                        id: _listView2
                        model: _listView.contentModel
                        interactive: false
                        currentIndex: _listView.currentIndex
                        
                        spacing: _listView.spacing
                        
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
                        
                        cacheBuffer: _listView.count * width
                        keyNavigationEnabled : false
                        keyNavigationWraps : false
                    }
                }
                
                Maui.Holder
                {
                    id: _holder
                    anchors.fill: parent
                    visible: !control.count
                    emojiSize: Maui.Style.iconSizes.huge
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
                        
                        itemSize: Math.floor(flickable.width / 3)
                        itemHeight:  Math.floor(flickable.height / 3)
                        
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
                                label1.text: _listView.contentModel.get(index).Maui.TabViewInfo.tabTitle
                                //                                 template.labelSizeHint: 32
                                iconSource: "tab-new"
                                flat: false
                                
                                onRightClicked:
                                {
                                    _listView.setCurrentIndex(index)
                                    openTabMenu(_listView.currentIndex)
                                }
                                
                                onClicked:
                                {
                                    control.closeOverview()
                                    _listView.setCurrentIndex(index)
                                }
                                
                                onPressAndHold:
                                {
                                    _listView.setCurrentIndex(index)
                                    openTabMenu(control.currentIndex)
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
                                        sourceItem: _listView.contentModel.get(index)
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
                                        
                                        onClicked: control.closeTabClicked(index)
                                        
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
        _listView.removeItem(_listView.itemAt(index))
        // _tabBar.removeItem(_tabBar.itemAt(index))
        
        _listView.currentItemChanged()
        _listView.currentItem.forceActiveFocus()
    }
    
    function addTab(component, properties, quiet = false) : Item
    {
        if(control.overviewMode)
        {
            control.closeOverview()
        }

            const object = component.createObject(control, properties);

            _listView.addItem(object)

            if(!quiet)
            {
                _listView.setCurrentIndex(Math.max(_listView.count -1, 0))
                object.forceActiveFocus()
            }

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

                                function moveTab(from, to)
                                {
                                    _listView.moveItem(from, to)
                                    _tabBar.moveItem(from, to)

                                    _listView.setCurrentIndex(to)
                                    _tabBar.setCurrentIndex(_listView.currentIndex)

                                    _listView2.positionViewAtIndex(_listView.currentIndex, ListView.Contain)

                                    _listView.currentItemChanged()
                                    _listView.currentItem.forceActiveFocus()

                                }

                                    function setCurrentIndex(index)
                                    {
                                        _tabBar.setCurrentIndex(index)
                                        _listView.setCurrentIndex(index)
                                        _listView.currentItem.forceActiveFocus()
                                    }

                                        function tabAt(index)
                                        {
                                            return _listView.itemAt(index)
                                        }

                                            function openTabMenu(index)
                                            {
                                                _menu.index = index
                                                _menu.show()
                                            }
                                            }
