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
    
    template.iconComponent: Kirigami.ShadowedRectangle
    {
        id: _collageLayout
        
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
        
        
        Loader
        {
            asynchronous: true
            anchors.fill: parent
            
            sourceComponent: GridLayout
            {
                columns: 3
                rows: 2
                columnSpacing: 2
                rowSpacing: 2
                
                Repeater
                {                
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
                
                layer.enabled: control.maskRadius
                layer.effect: OpacityMask
                {
                    maskSource: Item
                    {
                        width: _collageLayout.width
                        height: _collageLayout.height
                        
                        Kirigami.ShadowedRectangle
                        {
                            corners
                            {
                                topLeftRadius: control.radius
                                topRightRadius: control.radius
                                bottomLeftRadius: 0
                                bottomRightRadius: 0
                            }
                            anchors.fill: parent
                            radius: control.maskRadius
                        }
                    }
                }
            }
        }   
    }
    
    background: Rectangle
    {
        readonly property color m_color : Qt.tint(Qt.lighter(control.Kirigami.Theme.textColor), Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
        
        color: control.hovered ? control.Kirigami.Theme.hoverColor :( control.isCurrentItem ||  control.containsPress ? control.Kirigami.Theme.highlightColor : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.4))
        
        radius: control.radius
    }    
}
