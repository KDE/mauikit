
import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

import org.mauikit.controls as Maui

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
QQC.TabButton
{
    id: control

    property alias content: _content.data
    property alias leftContent: _leftContent.data
    property alias rightContent: _rightContent.data
    
    property bool closeButtonVisible: true
    
    /**
     * closeClicked :
     */
    signal closeClicked()
    signal rightClicked(var mouse)

    
    contentItem: MouseArea
    {
        implicitWidth: _content.implicitWidth
        implicitHeight: _content.implicitHeight
        
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
            spacing: control.spacing
            
            Row
            {
                id: _leftContent
            }
            
            Maui.IconLabel
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                opacity: control.checked || control.hovered ? 1 : 0.7
                
                text: control.text
                icon: control.icon
                color: Maui.Theme.textColor
                alignment: Qt.AlignHCenter
                display: QQC.ToolButton.TextBesideIcon
                font: control.font
            }
            
            Row
            {
                id: _rightContent
            }
            
            Loader
            {
                asynchronous: true
                active: control.closeButtonVisible
                
                Layout.alignment: Qt.AlignCenter
                
                sourceComponent: Maui.CloseButton
                {
                    opacity: Maui.Handy.isMobile ? 1 : (control.hovered || control.checked ? 1 : 0)
                    padding: 0
                    
                    implicitHeight: 16
                    implicitWidth: 16
                    
                    icon.width: 16
                    icon.height: 16
                    
                    onClicked: control.closeClicked()
                    
                    Behavior on opacity
                    {
                        NumberAnimation
                        {
                            duration: Maui.Style.units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}

