
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

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
    
    opacity: enabled ? 1 : 0.5
        
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
        implicitHeight: implicitContentHeight + topPadding + bottomPadding

    hoverEnabled: !Maui.Handy.isMobile
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small   
    
    font: Maui.Style.defaultFont
    
    icon.width: Maui.Style.iconSize
    icon.height: Maui.Style.iconSize
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    property alias content: _content.data
    property alias leftContent: _leftContent.data
    property alias rightContent: _rightContent.data
    
    property bool closeButtonVisible: true
    
    /**
     * closeClicked :
     */
    signal closeClicked()
    signal rightClicked(var mouse)
    
    background: Rectangle
    {
        //opacity: control.hovered && !control.checked ? 1 : 1
        color: control.checked ? Maui.Theme.backgroundColor : (control.hovered || control.pressed ? Maui.Theme.hoverColor : "transparent")
        radius: Maui.Style.radiusV
        
        //          Behavior on color
        //         {
        //             Maui.ColorTransition{}
        //         }
    }
    
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
                display: ToolButton.TextBesideIcon
                font: control.font
                /*horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                wrapMode: Text.NoWrap
                elide: Text.ElideMiddle   */             
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

