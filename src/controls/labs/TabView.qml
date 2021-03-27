import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10

import QtGraphicalEffects 1.0

import org.kde.kirigami 2.13 as Kirigami
import org.kde.mauikit 1.3 as Maui

Container
{
    id: control
    
    clip: true

    property alias holder : _holder
    property bool mobile : Kirigami.Settings.isMobile

    readonly property bool overviewMode : _tabsOverview.checked
    
    signal newTabClicked()
    signal closeTabClicked(int index)

    contentItem: ColumnLayout
    {
        spacing: 0
        
        Maui.TabBar
        {
            id: tabsBar
            visible: control.count > 1 && !mobile
            Layout.fillWidth: true
            
            position: control.position
            
            currentIndex : control.currentIndex
            
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
                    implicitHeight: tabsBar.implicitHeight
                    implicitWidth: Math.max(parent.width / _repeater.count, 160)
                    checked: index === control.currentIndex
                    text: control.contentModel.get(index).title
                    
                    onClicked:
                    {
                        control.currentIndex = index
                    }
                    
                    onCloseClicked:
                    {
                        control.closeTabClicked(index)
                    }
                    
                    DropArea
                    {
                        id: _dropArea
                        anchors.fill: parent
                        onEntered: control.currentIndex = index
                    }
                    
                    Maui.Separator
                    {
                        edge: Qt.RightEdge
                        visible: index < control.count
                        anchors
                        {
                            bottom: parent.bottom
                            top: parent.top
                            right: parent.right
                        }
                    }
                }
            }
        }
        
        Maui.TabBar
        {
            Layout.fillWidth: true

            visible: control.count > 1 && mobile && !control.overviewMode
            
            position: ToolBar.Header
            
            Maui.TabButton
            {
                width: parent.width
                height: parent.height
                closeButtonVisible: control.count > 1
                text: control.currentItem.title
                checked: !control.overviewMode
                onClicked: _tabsOverview.toggle()
                onCloseClicked:
                {
                    control.closeTabClicked(control.currentIndex)
                }
                
                content: ToolButton
                {
                    id: _tabsOverview
                    checkable: true
                    icon.name: "tab-new"
                    text: control.count
                    flat: true
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
            spacing: 0
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            boundsBehavior: Flickable.StopAtBounds
            
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
                visible: !control.count
                emojiSize: Maui.Style.iconSizes.huge
                isMask: true
            }
            
            Rectangle
            {
                id: _overview
                visible: control.overviewMode && control.mobile
                
                anchors.fill: parent
                
                Kirigami.Theme.colorSet: Kirigami.Theme.Window
                Kirigami.Theme.inherit: false
                
                color: Kirigami.Theme.backgroundColor
                
                Maui.GridView
                {
                    id: _overviewGrid
                    
                    anchors.fill: parent
                    model: control.count
                    currentIndex: control.currentIndex
                    itemSize: width / 3
                    itemHeight:  (height / 3)
                    
                    onAreaClicked:
                    {
                        _tabsOverview.checked = false
                    }
                    
                    delegate: Item
                    {
                        height: _overviewGrid.cellHeight
                        width: _overviewGrid.cellWidth
                        
                        property bool isCurrentItem : GridView.isCurrentItem
                        
                        Maui.ItemDelegate
                        {
                            anchors.fill: parent
                            anchors.margins: Maui.Style.space.small

                            Maui.ContextualMenu
                            {
                                id: _overViewMenu

                                MenuItem
                                {
                                    text: i18n("Open")
                                    onTriggered:
                                    {
                                        _tabsOverview.checked = false
                                    }
                                }

                                MenuItem
                                {
                                    text: i18n("Close")
                                    onTriggered:
                                    {
                                        control.closeTabClicked(control.currentIndex)
                                    }
                                }
                            }
                            
                            onRightClicked:
                            {
                                control.currentIndex = index
                                _overViewMenu.open()
                            }

                            onClicked:
                            {
                                control.currentIndex = index
                                _tabsOverview.checked = false
                            }

                            onPressAndHold:
                            {
                                control.currentIndex = index
                                _overViewMenu.open()
                            }
                            
                            background: null
                            Rectangle
                            {
                                anchors.fill: parent
                                color: Kirigami.Theme.backgroundColor
                                radius: Maui.Style.radiusV
                                
                                ShaderEffectSource
                                {
                                    id: _effect
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    
                                    hideSource: visible
                                    live: true
                                    textureSize: Qt.size(width,height)
                                    sourceItem: control.contentModel.get(index)
                                    layer.enabled: true
                                    layer.effect: OpacityMask
                                    {
                                        maskSource: Item
                                        {
                                            width: control.width
                                            height: control.height
                                            Rectangle
                                            {
                                                anchors.fill: parent
                                                radius: Maui.Style.radiusV
                                            }
                                        }
                                    }
                                }
                                
                                Rectangle
                                {
                                    height: _overviewCardTitle.implicitHeight + Maui.Style.space.medium
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    color: Kirigami.Theme.backgroundColor
                                    clip: true
                                    
                                    Maui.Separator
                                    {
                                        edge: Qt.TopEdge
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                    }

                                    Label
                                    {
                                        id: _overviewCardTitle
                                        anchors.centerIn: parent
                                        width: parent.width - Maui.Style.space.medium
                                        elide: Text.ElideRight
                                        wrapMode: Text.WrapAnywhere
                                        horizontalAlignment: Qt.AlignHCenter
                                        verticalAlignment: Qt.AlignVCenter
                                        text: control.contentModel.get(index).title || index
                                    }
                                }
                                
                                Rectangle
                                {
                                    anchors.fill: parent
                                    border.color: isCurrentItem ? Kirigami.Theme.highlightColor : Qt.darker(Kirigami.Theme.backgroundColor, 2.2)
                                    radius: parent.radius
                                    
                                    border.width: isCurrentItem ? 2 : 1
                                    color: "transparent"
                                    opacity: 0.8
                                    
                                    Rectangle
                                    {
                                        anchors.fill: parent
                                        color: "transparent"
                                        anchors.margins: 1
                                        radius: parent.radius - 0.5
                                        border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
                                        opacity: 0.3
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
        control.removeItem(control.takeItem(index))
    }
    
    function addTab(component, properties)
    {
        const object = component.createObject(control.contentModel, properties);
        control.addItem(object)
        object.forceActiveFocus()
        return object
    }
}
