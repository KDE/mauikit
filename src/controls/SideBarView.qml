import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    anchors.fill: parent
    default property alias content : _content.data
        property alias sideBarContent: _sideBar.content
        property alias sideBar : _sideBar
        
        Maui.SideBar
        {
            id: _sideBar
            height: parent.height     
            collapsed: control.width < preferredWidth * 2
            //preferredWidth : Math.min(control.width, Maui.Style.units.gridUnit * 12)            
        }
        
        Item
        {
            id: _content
            anchors.fill: parent       
            clip: true
            transform: Translate
            {
                x: control.sideBar.collapsed ? control.sideBar.position * (control.sideBar.width) : 0
            }
            
            anchors.leftMargin: control.sideBar.collapsed ? 0 : control.sideBar.width  * control.sideBar.position
        }
}

