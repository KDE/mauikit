import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import "private" as Private

Item
{
    id: control
    default property alias content : _content.data
    property alias sideBarContent: _sideBar.content
    property alias sideBar : _sideBar

    Private.SideBar
    {
        id: _sideBar
        height: parent.height
        collapsed: control.width < (preferredWidth * 2.5)
        //preferredWidth : Math.min(control.width, Maui.Style.units.gridUnit * 12)
    }

    Item
    {
        anchors.fill: parent
        clip: true
        transform: Translate
        {
            x: control.sideBar.collapsed ? control.sideBar.position * (control.sideBar.width) : 0
        }

        anchors.leftMargin: control.sideBar.collapsed ? 0 : control.sideBar.width  * control.sideBar.position

        Item
        {
            id: _content
            anchors.fill: parent
        }

        Loader
        {
            anchors.fill: parent
            active: _sideBar.collapsed && _sideBar.position === 1
            // asynchronous: true

            sourceComponent: MouseArea
            {
                onClicked: _sideBar.close()

                Rectangle
                {
                    anchors.fill: parent
                    color: "#333"
                    opacity : visible ?  0.5 : 0

                    Behavior on opacity
                    {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }

    }
}

