import QtQuick 2.15
import QtQml 2.14

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

Maui.TabButton
{
    id: control
    
    autoExclusive: true
    
    readonly property int mindex : control.TabBar.index
    property Item tabView : control.parent
    
   readonly property var tabInfo: control.tabView.contentModel.get(mindex).Maui.TabViewInfo
    
    width: control.tabView.mobile ? ListView.view.width : Math.max(160, implicitWidth)
    
    checked: control.mindex === control.tabView.currentIndex
    text: tabInfo.tabTitle
    
    icon.name: tabInfo.tabIcon
    
    property color color : tabInfo.tabColor ? tabInfo.tabColor : "transparent"
    
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: control.hovered && !Maui.Handy.isMobile && ToolTip.text.length
    ToolTip.text: tabInfo.tabToolTipText    
    
    Drag.active: dragArea.active
    Drag.source: control
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    Drag.dragType: Drag.Automatic
    Drag.proposedAction: Qt.IgnoreAction
    
    Rectangle
    {
        parent: control.background
        color: control.color
        height: 2
        width: parent.width*0.9
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    DragHandler
    {
        id: dragArea
        enabled: !control.mobile && control.tabView.count > 1
        acceptedDevices: PointerDevice.Mouse
        target: null
        xAxis.enabled: true
        yAxis.enabled: false
        cursorShape: Qt.OpenHandCursor
        
        onActiveChanged:
        {
            if (active) 
            {
                control.grabToImage(function(result)
                {
                    control.Drag.imageSource = result.url;
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
                control.tabView.setCurrentIndex(mindex)
            }
        }
    }
    
    DropArea
    {
        id: _dropArea
        anchors.fill: parent
        onDropped:
        {                             
            const from = drop.source.mindex
            const to = control.mindex
            
            if(to === from)
            {
                return
            }
            
            console.log("Move ", drop.source.mindex, control.mindex)            
            control.tabView.moveTab(from , to)
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
