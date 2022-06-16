import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui

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
//     label1.font.pointSize: Maui.Style.fontSizes.big
    template.labelSizeHint: 40
    template.alignment: Qt.AlignLeft
    
    template.iconComponent: Item
    {
        id: _collageLayout
       
        function spanColumn(index, count)
        {
            if(index === 0)
            {
                return 3;
            }
            
            if(count === 2 || count === 3)
            {
                return 3;
            }
            
            return 1;
        }

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
                    id: _repeater
                    model: control.images
                    
                    delegate: Rectangle
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumHeight: index === 0 ? control.height : control.height * 0.3
                        //                     Layout.minimumHeight: index === 0 ? control.height * 0.6 : control.height * 0.2
                        Layout.columnSpan: spanColumn(index, _repeater.count)
                        Layout.rowSpan: 1
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
                    maskSource: Rectangle
                    {
                        width: _collageLayout.width
                        height: _collageLayout.height
                        radius: control.maskRadius
                    }                    
                }
            }
        }   
    }    
}
