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
    
    maskRadius: radius
    
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
    
    label1.font.bold: true
    label1.font.weight: Font.Bold
    label1.font.pointSize: Maui.Style.fontSizes.big
    
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
            columns: 3
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
                    Layout.maximumHeight: index === 0 ? control.height : control.height * 0.3
                    //                     Layout.minimumHeight: index === 0 ? control.height * 0.6 : control.height * 0.2
                    Layout.columnSpan: index === 0 ? 3 : 1
                    Layout.rowSpan: index === 0 ? 2 : 1
                    color: Qt.rgba(0,0,0,0.3)
                    
                    Image
                    {
                        anchors.fill: parent
                        sourceSize.width:  (control.imageWidth > -1 ? control.imageWidth : width)
                        sourceSize.height:  (control.imageHeight > -1 ? control.imageHeight : height)
                        
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
                
                Rectangle
                {
                    anchors.fill: parent
                    radius: control.maskRadius
                }
            }
        }
    }
    
    background: Kirigami.ShadowedRectangle
    {
        readonly property color m_color : Qt.tint(Qt.lighter(control.Kirigami.Theme.textColor), Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
        
        color: control.isCurrentItem || control.hovered || control.containsPress ? Qt.rgba(control.Kirigami.Theme.highlightColor.r, control.Kirigami.Theme.highlightColor.g, control.Kirigami.Theme.highlightColor.b, 0.2) : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.5)       
        
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
    }
    
}
