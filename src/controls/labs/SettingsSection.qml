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
        spacing: Maui.Style.space.big
        
        Layout.fillWidth: true
        // Layout.maximumWidth: 600
        // Layout.alignment: Qt.AlignCenter
        implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
        
        contentItem: ColumnLayout
        {
            id: _layout
            
            spacing: control.spacing
            
            Maui.SectionDropDown
            {
                id: _template
                Layout.fillWidth: true
                padding: 0
//                 leftPadding : 0
                label1.text: control.title
                label2.text: control.description
                template.iconSizeHint: Maui.Style.iconSizes.medium

                checked: true
            }            
            
            Item
            {
                Layout.fillWidth: true
                implicitHeight: _mainData.implicitHeight

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
