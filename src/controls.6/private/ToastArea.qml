
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import QtQuick.Effects
import QtQml.Models

import QtMultimedia

import org.mauikit.controls as Maui

Control
{
    id: control
    focus: true
    focusPolicy: Qt.StrongFocus
    padding: Maui.Style.contentMargins
    visible: _container.count > 0
    
    hoverEnabled: true
    
    property bool autoClose :  Window.window.active
        
    SoundEffect
    {
        id: playSound
        source: "qrc:/assets/notification_simple-01.wav"
    }
    
    SoundEffect
    {
        id: _dismissSound
        source: "qrc:/assets/notification_simple-02.wav"
    }
    
    Keys.enabled: true
    Keys.forwardTo: _container
    Keys.onEscapePressed:
    {
        control.dismiss()
    }
    
    onVisibleChanged:
    {
        if(visible)
        {
            control.forceActiveFocus()
        }else
        {
            nextItemInFocusChain().forceActiveFocus()
        }
    }
    
    background: MouseArea
    {
        // opacity: 0.8
        
        onClicked:
        {
            if(_container.count === 1)
                control.dismiss()
        }
        
        Rectangle
        {
            anchors.fill: parent
            gradient: Gradient
            {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Maui.Theme.backgroundColor }
            }
        }
    }
    
    Component
    {
        id: _toastComponent
        
        ItemDelegate
        {
            id: _toast
            clip: false
            focus: true

            Keys.enabled: true
            Keys.onEscapePressed: control.remove(mindex)
            Keys.forwardTo: _actionRepeater
            Keys.onPressed: (event) =>
                            {
                                console.log("Key on notification nof", _toast.body, _toast.mindex, event.key === Qt.Key_Enter, _toast.actions.length)
                                if(event.key === Qt.Key_Return)
                                {
                                    if(_toast.actions.length >= 1)
                                    {
                                        _toast.actions[0].trigger()
                                        event.accepted = true
                                    }
                                }

                            }

            Maui.Theme.colorSet: Maui.Theme.View
            Maui.Theme.inherit: false

            readonly property int mindex : ObjectModel.index

            width: ListView.view.width
            height: _layout.implicitHeight + topPadding +bottomPadding
            
            hoverEnabled: true
            
            padding: Maui.Style.contentMargins
            
            property string title : ""
            property alias iconSource: _template.iconSource
            property alias imageSource: _template.imageSource
            property alias body: _template.label2.text
            property list<Action> actions

            property int timeout : 3500
            
            onClicked:
            {
                if( _toast.actions.length > 0)
                    return

                control.remove(mindex)
            }
            
            background: Rectangle
            {
                radius: Maui.Style.radiusV
                color: _toast.hovered && _toast.actions.length === 0? Maui.Theme.hoverColor : Maui.Theme.backgroundColor
                
                // Text
                // {
                //     text: _progressTimer.progress + " / " + _toastTimer.interval
                //     color: "yellow"
                //     z: _toast.z+9999
                // }
                Item
                {
                    id: _bglay
                    anchors.fill: parent
                    ProgressBar
                    {
                        id: _progressBar
                        visible: (!_toast.hovered && !_container.hovered ) && control.autoClose
                        anchors.bottom: parent.bottom
                        height: 2
                        width: parent.width
                        from: 0
                        to : _toastTimer.interval
                        value: _progressTimer.progress
                        opacity: value/to

                        Timer
                        {
                            id: _progressTimer
                            running: _toastTimer.running
                            property int progress : 0
                            interval: 50
                            repeat: _toastTimer.running
                            onTriggered: progress += _progressTimer.interval
                        }

                        function restart()
                        {
                            _progressTimer.progress = 0
                            _progressTimer.restart()
                        }
                    }
                    layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
                    layer.effect: MultiEffect
                    {
                        maskEnabled: true
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1.0
                        maskSpreadAtMax: 0.0
                        maskThresholdMax: 1.0
                        maskSource: ShaderEffectSource
                        {
                            sourceItem: Rectangle
                            {
                                x: _bglay.x
                                y: _bglay.y
                                width: _bglay.width
                                height: _bglay.height
                                radius: Maui.Style.radiusV
                            }
                        }
                    }
                }
                
                layer.enabled: GraphicsInfo.api !== GraphicsInfo.Software
                layer.effect: MultiEffect
                {
                    autoPaddingEnabled: true
                    shadowEnabled: true
                    shadowColor: "#80000000"
                }
            }
            
            Component.onCompleted:
            {
                // _progressTimer.start()
                _toastTimer.interval = _toast.timeout + (_listView.count * 1500)
                
                _toastTimer.start()
            }
            
            Timer
            {
                id: _toastTimer
                // running: !_toast.hovered && !_container.hovered && control.autoClose
                onTriggered:
                {
                    if(_toast.hovered || _container.hovered || !control.autoClose)
                    {
                        _toastTimer.restart()
                        _progressBar.restart()
                        return
                    }
                    _progressTimer.stop()
                    control.remove(_toast.mindex)
                }
            }
            
            contentItem: ColumnLayout
            {
                id: _layout
                spacing: Maui.Style.space.medium
                
                Maui.ListItemTemplate
                {
                    id: _template
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    label1.text: _toast.title
                    label2.wrapMode: Text.Wrap
                    iconSizeHint: Maui.Style.iconSizes.big
                }
                
                RowLayout
                {
                    Layout.preferredHeight: visible ? implicitHeight : -_layout.spacing
                    visible: _toast.actions.length > 0
                    Layout.fillWidth: true
                    spacing: Maui.Style.defaultSpacing

                    Repeater
                    {
                        id :_actionRepeater
                        model: _toast.actions
                        delegate: Button
                        {
                            focus: true
                            focusPolicy: Qt.StrongFocus
                            action: modelData
                            Maui.Controls.status: modelData.Maui.Controls.status
                            Layout.fillWidth: true
                            onClicked:
                            {
                                // if(_toast.actions.length === 1)
                                control.remove(_toast.mindex)
                            }
                        }
                    }
                }
            }
            
            DragHandler
            {
                id: _dragHandler
                yAxis.enabled: false
                
                onActiveChanged:
                {
                    if(!active)
                    {
                        if(_dragHandler.centroid.scenePressPosition.x.toFixed(1) - _dragHandler.centroid.scenePosition.x.toFixed(1) > 80)
                        {
                            control.remove(_toast.mindex)
                        }else
                        {
                            _toast.x = 0
                        }
                    }
                }
            }
        }
    }
    
    contentItem: Item
    {
        Container
        {
            id: _container
            clip: false
            hoverEnabled: true
            
            width: Math.min(400, parent.width)
            height: Math.min( _listView.implicitHeight + topPadding + bottomPadding, 500)
            
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Keys.enabled: true
            Keys.forwardTo: _listView
            
            contentItem: Maui.ListBrowser
            {
                id: _listView

                property bool expanded : true
                clip: false
                orientation: ListView.Vertical
                snapMode: ListView.SnapOneItem

                spacing: Maui.Style.space.medium

                Keys.enabled: true
                Keys.forwardTo: currentItem
                Keys.onPressed: (event) =>
                                {
                                    console.log("Key on notification item")
                                }

                model: _container.contentModel

                footer: Item
                {
                    width: ListView.view.width
                    height: Maui.Style.toolBarHeight

                    Button
                    {
                        id: _dimissButton
                        visible: _container.count > 1
                        width: parent.width
                        anchors.centerIn: parent
                        text: i18n("Dismiss All")
                        onClicked: control.dismiss()
                    }
                }
            }
        }
    }

    function add(icon, title, body, actions = [])
    {
        const properties = ({
                                'iconSource': icon,
                                'title': title,
                                'body': body,
                                'actions': actions })

        const object = _toastComponent.createObject(_listView.flickable, properties);
        _container.insertItem(0, object)
        playSound.play()
        control.forceActiveFocus()
    }

    function dismiss()
    {
        let count = _container.count
        let items = []
        for(var i = 0; i< count; i++)
        {
            items.push(_container.itemAt(i))
        }

        for(var j of items)
        {
            _container.removeItem(j)
        }

        _dismissSound.play()
    }

    function remove(index)
    {
        _container.removeItem(_container.itemAt(index))
    }
}
