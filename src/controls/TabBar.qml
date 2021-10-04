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
    //Kirigami.Theme.colorSet: Kirigami.Theme.View
    //Kirigami.Theme.inherit: false
     
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
    }
    
    contentItem: Item
    {        
        readonly property bool fits : _flickable.contentWidth <= width
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_flickable.atXEnd && !parent.fits 
            visible: active
            
            anchors
            {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Private.EdgeShadow
            {                    
                opacity: 0.7
                edge: Qt.RightEdge                    
            }
        }
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_flickable.atXBeginning && !parent.fits 
            visible: active
            anchors
            {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Private.EdgeShadow
            {
                
                opacity: 0.7
                edge: Qt.LeftEdge            
            }
        }
        
        RowLayout
        {
            anchors.fill: parent
            spacing: 0 
            
            ScrollView
            {
                id: _scrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: Maui.Style.space.tiny
                
                contentHeight: availableHeight
                contentWidth: _content.implicitWidth
                
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                
                Flickable
                {
                    id: _flickable
                    interactive: Maui.Handy.isTouch
                    
                    Row
                    {
                        id: _content
                        width: _scrollView.width
                        height: _scrollView.height
                        spacing: Maui.Style.space.tiny
                    }
                }
            }
            
            Loader
            {
                active: control.showNewTabButton
                visible: active
                asynchronous: true
                Layout.fillHeight: true
                Layout.preferredWidth: visible ? height : 0
                
                sourceComponent: MouseArea
                {
                    hoverEnabled: true
                    onClicked: control.newTabClicked()              
                    
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
}
