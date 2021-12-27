import QtQuick.Layouts 1.3
import QtQuick 2.14

import org.mauikit.controls 1.3 as Maui

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Maui.AlternateListItem
{
    id: control
    
    /**
     * 
     */
    default property alias content : _mainData.data
        
        /**
         * 
         */
        property int index : -1
        
        /**
         * 
         */
        property string title
        
        /**
         * 
         */
        property string description
        
        /**
         * 
         */
        property alias template: _template
        
        /**
         * 
         */
        spacing: Maui.Style.space.medium
        
        Layout.fillWidth: true
        implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
        
        contentItem: ColumnLayout
        {
            id: _layout
            
            spacing: control.spacing
            
            Maui.SectionDropDown
            {
                id: _template
                Layout.fillWidth: true
                label1.text: control.title
                label2.text: control.description
                checked: true
            }            
            
            Rectangle
            {
                Layout.fillWidth: true
                implicitHeight: _mainData.implicitHeight
                color: "pink"
                border.color: "red"
                ColumnLayout
                {
                    id: _mainData
                    anchors.fill: parent
                    spacing: control.spacing
                    
                    visible: _template.checked                           
                }
            }
        }
}
