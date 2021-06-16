import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import QtGraphicalEffects 1.0

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Maui.GridBrowserDelegate
{
    id: control
    
    /**
     * images : function
     */
    property var images : []
    
    fillMode: Image.PreserveAspectCrop
    /**
     * randomHexColor : function
     */
    function randomHexColor()
    {
        var color = '#', i = 5;
        do{ color += "0123456789abcdef".substr(Math.random() * 16,1); }while(i--);
        return color;
    }
    
    /**
     * cb : function
     */
    property var cb 
    
    //background: null
    
    
    template.iconComponent: Item
    {
        id: _collageLayout
        
        Rectangle
        {
            anchors.fill: parent
            radius: 8
            color: randomHexColor()
            visible: _repeater.count === 0
        }
        
        GridLayout
        {
            anchors.fill: parent
            columns: 2
            rows: 2
            columnSpacing: 2
            rowSpacing: 2
            
            Repeater
            {
                id: _repeater
                
                model: control.images
                
                delegate: Rectangle
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: Qt.rgba(0,0,0,0.3)
                    
                    Image
                    {
                        anchors.fill: parent
                        sourceSize.width: width
                        sourceSize.height: height
                        asynchronous: true
                        smooth: true
                        source: control.cb ? control.cb(modelData) : modelData
                        fillMode: control.fillMode
                    }
                }
            }
        }        
        
        layer.enabled: control.maskRadius
        layer.effect: OpacityMask
        {
            maskSource: Item
            {
                width: _collageLayout.width
                height: _collageLayout.height
                
                Kirigami.ShadowedRectangle
                {
                    anchors.fill: parent
                    corners
                    {
                        topLeftRadius: control.maskRadius
                        topRightRadius: control.maskRadius
                        bottomLeftRadius: control.labelsVisible ? 0 : control.maskRadius
                        bottomRightRadius:  control.labelsVisible ? 0 : control.maskRadius
                    }
                }
            }
        }
    }
    
}
