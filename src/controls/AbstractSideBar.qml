/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui
import QtQuick.Templates 2.15 as T

/*!
 * \since org.mauikit.controls 1.0
 * \inqmlmodule org.mauikit.controls
 * \brief Collapsible sidebar
 * 
 * A global sidebar for the application window that can be collapsed.
 * To use a collapsable sidebar is a better idea to make use of the SideBar or ActionSideBar components which are ready for it and are handled by a ListView, you only need a data model or list of actions to be used.
 */
T.Drawer
{
    id: control
    edge: Qt.LeftEdge
    
    position: visible ? 1 : 0
    visible: enabled    
    
    implicitWidth: Math.min(preferredWidth, window().width) 
    
    implicitHeight: window().internalHeight
    height: implicitHeight
    
    y: (!window().altHeader ? window().headerContainer.implicitHeight : 0)
    //    closePolicy: modal || collapsed ?  Popup.CloseOnEscape | Popup.CloseOnPressOutside : Popup.NoAutoClose
    
    interactive: (modal || collapsed ) && Maui.Handy.isTouch && enabled
    
    dragMargin: Maui.Style.space.medium
    
    modal: false
    
    opacity: _dropArea.containsDrag ? 0.5 : 1
    clip: true
    
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    
    /*!
     *      \qmlproperty Item AbstractSideBar::content
     * 
     *      The main content is added to an Item contents, it can anchored or sized normally.
     */
    default property alias content : _content.data
        
        /*!
         *      If the sidebar can be collapsed into a slimmer bar with a width defined by the collapsedSize hint.
         */
        property bool collapsible: false
        
        /*!
         *      If the sidebar should be collapsed or not, this property can be used to dynamically collapse
         *      the sidebar on constrained spaces.
         */
        property bool collapsed: false
        
        /*!
         *      preferredWidth : int
         *      The preferred width of the sidebar in the expanded state.
         */
        property int preferredWidth : Maui.Style.units.gridUnit * 12
        
        /*!
         *      \qmlproperty MouseArea AbstractSideBar::overlay
         * 
         *      When the application has a constrained width to fit the sidebar and main contain,
         *      the sidebar is in a constrained state, and the app main content gets dimmed by an overlay.
         *      This property gives access to such ovelay element drawn on top of the app contents.
         */
        readonly property alias overlay : _overlayLoader.item
        
        property alias dropArea : _dropArea
        
        signal contentDropped(var drop)
        
        onCollapsedChanged:
        {
            if(collapsed || !control.enabled)
            {
                control.close()
            }
            else
            {
                control.open()
            }
        }
        
        Loader
        {
        id: _overlayLoader
        
        active: control.visible
        asynchronous: true 
        anchors.fill: parent
        anchors.margins: 0
        anchors.leftMargin: (control.width * control.position)
        visible: (control.collapsed && control.position > 0 && control.visible)
        parent: window().pageContent
        
        sourceComponent: MouseArea
        {           
        preventStealing: true
        propagateComposedEvents: false
        Rectangle
        {
        color: Qt.rgba(Maui.Theme.backgroundColor.r,Maui.Theme.backgroundColor.g,Maui.Theme.backgroundColor.b, 0.5)
        opacity: control.position
        anchors.fill: parent
        }
        
        onClicked: control.close()
        }
        }    
        
        background: Kirigami.ShadowedRectangle
        {
            color: Maui.Theme.backgroundColor
            property int radius: !Maui.App.controls.enableCSD ? 0 : Maui.Style.radiusV
            opacity: Maui.App.translucencyAvailable ? 0.4 : 1
            corners
            {
                topLeftRadius: radius
                topRightRadius: 0
                bottomLeftRadius: radius
                bottomRightRadius: 0
            }        
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }    
        }    
        
        //Label
        //{
            //parent: ApplicationWindow.overlay
            //color: "orange"
            //text: control.height + " /" + window().internalHeight
        //}
        
        contentItem: Item
        {
            id: _content
            
            DropArea
            {
                id: _dropArea
                anchors.fill: parent
                onDropped:
                {
                    control.contentDropped(drop)
                }
            }        
        }
        
        Maui.Separator
        {
            z: contentItem.z + 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 0.5
            weight: Maui.Separator.Weight.Light
            
            Behavior on color
            {
                Maui.ColorTransition{}
            }   
        } 
        
        Component.onCompleted:
        {
            if(control.visible)
            {
                control.open()
            }
        }
        
        Behavior on position
        {
            enabled: control.collapsible 
            NumberAnimation
            {
                duration: Maui.Style.units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        
        onClosed: control.position = 0
        onOpened: control.position = 1
        
        function toggle()
        {
            if(!control.enabled)
            {
                control.close()
                return
            }
            
            if(control.position > 0 && control.visible)
            {
                control.close()
            }
            else
            {
                control.open()
            }
        }
}

