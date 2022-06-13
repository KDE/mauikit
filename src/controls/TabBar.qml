import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

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
T.TabBar
{
    id: control
    
    //     implicitWidth: _content.contentWidth
    implicitHeight: Maui.Style.rowHeight + topPadding + bottomPadding
    padding: Maui.Style.space.tiny
    
    Maui.Theme.colorSet: Maui.Theme.Header
    Maui.Theme.inherit: false
    
    spacing: Maui.Style.space.tiny
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
        color: Maui.Theme.backgroundColor
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_content.atXEnd && !parent.fits 
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
            active: !_content.atXBeginning && !parent.fits 
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
    }
    
    contentItem: Item
    {        
        readonly property bool fits : _content.contentWidth <= width
        
        RowLayout
        {
            anchors.fill: parent
            spacing: 0 
            
            Maui.ScrollView
            {
                id: _scrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                contentWidth: availableWidth
                
                ListView
                {
                    id: _content
                    clip: true
                    orientation: ListView.Horizontal
                    
                    width: _scrollView.width
                    height: _scrollView.height
                    
                    spacing: control.spacing
                    
                    model: control.contentModel
                    currentIndex: control.currentIndex
                    
                    interactive: Maui.Handy.isTouch
                    snapMode: ListView.SnapOneItem  
                    
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0
                    highlightResizeDuration : 0
                    
                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement: Flickable.StopAtBounds
                    
                    keyNavigationEnabled : true
                    keyNavigationWraps : true
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
                        color: parent.containsMouse || parent.containsPress ? Maui.Theme.highlightColor : Qt.tint(Maui.Theme.textColor, Qt.rgba(Maui.Theme.backgroundColor.r, Maui.Theme.backgroundColor.g, Maui.Theme.backgroundColor.b, 0.7))
                    }
                }
            }
        }
    }
}
