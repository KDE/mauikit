import QtQuick 2.15
import QtQml 2.14

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10
import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

Maui.TabButton
{
    id: control
    
    readonly property int mindex : control.TabBar.index
    property Item tabView : control.parent
    property Maui.TabBar tabBar : control.TabBar.tabBar
    
    implicitHeight: ListView.view.height
    
    width: control.tabView.mobile ? ListView.view.width : Math.max(200, Math.min(600, implicitWidth))
    
    checked: control.mindex === control.tabView.currentIndex
    text: control.tabView.contentModel.get(mindex).Maui.TabViewInfo.tabTitle
    
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: control.hovered && !Maui.Handy.isMobile && ToolTip.text.length
    ToolTip.text: control.tabView.contentModel.get(mindex).Maui.TabViewInfo.tabToolTipText    
    
    Drag.active: dragArea.active
    Drag.source: control
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
        enabled: !control.mobile && control.tabBar.count > 1
        acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus | PointerDevice.GenericPointer
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
        property int dropSide : -1
        anchors.fill: parent
        onDropped:
        {                             
            const from = drop.source.mindex
            const to = control.mindex
            
            if(to === from)
            {
                return
            }
            
            console.log("Move ", drop.source.mindex,
                        control.mindex)
            
            dropSide = from > to ? 1 : 0
            
            control.tabView.moveItem(from , to)
            control.tabBar.moveItem(from , to)
            
            control.tabBar.setCurrentIndex(to)
            control.tabView.setCurrentIndex(to)                                    
            
            control.tabView.currentItemChanged()
            control.tabView.currentItem.forceActiveFocus()
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