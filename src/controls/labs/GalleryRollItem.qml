import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.9 as Kirigami
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
     * margins :
     */
    property int margins : isWide ? Maui.Style.space.medium : Maui.Style.space.tiny

    /**
     * cb : function
     */
    property var cb




   template.iconComponent:  Item
    {
        id: _cover
        
        function randomInteger(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }
        
        Rectangle
        {
            anchors.fill: parent
            color: Kirigami.Theme.backgroundColor
            radius: Maui.Style.radiusV

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
                orientation: Qt.Horizontal
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
                        sourceSize.width: control.width * 1.2
                        sourceSize.height: control.height * 1.2
                        asynchronous: true
                        smooth: true
                        cache: control.cache
                        source: control.cb ? control.cb(modelData) : modelData
                        fillMode: Image.PreserveAspectCrop
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
            }

            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Item
                {
                    width: _cover.width
                    height: _cover.height

                    Rectangle
                    {
                        anchors.fill: parent
                        radius: Maui.Style.radiusV
                    }
                }
            }
        }

        //Rectangle
        //{
            //Kirigami.Theme.inherit: false
            //anchors.fill: parent
            //color: "transparent"
            //radius: Maui.Style.radiusV
            //border.color: control.isCurrentItem || control.hovered ? Kirigami.Theme.highlightColor : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.2)

            //Rectangle
            //{
                //anchors.fill: parent
                //color: "transparent"
                //radius: parent.radius - 0.5
                //border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
                //opacity: 0.2
                //anchors.margins: 1
            //}
        //}
    }
}
