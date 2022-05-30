import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtGraphicalEffects 1.0

Kirigami.ShadowedRectangle
{
    id: control
    color: "#333"
    
    property int orientation : Qt.Horizontal
    
    /**
     * cached
     */
    property bool cache : true
    
    
    /**
     * cb : function
     */
    property var cb
    
    /**
     * images :
     */
    property var images : []
    property int radius : 0
    
    property int fillMode: Image.PreserveAspectCrop
    property alias running: _featuredTimer.running 
    
    corners
    {
        topLeftRadius: control.radius
        topRightRadius: control.radius
        bottomLeftRadius: control.radius
        bottomRightRadius: control.radius
    }
    
//    shadow.xOffset: 0
//    shadow.yOffset: 0
//    shadow.color: Qt.rgba(0, 0, 0, 0.3)
//    shadow.size: 10


ListView
        {
            id: _featuredRoll
            anchors.fill: parent
            
            interactive: false
            orientation: control.orientation
            snapMode: ListView.SnapOneItem
            clip: true
            
            model: control.images
            
            Component.onCompleted: _featuredTimer.start()      
            
            Timer
            {
                id: _featuredTimer
                interval: randomInteger(6000, 8000)
                repeat: true
                onTriggered: _featuredRoll.cycleSlideForward()
            }
          
            function cycleSlideForward()
            {
                _featuredTimer.restart()
                
                if (_featuredRoll.currentIndex === _featuredRoll.count - 1)
                {
                    _featuredRoll.currentIndex = 0
                } else
                {
                    _featuredRoll.incrementCurrentIndex()
                }
            }
            
            function cycleSlideBackward()
            {
                _featuredTimer.restart()
                
                if (_featuredRoll.currentIndex === 0)
                {
                    _featuredRoll.currentIndex = _featuredRoll.count - 1;
                } else
                {
                    _featuredRoll.decrementCurrentIndex();
                }
            }
            
            delegate: Item
            {
                width: ListView.view.width
                height: ListView.view.height
                
                Image
                {
                    anchors.fill: parent
                    sourceSize.width: (control.imageWidth > -1 ? control.imageWidth : control.width) * 1.5
                    sourceSize.height:  (control.imageHeight > -1 ? control.imageHeight : control.height)  * 1.5
                    asynchronous: true
                    smooth: true
                    cache: control.cache
                    source: control.cb ? control.cb(modelData) : modelData
                    fillMode: control.fillMode
                }
                
                Behavior on height
                {
                    NumberAnimation
                    {
                        duration: Maui.Style.units.shortDuration
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            
            layer.enabled: control.radius
            layer.effect: OpacityMask
            {
                maskSource: Kirigami.ShadowedRectangle
                {
                    width: control.width
                    height: control.height
                    
                    corners
                    {
                        topLeftRadius: control.corners.topLeftRadius
                        topRightRadius: control.corners.topRightRadius
                        bottomLeftRadius: control.corners.bottomLeftRadius
                        bottomRightRadius: control.corners.bottomRightRadius
                    }
                }               
            }
        }
    
    
    function randomInteger(min, max)
    {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
}
