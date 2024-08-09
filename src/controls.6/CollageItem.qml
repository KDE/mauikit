import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Effects

import org.mauikit.controls as Maui

/**
 * @inherit GridBrowserDelegate
 *    @since org.mauikit.controls 1.0
 *    @brief A custom item to be used as a delegate in the browsing views or as a standalone card. This element presents a group of images in a vignette-form.
 * 
 *    This control inherits all properties from the MauiKit GridBrowserDelegate control.
 * 
 *    @image html Delegates/collageitem.png "As delegate with a vary number of images"
 *    @code
 *    Maui.GridBrowser
 *    {
 *        anchors.fill: parent
 *        model: 30
 * 
 *        itemSize: 200
 * 
 *        delegate: Item
 *        {
 *            width: GridView.view.cellWidth
 *            height: GridView.view.cellHeight
 * 
 *            Maui.CollageItem
 *            {
 *                anchors.fill: parent
 *                anchors.margins: Maui.Style.space.small
 * 
 *                label1.text: "Demo"
 *                label2.text: index
 *                images: index %2 === 0 ? ['/home/camiloh/Downloads/street-1234360.jpg', '/home/camiloh/Downloads/flat-coated-retriever-1339154.jpg', '/home/camiloh/Downloads/5911329.jpeg'] : ['/home/camiloh/Downloads/street-1234360.jpg', '/home/camiloh/Downloads/flat-coated-retriever-1339154.jpg', '/home/camiloh/Downloads/5911329.jpeg', '/home/camiloh/Pictures/LastLights_by_Mushcube/LastLightsScreenPreview.png']
 *            }
 *        }
 *    }
 *    @endcode
 * 
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/CollageItem.qml">You can find a more complete example at this link.</a>
 * 
 */
Maui.GridBrowserDelegate
{
    id: control
    
    maskRadius: radius
    
    fillMode: Image.PreserveAspectCrop
    
    /**
     * @brief A list of images to be used. The maximum value that should be displayed is 4.
     */
    property var images : []
    
    /**
     * @brief A callback function to manage what image is positioned. This callback function is called for each image source set in the model `images`, so the final source can be modified. This function should return a - new or modified - image source URL.   
     *
     * As an example, if the `images` model looks like: `["page1", "page2", "page3"]` - which are not file URLs, this callback function can be use to map each individual source to an actual file URL. 
     * @code
     * images: ["page1", "page2", "page3"]
     * cb : (source) => 
     * {
     *   return mapSourceToImageFile(source) //here the "page1" could be mapped to "file:///some/path/to/image1.jpg" and return this new source to be use.
     * }    
     * @endcode
     */
    property var cb       
    
    label1.font.weight: Font.DemiBold
    label1.font.pointSize: Maui.Style.fontSizes.big
    
    template.labelSizeHint: 32
    template.alignment: Qt.AlignLeft    
    
    template.iconComponent: Item
    {
        id: _collageLayout
        
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
                        Layout.columnSpan: spanColumn(index, _repeater.count)
                        Layout.rowSpan: 1
                        color: Qt.rgba(0,0,0,0.3)
                        
                        Image
                        {
                            anchors.fill: parent
                            sourceSize.width: control.imageWidth >= 0 ? control.imageWidth : width  
                            sourceSize.height: control.imageHeight >= 0 ? control.imageHeight : height
                            cache: !Maui.Handy.isMobile
                            smooth: !Maui.Handy.isMobile
                            asynchronous: true
                            source: control.cb ? control.cb(modelData) : modelData
                            fillMode: control.fillMode
                        }
                    }
                }
                
                layer.enabled: control.maskRadius > 0
                layer.effect: MultiEffect
                {
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                    maskSpreadAtMax: 0.0
                    maskThresholdMax: 1.0
                    maskSource: ShaderEffectSource
                    {
                        sourceItem: Rectangle
                        {
                            x: _collageLayout.x
                            y: _collageLayout.y
                            width: _collageLayout.width
                            height: _collageLayout.height
                            radius: control.maskRadius
                        }
                    }
                }
            }
        }  
        
        function randomHexColor()
        {
            var color = '#', i = 5;
            do{ color += "0123456789abcdef".substr(Math.random() * 16,1); }while(i--);
            return color;
        }
        
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
    }    
}
