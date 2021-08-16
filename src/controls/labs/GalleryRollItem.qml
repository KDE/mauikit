import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui
import QtGraphicalEffects 1.0

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Maui.GridBrowserDelegate
{
    id: control

    /**
     * cached
     */
    property bool cache : true


    /**
     * images :
     */
    property var images : []
   
    /**
     * cb : function
     */
    property var cb
    
    property int orientation : Qt.Horizontal
    
    
    label1.font.bold: true
    label1.font.weight: Font.Bold
    label1.font.pointSize: Maui.Style.fontSizes.big
    
    maskRadius: radius

   template.iconComponent:  Kirigami.ShadowedRectangle
    {
                id: _cover

            color: "#333"
            
        corners
        {
            topLeftRadius: control.radius
            topRightRadius: control.radius
            bottomLeftRadius: control.radius
            bottomRightRadius: control.radius
        }
        
        shadow.xOffset: 0
        shadow.yOffset: 0
        shadow.color: Qt.rgba(0, 0, 0, 0.3)
        shadow.size: 10
    
        
        function randomInteger(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }
          Component.onCompleted: _featuredTimer.start()
            
            HoverHandler
            {
                id: _hoverHandler
            }

            Timer
            {
                id: _featuredTimer
                interval: randomInteger(6000, 8000)
                repeat: true
                onTriggered: _featuredRoll.cycleSlideForward()
            }
          
            ListView
            {
                id: _featuredRoll
                anchors.fill: parent
                interactive: false
                orientation: control.orientation
                snapMode: ListView.SnapOneItem
                clip: true
                
                model: control.images

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
                    height: ListView.view.height * (_hoverHandler.hovered ? 1.2 : 1)

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
                            duration: Kirigami.Units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                
                
            layer.enabled: control.maskRadius
            layer.effect: OpacityMask
            {
                maskSource: Item
                {
                    width: _cover.width
                    height: _cover.height
                    
                    Rectangle
                    {
                        anchors.fill: parent
                        radius: control.maskRadius
                    }
                }
            }
            }
            
        
    }
    
    background: Rectangle
    {
        readonly property color m_color : Qt.tint(Qt.lighter(control.Kirigami.Theme.textColor), Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
        
        color: control.isCurrentItem || control.hovered || control.containsPress ? Qt.rgba(control.Kirigami.Theme.highlightColor.r, control.Kirigami.Theme.highlightColor.g, control.Kirigami.Theme.highlightColor.b, 0.2) : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.5)       
        
        radius: control.radius
    }
}
