import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.9 as Kirigami
import org.mauikit.controls 1.2 as Maui

import "private" as Private

/**
 * TabBar
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
TabBar
{
    id: control
    
    implicitWidth: _content.width
    implicitHeight: Maui.Style.rowHeight + Maui.Style.space.tiny
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false
    
    /**
     * content : RowLayout.data
     */
    default property alias content : _content.data
        
    /**
     * showNewTabButton : bool
     */
    property bool showNewTabButton : true
    
    /**
     * newTabClicked :
     */
    signal newTabClicked()
    
    background: Rectangle
    {
        color: Kirigami.Theme.backgroundColor
        
        Maui.Separator
        {
            color: parent.color
            edge: control.position === TabBar.Footer ?  Qt.TopEdge : Qt.BottomEdge
            
            anchors
            {
                left: parent.left
                right: parent.right
                top: control.position === TabBar.Footer ? parent.top : undefined
                bottom: control.position == TabBar.Header ? parent.bottom : undefined
            }
        }
    }
    
    contentItem: Item
    {        
        readonly property bool fits : _flickable.contentWidth <= width
        
        Private.EdgeShadow
        {
            width: Maui.Style.iconSizes.medium
            height: parent.height
            visible: !_flickable.atXEnd && !parent.fits 
            opacity: 0.7
            z: 999
            edge: Qt.RightEdge
            anchors
            {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
        }
        
        Private.EdgeShadow
        {
            width: Maui.Style.iconSizes.medium
            height: parent.height
            visible: !_flickable.atXBeginning && !parent.fits 
            opacity: 0.7
            z: 999
            edge: Qt.LeftEdge
            anchors
            {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
        }
        
        RowLayout
        {
            anchors.fill: parent
            spacing: 0
            
            ScrollView
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                contentHeight: availableHeight
                contentWidth: _content.implicitWidth
                
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                
                Flickable
                {
                    id: _flickable
                    interactive: false
                    
                    Row
                    {
                        id: _content
                        width: _flickable.width
                        height: _flickable.height
                    }
                }
            }
            
            MouseArea
            {
                visible: control.showNewTabButton
                hoverEnabled: true
                onClicked: control.newTabClicked()
                Layout.fillHeight: true
                Layout.preferredWidth: visible ? height : 0
                
                Maui.PlusSign
                {
                    height: Maui.Style.iconSizes.tiny
                    width: height
                    anchors.centerIn: parent
                    color: parent.containsMouse || parent.containsPress ? Kirigami.Theme.highlightColor : Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
                }
            }
        }
    }
}
