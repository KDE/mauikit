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
    label1.font.pointSize: Maui.Style.fontSizes.big
    
    maskRadius: radius

    template.iconComponent:  Maui.GalleryRollTemplate
    {
        id: _cover
        radius: control.radius
        cache: control.cache
        images: control.images
        cb: control.cb
        fillMode: control.fillMode
        
        corners
        {
            topLeftRadius: control.radius
            topRightRadius: control.radius
            bottomLeftRadius: 0
            bottomRightRadius: 0
        }
    }
    
    background: Rectangle
    {
        readonly property color m_color : Qt.tint(Qt.lighter(control.Kirigami.Theme.textColor), Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.9))
        
        color: control.isCurrentItem || control.hovered || control.containsPress ? Qt.rgba(control.Kirigami.Theme.highlightColor.r, control.Kirigami.Theme.highlightColor.g, control.Kirigami.Theme.highlightColor.b, 0.2) : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.5)
        
        radius: control.radius
    }
}
