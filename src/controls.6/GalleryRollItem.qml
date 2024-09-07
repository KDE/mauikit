import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit GridBrowserDelegate
 * @since org.mauikit.controls
 *  
 *  @brief A custom item to be used as a delegate in the browsing views or as a standalone card. This element presents a group of images in a carousel form.
 *  
 *  This control inherits all properties from the MauiKit GridBrowserDelegate control. As such, this can have two labels, for a title and a message.
 *  @see GridBrowserDelegate#label1
 *  @see GridBrowserDelegate#label2
 *  
 *  The header part of this control, the actual carousel of images, is handled by a GalleryRollTemplate.
 *  @see GalleryRollTemplate
 *  
 *    @image html Delegates/galleryrollitem.png 
 * 
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
 *            Maui.GalleryRollItem
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
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/GalleryRollItem.qml">You can find a more complete example at this link.</a>
 * 
 */
Maui.GridBrowserDelegate
{
    id: control
    
    /**
     * @brief Whether the images should be saved in the cache, to reduce loading times.
     * By default this is set to `true`.
     */
    property bool cache : true
    
    
    /**
     * @brief A list of images to be used. This will be use as the model.
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
    
    /**
     * @brief The orientation of the transition of the images. By default this is set to horizontal using `ListView.Horizontal`.
     * Possible values are:
     * - ListView.Horizontal
     * - ListView.Vertical
     */
    property int orientation : Qt.Horizontal
    
    label1.font.weight: Font.DemiBold
    label1.font.pointSize: Maui.Style.fontSizes.big
    template.labelSizeHint: 32
    template.alignment: Qt.AlignLeft
    
    maskRadius: radius
    
    template.iconComponent: Maui.GalleryRollTemplate
    {      
        radius: control.radius
        cache: control.cache
        images: control.images
        cb: control.cb
        fillMode: control.fillMode
        running: !control.hovered && !control.checked
        imageWidth: control.imageWidth
        imageHeight: control.imageHeight
        
        corners
        {
            topLeftRadius: control.radius
            topRightRadius: control.radius
            bottomLeftRadius: control.radius
            bottomRightRadius: control.radius
        }
    }
}
