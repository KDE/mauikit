import QtQuick
import QtQml

import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import org.mauikit.controls 1.3 as Maui

/**
  @brief Container to organize items as a tab view.
  
  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-pane.html">This controls inherits from QQC2 Pane, to checkout its inherited properties refer to the Qt Docs.</a>
  
  The TabView organizes its children into different tabs - a tab for each child.
  There are two ways for adding tabs to this view. The first one and easier is to declare the items as children. This will create a tab for each declared child item.
  @see content
  
  @code
TabView
{
    Rectangle
    {
        TabViewInfo.tabTitle: "Tab1"
        TabViewInfo.tabIcon: "folder"
        color: "blue"
    }
    
    Rectangle
    {
        TabViewInfo.tabTitle: "Tab2"
        TabViewInfo.tabIcon: "folder"
        color: "yellow"
    }
}
  @endcode
  
  The second way to create tabs dynamically by adding new items using the control functions.
  @see addTab
  
    @code
TabView
{
    id: _tabView
    tabBar.leftContent: Button
    {
        text: "Add Tab"
        onClicked: 
        {
            _tabView.addTab(_component)
        }
    }
    
    Component
    {
        id: _component
        Rectangle
        {
            TabViewInfo.tabTitle: "Tab1"
            TabViewInfo.tabIcon: "folder"
            color: "blue"
        }
    }
}
  @endcode
  
  @section structure Structure
  
  @note If you use this as the application window main control, remember you can use the attached Controls.showCSD property to display the window control buttons.
  @code
TabView
{
    Controls.showCSD : true
}
  @endcode
  
  
  The TabView has two main sections, [1] the main contents area and [2] the tab bar, where the tab buttons - representing all the tab views - are listed. 
  
  The tab bar listing has two "modes": one designed to fit desktop computers as a horizontal set of tab buttons; and the other one - more mobile friendly - as a grid overview of miniatures of the tab-views. Both modes can be toggle by using the mobile property.
  @see mobile
  
  The main tab bar - usually in the top section - can be moved to the bottom area, for better reachability.
  @see altTabBar
  
  The tab bar component is exposed via an alias, and items can be added to it - to the left or right side, using the leftContent or rightContent properties. This tab bar is handled by a MauiKit TabBar.
  @see tabBar
  @see TabBar
  
  @image html TabView/tabviews.png
@note TabView different states/sections. Further down the regular tab view with a tab bar on top, in the middle the tab view overview mode, and in the front the mobile mode wiht a single tab - other tab buttons can be flicked.

  
  @subsection finder Finder
  The TabView has an integrated dialog to quickly perform searchers for an tab. 
  
  @section notes Notes
  
  @subsection tabinfo Tabs Info
  To add information, such as title, icon, etc, to the views, there is the TabViewInfo attached property.
  Some of the available properties are:
  - TabViewInfo.tabTitle
  - TabViewInfo.tabToolTipText
  - TabViewInfo.tabColor
  - TabViewInfo.tabIcon
  @see TabViewInfo
  
  @subsection menus Menus
  It is possible to add actions to the the tab contextual menus.
  @see menuActions
  
  @subsection customize Custom Tab Button
  It is possible to set a different tab button for the tab bar. This will allow you to have more control about how the tab button is presented. To make it easier to integrate there is a control template that can be use as a base TabViewButton - different from TabButton.
  @see tabViewButton
  @see TabViewButton
  
  @note If you plan to change the tab button, consider using TabViewButton as a base, since it already has many of the needed things by the TabView to be integrated smoothly.
  
  @subsection functionality Functionality
  
  By default when clicking/tapping on the current tab button, the overview of tabs miniatures will be opened. The overview can also be oped using the corresponding function.
  @see openOverview
  @see closeOverview
  
  <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ApplicationWindow.qml">You can find a more complete example at this link.</a>
    
 */
