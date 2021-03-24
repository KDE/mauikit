
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.3 as Maui

/**
 * TabButton
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
TabButton
{
    id: control
    implicitWidth: 150
    
        /**
         * template : ListItemTemplate
         */
        property alias template: _template
        
        property alias closeButtonVisible: _closeButton.visible
        
        /**
         * closeClicked :
         */
        signal closeClicked()
        
        Kirigami.Separator
        {
            color: Kirigami.Theme.highlightColor
            height: 2
            visible: checked
            anchors
            {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
        }
        
        background: null
        
        contentItem: RowLayout
        {
             Maui.CloseButton
            {
                id: _closeButton
                
                opacity: Kirigami.Settings.isMobile ? 1 : (control.hovered || control.checked ? 1 : 0)     
                
                implicitWidth: height
                Layout.fillHeight: true  
                
                onClicked: control.closeClicked()
                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                
            }
            Maui.ListItemTemplate
            {
                id: _template
               Layout.fillWidth: true
               Layout.fillHeight: true
                label1.text: control.text
                label1.horizontalAlignment: Qt.AlignHCenter
                label1.color: control.checked ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                label1.wrapMode: Text.NoWrap
                label1.elide: Text.ElideMiddle
                leftMargin: Maui.Style.space.small
                rightMargin: leftMargin       
            }
            
           
        }
}

