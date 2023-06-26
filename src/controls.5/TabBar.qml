import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T
import QtQuick.Window 2.15

import org.mauikit.controls 1.3 as Maui

import "private" as Private

/**
 * TabBar
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.TabBar
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Header
    Maui.Theme.inherit: false
    
    property alias content : _layout.data
    property alias leftContent: _leftLayout.data
    property alias rightContent: _layout.data
    
    property alias interactive: _content.interactive
    /**
     * showNewTabButton : bool
     */
    property bool showNewTabButton : true
    property bool showTabs : true
    
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
        
        padding: Maui.Style.defaultPadding
        spacing: Maui.Style.space.small   
        
        font: Maui.Style.defaultFont
                
    /**
     * newTabClicked :
     */
    signal newTabClicked()
    signal newTabFocused(int index)
    
    background: Rectangle
    {
        color: Maui.Theme.backgroundColor
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_content.atXEnd && !parent.fits 
            visible: active
            
            anchors
            {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Private.EdgeShadow
            {                    
                edge: Qt.RightEdge                    
            }
        }
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_content.atXBeginning && !parent.fits 
            visible: active
            anchors
            {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Private.EdgeShadow
            {                
                edge: Qt.LeftEdge            
            }
        }
    }
    
    contentItem: Item
    {        
        implicitHeight: _layout.implicitHeight
        readonly property bool fits : _content.contentWidth <= width
        
        Item
        {
            id: _dragHandler
            anchors.fill: parent

            DragHandler
            {
                // enabled: !control.interactive
                acceptedDevices: PointerDevice.GenericPointer
                grabPermissions:  PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
                onActiveChanged: if (active) { control.Window.window.startSystemMove(); }
            }
        }
        
        RowLayout
        {
            id: _layout
            width: parent.width
            spacing: control.spacing 
            
            Row
            {
                id: _leftLayout
                spacing: control.spacing
            }
            
            ScrollView
            {
                Layout.fillWidth: true

                orientation : Qt.Horizontal

               ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                
                contentHeight: availableHeight
                implicitHeight: _content.currentItem ? _content.currentItem.height : 0
                
                ListView
                {
                    id: _content
                    opacity: control.showTabs ? 1 : 0 
                    visible: opacity > 0
                    
                    clip: true
                    
                    orientation: ListView.Horizontal                    
                  
                    spacing: control.spacing
                    
                    model: control.contentModel
                    currentIndex: control.currentIndex
                    
                    interactive: Maui.Handy.isMobile
                    snapMode: ListView.SnapOneItem  
                    
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0
                    highlightResizeDuration : 0
                    
                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement: Flickable.StopAtBounds
                    
                    keyNavigationEnabled : true
                    keyNavigationWraps : true
                    
                    onMovementEnded:
                    {
                        const newIndex = indexAt(contentX, contentY)
                        control.newTabFocused(newIndex)
                    }
                    
                    Behavior on opacity
                    {
                        NumberAnimation
                        {
                            duration: Maui.Style.units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }                
            }
            
            Loader
            {
                active: control.showNewTabButton
                visible: active
                asynchronous: true                
                
                sourceComponent: ToolButton
                {
                    icon.name: "list-add"
                    onClicked: control.newTabClicked()              
                    flat: true
                }
            }
        }
    }
    
    function positionViewAtIndex(index : int)
    {
        _content.positionViewAtIndex(index, ListView.SnapPosition)
    }
}