Pane
{
    id: control

    /**
     * @brief Each one of the items declared as the children of this component will become a tab view.
     * @property list<QtObject> TabView::content
     */
    default property alias content: _listView.contentData
        
    /**
     * @brief  An alias to the model of the container.
     * @property model TabView::contentModel
     */    
    readonly property alias contentModel: _listView.contentModel
    
    /**
     * @brief Current index number of the current tab in the view port.
     * @property int TabView::currentIndex
     */
    property alias currentIndex: _listView.currentIndex
    
    /**
     * @brief The current item/tab view in focus.
     * @property Item TabView::currentItem
     */
    readonly property alias currentItem: _listView.currentItem
    
    /**
     * @brief The total amount of tab views in this container.
     * @property int TabView::count
     */
    property alias count: _listView.count

    /**
     * @brief An alias to a place holder text handled by a MauiKit Holder control. This is useful to display messages when there is not tab views in this container. To see how to set the message, icon and actions to it checkout the Holder documentation.
     * @see holder
     * @property Holder TabView::holder
     */
    property alias holder : _holder
    
    /**
     * @brief Whether the layout of the tab bar should be in mobile or desktop mode. In mobile mode there is only one tab button in the tab bar view port, other tab button can be navigated by using the touch swipe gesture. In mobile mode the main method to switch between tab views is using the overview.
     * @see structure
     */
    property bool mobile : control.width <= Maui.Style.units.gridUnit * 30
    
    /**
     * @brief Whether the tab bar hosting the tab buttons, should go in the bottom section or not. Moving it to the bottom section is a good idea for reachability in hand-held devices, such a phones. You can check if the current platform is a mobile one using the Handy attached property: Handy.isMobile
     * @see Handy
     * 
     */
    property bool altTabBar : false
    
    /**
     * @brief Whether the view will support swipe gestures for switching between tab views.
     */
    property bool interactive: Maui.Handy.isTouch
        
    /**
     * @brief Checks if the overview mode is open.
     */
    readonly property bool overviewMode :  _stackView.depth === 2

    /**
     * @brief An alias to the tab bar element. This is exposed so any other items can be placed on the right or left sections of it, or to fine tweak its public properties.
     * @see TabBar
     * @property TabBar TabView::tabBar
     */
    property alias tabBar: _tabBar
    
    /**
     * @brief An alias to the contextual menu for the tab buttons. This has a child property named index, which refers to the index number of the tab for which the contextual menu was opened.
     * @see ContextualMenu
     * @property ContextualMenu TabView::menu
     */
    property alias menu :_menu
    
    /**
     * @brief A set of actions can be added to the tab button contextual menu.
     * @code
     * TabView
     * {
     *  id: _tabView
     *  menuActions: Action
     *  {
     *      text: "Detach Tab"
     *      onTriggered: 
     *      {
     *          console.log("Detach tab at index, ", _tabView.menu.index)
     *      }
     *  }
     * }
     * @endcode
     */
    property list<Action> menuActions
    
    /**
     * @brief The delegate tab button used in the tab bar. This can be changed to any other item, but it is recommend it to use TabViewButton as the base of the new custom control for the existing integration work.
     */
    property Component tabViewButton :  _tabButtonComponent
    
    onWidthChanged: _tabBar.positionViewAtIndex(control.currentIndex)
    onCurrentIndexChanged: _tabBar.positionViewAtIndex(control.currentIndex)

    spacing: 0
    padding: 0

    Component
    {
        id: _tabButtonComponent
        
        Maui.TabViewButton
        {
            id: _tabButton
            tabView: control
            closeButtonVisible: !control.mobile

            onClicked:
            {
                if(_tabButton.mindex === control.currentIndex && control.count > 1)
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

    /**
     * @brief Emitted when the new-tab button has been clicked. This is the same as catching the signal from the TabBar element itself, using the exposed alias property.
     * @see tabBar
     */
    signal newTabClicked()
    
     /**
     * @brief Emitted when the close button has been clicked on a tab button, or tab miniature in the overview. This signal sends the index of the tab. To correctly close the tab and release the resources, use the function closeTab.
     * @param The index of the tab requested to be closed.
     * @see closeTab
     */
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
                    Maui.Controls.showCSD : control.Maui.Controls.showCSD === true
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

                    // rightContent: Button
                    // {
                    //     visible: control.mobile && control.count > 1
                    //     text: control.count
                    //     onClicked: openOverview()
                    // }

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
                    id: _pane
                    Maui.Theme.colorSet: Maui.Theme.View
                    Maui.Theme.inherit: false
                    
                    contentItem: Maui.GridBrowser
                    {
                        id: _overviewGrid
                        model: control.count
                        
                        currentIndex: control.currentIndex
                        
                        itemSize: Math.floor(_overviewGrid.flickable.width / 3)

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
    
    /**
     * @brief Close a tab view at a given index. This will release the resources, and move the focus to the previous tab view.
     * @param index Index of the tab to be closed.
     */
    function closeTab(index)
    {
        _listView.removeItem(_listView.itemAt(index))
        // _tabBar.removeItem(_tabBar.itemAt(index))
        
        _listView.currentItemChanged()
        _listView.currentItem.forceActiveFocus()
    }
    
    /**
     * @brief Adds a new tab view element, the passed element must be a component which will be created by the function and then added to the container.
     * @param component A Component element hosting the actual element to be created.
     * @param properties Another argument value that can be passed is a map of properties to be assigned to the component when created.
     * @param quiet An optionally you can choose to create the tab quietly or not: by quietly it means that the tab-component will be instantiated and created but will not be focused right away. If quiet is set to false - to which it defaults - then after the creation of the component the new tab will get focused.
     */
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
    
    /**
     * @brief Method to open the tab finder.
     */
    function findTab()
    {
        if(control.count > 1)
        {
            _loader.sourceComponent = _quickSearchComponent
            _loader.item.open()
        }
    }
    
     /**
     * @brief Method to open the tabs overview.
     */
    function openOverview()
    {
        if(_stackView.depth === 2)
        {
            return
        }
        _stackView.push(_overviewComponent)
    }
    
     /**
     * @brief Close the overview of miniature tabs.
     */
    function closeOverview()
    {
        if(_stackView.depth === 1)
        {
            return
        }
        
        _stackView.pop()
    }
    
     /**
     * @brief Method to correctly move a tab from one place to another by using the index numbers.
     * @param from the current index number of the tab to be moved.
     * @param to The new index value to where to move the tab.
     */
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
    
     /**
     * @brief This allows to change the current tab without breaking the bindings to the 'currentIndex' property.
     */
    function setCurrentIndex(index)
    {
        _tabBar.setCurrentIndex(index)
        _listView.setCurrentIndex(index)
        _listView.currentItem.forceActiveFocus()
    }
    
     /**
     * @brief Return the Item of the tab view at a given index number.
     * @return The Item element representing the tab view.
     */
    function tabAt(index)
    {
        return _listView.itemAt(index)
    }
    
     /**
     * @brief Opens the tab contextual menu at a given index number.
     */
    function openTabMenu(index)
    {
        _menu.index = index
        _menu.show()
    }
}
