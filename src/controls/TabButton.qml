
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

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
T.TabButton
{
    id: control
    implicitWidth: 200    
    
    property alias content: _content.data
    property alias leftContent: _leftContent.data
    
    property bool closeButtonVisible: true
    property bool centerLabel : true
    
    /**
     * closeClicked :
     */
    signal closeClicked()
    signal rightClicked(var mouse)
    
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    
    background: Rectangle
    {
        visible: control.checked || control.down || control.hovered
        opacity: control.hovered && !control.checked ? 0.2 : 1
        color: control.hovered && !control.checked ? Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.4) : Qt.lighter(Kirigami.Theme.backgroundColor)
        radius: Maui.Style.radiusV
        
         Behavior on color
        {
            Maui.ColorTransition{}
        }
    }
    
    contentItem:  MouseArea
    {
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        preventStealing: false
        
        onClicked:
        {
            if(mouse.button === Qt.RightButton)
            {
                control.rightClicked(mouse)
            }          
            
            mouse.accepted = false
        }
        
        RowLayout
        {
            id: _content
            anchors.fill: parent
            
            Row
            {
                id: _leftContent
                Layout.fillHeight: true
                
            }
            
            Item
            {
                Layout.fillHeight: true
                implicitWidth: height
                visible: control.closeButtonVisible && control.centerLabel
            }
            
            Loader
            {
                asynchronous: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                sourceComponent: Label
                {         
                    text: control.text
                    
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: Kirigami.Theme.textColor
                    wrapMode: Text.NoWrap
                    elide: Text.ElideMiddle
                }  
            }            
          
            Loader
            {
                asynchronous: true
                active: control.closeButtonVisible
                
                Layout.preferredWidth: height
                Layout.fillHeight: true
                
                sourceComponent: Maui.CloseButton
                {
                    opacity: Kirigami.Settings.isMobile ? 1 : (control.hovered || control.checked ? 1 : 0)
                    
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
            }
        }        
    }    
    
}

