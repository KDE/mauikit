import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui
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
//     label1.font.pointSize: Maui.Style.fontSizes.big
    template.labelSizeHint: 32
    //template.alignment: Qt.AlignLeft
    
    maskRadius: radius

    template.iconComponent: Maui.GalleryRollTemplate
    {      
        radius: control.radius
        cache: control.cache
        images: control.images
        cb: control.cb
        fillMode: control.fillMode
        running: !control.hovered && !control.checked
        
        corners
        {
            topLeftRadius: control.radius
            topRightRadius: control.radius
            bottomLeftRadius: control.radius
            bottomRightRadius: control.radius
        }
    }
}
