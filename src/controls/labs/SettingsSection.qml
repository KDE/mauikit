import QtQuick.Layouts 1.3

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
        property alias spacing: _mainData.spacing
        
        Layout.fillWidth: true
        implicitHeight: _layout.implicitHeight + (Maui.Style.space.big * 2)
        
        ColumnLayout
        {
            id: _layout
            anchors.fill: parent
            anchors.margins: Maui.Style.space.big
            
            spacing: Maui.Style.space.medium
            
            Maui.SectionDropDown
            {
                id: _template
                Layout.fillWidth: true
                label1.text: control.title
                label2.text: control.description
                checked: true
            }            
            
            ColumnLayout
            {
                id: _mainData
                Layout.fillWidth: true
               
                visible: _template.checked                           
            }
        }
}
