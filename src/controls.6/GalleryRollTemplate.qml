import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import QtQuick.Effects

/**
 * @inherit ShadowedRectangle
 * @brief A template control to display images in a carousel form. This element is use with the GalleryRollItem to display the images, so consider using that control instead of this one.
 * 
 * This control inherits all properties from the MauiKit ShadowedRectangle control. Thus, the corners radius can be modified individually, and a drop shadow can be added, using the `corners` and `shadow` properties respectively.
 * 
 * The transition of the images can be set as vertical or horizontal using the `orientation` property, and the transition time is picked randomly.
 * @see orientation 
 * 
 * @note If not images are set, then the area is filled with a solid color block. This color can be changed using the `color` property. 
 */
Maui.ShadowedRectangle
{
    id: control
    
    color: "#333"
    
    /**
     * @brief Whether the images in the carousel can be flicked with touch gestures.
     * @property bool GalleryRollTemplate::interactive
     */
    property alias interactive : _featuredRoll.interactive
    
    /**
     * @brief The orientation of the transition of the images.
     * By default this is set to `ListView.Horizontal`.
     * The possible values are:
     * - ListView.Horizontal
     * - ListView.Vertical
     * @property enum GalleryRollTemplate::orientation.
     */
    property alias orientation : _featuredRoll.orientation
    
    /**
     * @brief Whether the images should be saved in cache memory to save loading time.
     * By default this is set to `true`.
     */
    property bool cache : !Maui.Handy.isMobile
    
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
    
    /**
     * @brief A list of images to be used. This will be use as the model.
     */
    property var images : []
    
    /**
     * @brief The border radius of the images.
     * By default this is set to `0`.
     */
    radius : 0
    
    /**
     * @brief The fill mode of the images. To see possible values refer to the QQC2 Image documentation form Qt.
     * By default this is set to `Image.PreserveAspectCrop`.
     */
    property int fillMode: Image.PreserveAspectCrop
    
    /**
     * @brief Checks and sets whether the transition animation is running or not.
     * @property bool GalleryRollTemplate::running
     */
    property alias running: _featuredTimer.running
    
    /**
     * @brief Sets the painted width size of the image. 
     * @note If the image has a big resolution it will take longer to load, so make it faster set this property to a lower value.
     * 
     * By default this is set to `-1`, which means that the image will be painted using the full image resolution.
     * This is the same as setting the QQC2 Image `sourceSize.width` property.
     */
    property int imageWidth : -1
    
    /**
     * @brief Sets the painted height size of the image. 
     * @note If the image has a big resolution it will take longer to load, so make it faster set this property to a lower value.
     * 
     * By default this is set to `-1`, which means that the image will be painted using the full image resolution.
     * This is the same as setting the QQC2 Image `sourceSize.height` property.
     */
    property int imageHeight : -1
    
    corners
    {
        topLeftRadius: control.radius
        topRightRadius: control.radius
        bottomLeftRadius: control.radius
        bottomRightRadius: control.radius
    }
    
    ListView
    {
        id: _featuredRoll
        anchors.fill: parent
        
        interactive: false
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        clip: true
        
        boundsBehavior: Flickable.StopAtBounds
        boundsMovement: Flickable.StopAtBounds
        
        model: control.images
        
        Component.onCompleted: _featuredTimer.start()
        
        Timer
        {
            id: _featuredTimer
            interval: _featuredRoll.randomInteger(6000, 8000)
            repeat: true
            onTriggered: _featuredRoll.cycleSlideForward()
        }
        
        function cycleSlideForward()
        {
            if(_featuredRoll.dragging)
            {
                return
            }
            
            if (_featuredRoll.currentIndex === _featuredRoll.count - 1)
            {
                _featuredRoll.currentIndex = 0
            } else
            {
                _featuredRoll.incrementCurrentIndex()
            }
            _featuredTimer.restart()
        }
        
        function cycleSlideBackward()
        {
            if(_featuredRoll.dragging)
            {
                return
            }
            
            if (_featuredRoll.currentIndex === 0)
            {
                _featuredRoll.currentIndex = _featuredRoll.count - 1;
            } else
            {
                _featuredRoll.decrementCurrentIndex();
            }
            
            _featuredTimer.restart()
        }        
        
        function randomInteger(min, max)
        {
            return Math.floor(Math.random() * (max - min + 1)) + min;
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
                smooth: !Maui.Handy.isMobile
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
        
        layer.enabled: control.radius > 0
        layer.effect: MultiEffect
        {
            maskEnabled: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
            maskSpreadAtMax: 0.0
            maskThresholdMax: 1.0
            maskSource: ShaderEffectSource
            {
                sourceItem: Maui.ShadowedRectangle
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
    }
}
