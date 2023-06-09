/*
 *   Copyright 2019 Camilo Higuita <milo.h@aol.com>
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
import QtQml
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import org.mauikit.controls as Maui

/*!
 * \since org.mauikit.controls 1.0
 * \inqmlmodule org.mauikit.controls
 * \brief A page with a header and footer bar, that can be switched among many other features.
 *
 * This page has a header and footer bar that by default are a MauiKit ToolBar,
 * the header bar can be dinamically moved to the bottom under the footer for better
 * reachability on hand held devices like phones.
 *
 * Among other features, the page can have a reference to a flickable element to allow to have pull back
 * toolbar behaviour, floating toolbars, etc.
 *
 */
Pane
{
    id: control

    padding: 0
    leftPadding: control.padding
    rightPadding: control.padding
    topPadding: control.padding
    bottomPadding: control.padding

    Maui.Theme.colorSet: Maui.Theme.View
    Maui.Theme.inherit: false
    
    /*!
     *      \qmlproperty list<Object> Item::content
     *
     *      The default content of the page.
     *      To position child elements use anchors or do it manually.
     */
    default property alias content: _content.data

    /*!
         *      \qmlproperty Item Page::pageContent
         *
         *      An alias to the actual Item that contains the page children.
         */
    readonly property alias pageContent : _content

    /*!
         *      \qmlproperty int Page::internalHeight
         *
         *      The actual height of the page contents withouth the header or footer bars.
         */
    readonly property alias internalHeight : _content.height

    /*!
         *      A flickable element can be referenced in order to support the header and footer positioning options
         *        such as Inline, Pullback or floating.
         *        If a flickable is set, the page will modify its top or bottom margins properties.
         *        And watch for changes in properties such a contentX and contentY in order to support the former mentioned features.
         */
    property Flickable flickable : null

    /*!
         *      The footer bar can be place static and always visible with the InlineFooter value, or move with the flickable contents when using the PullBackFooter value.
         *      This is only supported if a flickable element has been set.
         *      By default this is set to InlineFooter.
         */
    property int footerPositioning : ListView.InlineFooter

    /*!
         *      The header bar can be place static and always visible with the InlineHeader value, or move with the flickable contents when using the PullBackHeader value.
         *      This is only supported if a flickable element has been set.
         *      By default this is set to InlineHeader unless it is a Mobile device, in which case it is PullBackHeader.
         */
    property int headerPositioning : flickable ? ListView.PullBackHeader : ListView.InlineHeader

    property int headerColorSet : altHeader ? Maui.Theme.Window : Maui.Theme.Header

    /*!
         *      A title for the page.
         *      This title is shown in the middle of the default header bar if the showTitle property is set to true.
         *      The displayed title in the header bar wont wrap and will elide in the middle.
         */
    property string title

    /*!
         *      If a title is set and this is set to true, such title will be displayed in the default header bar in the middle.
         */
    property bool showTitle : true

    /*!
         *      \qmlproperty ToolBar Page::headBar
         *      An alias to the default header bar toolbar.
         *      The toolbar is a MauiKit ToolBar.
         */
    property alias headBar : _headBar

    /*!
         *      \qmlproperty ToolBar Page::footBar
         *      An alias to the default footer bar toolbar.
         *      The toolbar is a MauiKit ToolBar.
         */
    property alias footBar: _footBar

    /*!
         *      \qmlproperty list<Object> Page::footerColumn
         *      Quick way to add more children to the footer bar.
         *      The footer bar is handled by a ColumnLayout so any elements to be added need to be postioned using the Layout attached properties.
         *      Layout.fillWidth can be set, but an implicit or preferredHeight must be given.
         */
    property alias footerColumn : _footerContent.data
    property alias footerContainer : _footerContent

    /*!
         *      \qmlproperty list<Object> Page::headerColumn
         *      Quick way to add more children to the header bar.
         *      The header bar is handled by a ColumnLayout so any elements to be added need to be postioned using the Layout attached properties.
         *      Layout.fillWidth can be set, but an implicit or preferredHeight must be given.
         */
    property alias headerColumn : _headerContent.data
    property alias headerContainer : _headerContent

    /*!
         *      The page margins between the children contents and the actual container.
         *      This margins do not affect the header or footer bars.
         *      By default this is set to 0
         */
    property int margins: 0

    /*!
         *      Page left margins
         */
    property int leftMargin : margins

    /*!
         *      Page right margins
         */
    property int rightMargin: margins

    /*!
         *      Page top margins
         */
    property int topMargin: margins

    /*!
         *      Page bottom margins
         */
    property int bottomMargin: margins

    /*!
         *      If set to true the header bar will be positioned to the bottom under the footer bar.
         *      This makes sense in some cases for better reachability, or custom design patterns.
         */
    property bool altHeader : false

    /*!
         *      If the header bar should hide under certain conditions.
         *      To fine tune a threshold margin can be set, and a time delay.
         */
    property bool autoHideHeader : false

    /*!
         *      If the footer bar should hide under certain conditions.
         *      To fine tune a threshold margin can be set, and a time delay.
         */
    property bool autoHideFooter : false

    /*!
         *      Pixels threshold for when the header should auto hide.
         *      The default value is set to Maui.Style.toolBarHeight, which is the double distance of the default header bar toolbar.
         */
    property int autoHideHeaderMargins : Maui.Style.toolBarHeight

    /*!
         *      Pixels threshold for when the footer should auto hide.
         *      The default value is set to Maui.Style.toolBarHeight, which is the double distance of the default footer bar toolbar.
         */
    property int autoHideFooterMargins : Maui.Style.toolBarHeight

    /*!
         *      Span of time to hide the footer bar after the conditions have been met.
         *      If within the span of time the conditions changed then the timer gets reseted.
         */
    property int autoHideFooterDelay : Maui.Handy.isTouch ? 0 : 1000

    /*!
         *      Span of time to hide the header bar after the conditions have been met.
         *      If within the span of time the conditions changed then the timer gets reseted.
         */
    property int autoHideHeaderDelay : Maui.Handy.isTouch ? 0 : 1000

    //    property bool floatingHeader : control.flickable && !control.flickable.atYBeginning

    /*!
         *      If the footer bar should float over the page contents, if a flickable has been set then the default header bar will have a translucent ShaderEffect
         *      to hint about the content under it.
         */
    property bool floatingHeader : false

    /*!
         *      If the header bar should float over the page contents, if a flickable has been set then the default header bar will have a translucent ShaderEffect
         *      to hint about the content under it.
         */
    property bool floatingFooter: false

    property bool showCSDControls : false

    /*!
         *      The page has requested to go back by a gesture or keyboard shortcut
         */
    signal goBackTriggered()

    /*!
         *      The page has requested to go forward by a gesture or keyboard shortcut
         */
    signal goForwardTriggered()

    QtObject
    {
        id: _private
        property int topMargin : (!control.altHeader ? (control.floatingHeader ? 0 : _headerContent.implicitHeight) : 0) + control.topMargin
        property int bottomMargin: ((control.floatingFooter && control.footerPositioning === ListView.InlineFooter ? 0 : _footerContent.implicitHeight)  + (control.altHeader ? _headerContent.implicitHeight : 0))
    }

    onFlickableChanged:
    {
        returnToBounds()
    }

    Binding
    {
        when:  control.floatingFooter && control.footerPositioning === ListView.InlineFooter && _footerContent.implicitHeight > 0
        target: control.flickable
        property: "bottomMargin"
        value: _footerContent.implicitHeight
        restoreMode: Binding.RestoreBindingOrValue
    }

    Connections
    {
        target: control.flickable ? control.flickable : null
        ignoreUnknownSignals: true
        enabled: control.flickable && ((control.header && control.headerPositioning === ListView.PullBackHeader) || (control.footer &&  control.footerPositioning === ListView.PullBackFooter))
        property int oldContentY
        property bool updatingContentY: false

        function onContentYChanged()
        {
            _headerAnimation.enabled = false
            _footerAnimation.enabled = false

            if(!control.flickable.dragging && control.flickable.atYBeginning)
            {
                control.returnToBounds()
            }

            if (updatingContentY || !control.flickable || !control.flickable.dragging)
            {
                oldContentY = control.flickable.contentY;
                return;
                //TODO: merge
                //if moves but not dragging, just update oldContentY
            }

            if(control.flickable.contentHeight < control.height)
            {
                return
            }

            var oldFHeight
            var oldHHeight

            if (control.footer && control.footerPositioning === ListView.PullBackFooter && control.footer.visible)
            {
                oldFHeight = control.footer.height
                control.footer.height = Math.max(0,
                                                 Math.min(control.footer.implicitHeight,
                                                          control.footer.height + oldContentY - control.flickable.contentY));
            }

            if (control.header && control.headerPositioning === ListView.PullBackHeader && control.header.visible && !control.altHeader)
            {
                oldHHeight = control.header.height
                control.header.height = Math.max(0,
                                                 Math.min(control.header.implicitHeight,
                                                          control.header.height + oldContentY - control.flickable.contentY));
            }

            //if the implicitHeight is changed, use that to simulate scroll
            if (control.header && oldHHeight !== control.header.height && control.header.visible && !control.altHeader)
            {
                updatingContentY = true
                control.flickable.contentY -= (oldHHeight - control.header.height)
                updatingContentY = false

            } else {
                oldContentY = control.flickable.contentY
            }
        }

        function onMovementEnded()
        {
            if (control.header && control.header.visible && control.headerPositioning === ListView.PullBackHeader && !control.altHeader)
            {
                _headerAnimation.enabled = true

                if (control.header.height >= (control.header.implicitHeight/2) || control.flickable.atYBeginning )
                {
                    control.header.height =  control.header.implicitHeight

                } else
                {
                    control.header.height = 0
                }
            }

            if (control.footer && control.footer.visible && control.footerPositioning === ListView.PullBackFooter)
            {
                _footerAnimation.enabled = true

                if (control.footer.height >= (control.footer.implicitHeight/2) ||  control.flickable.atYEnd)
                {
                    if(control.flickable.atYEnd)
                    {
                        control.footer.height =  control.footer.implicitHeight

                        control.flickable.contentY = control.flickable.contentHeight - control.flickable.height
                        oldContentY = control.flickable.contentY
                    }else
                    {
                        control.footer.height =  control.footer.implicitHeight

                    }

                } else
                {
                    control.footer.height = 0
                }
            }
        }
    }

    /*!
         *
         */
    property Item header : Maui.ToolBar
    {
        id: _headBar
        visible: count > 0
        width: visible ? parent.width : 0
        position: control.altHeader ? ToolBar.Footer : ToolBar.Header
        translucencySource: ShaderEffectSource
        {
            sourceItem: _content
            sourceRect:  _headBar.background ? (control.floatingHeader ? Qt.rect(0, (_headBar.position === ToolBar.Header ? 0 :  _content.height - _headBar.background.height), _headBar.background.width, _headBar.background.height) : Qt.rect(0, (_headBar.position === ToolBar.Header ?  0 - (_headBar.background.height) :  _content.height), _headBar.background.width, _headBar.background.height)) : null
        }
        
        Binding on height
        {
            value: visible ? _headBar.implicitHeight : 0
            restoreMode: Binding.RestoreBindingOrValue
        }

        Behavior on height
        {
            id: _headerAnimation
            enabled: false
            NumberAnimation
            {
                duration: Maui.Style.units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
        
        Component
        {
            id: _titleComponent
            
            Item
            {
                implicitHeight:_titleLabel.implicitHeight
                
                Label
                {
                    id: _titleLabel
                    anchors.fill: parent
                    text: control.title
                    elide : Text.ElideRight
                    font: Maui.Style.h2Font
                    horizontalAlignment : Text.AlignHCenter
                    verticalAlignment :  Text.AlignVCenter
                }
            }
        }

        farRightContent: Loader
        {
            active: control.showCSDControls
            visible: active

            asynchronous: true

            sourceComponent: Maui.WindowControls {}
        }

        middleContent: Loader
        {
            visible: item
            active: control.title && control.showTitle
            sourceComponent: _titleComponent

            asynchronous: true

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    //Label
    //{
    //z: 999999999999
    //color: "yellow"
    //text: _footBar.visibleCount + " / " + _footBar.count + " - " + _footBar.height + " / " + footer.height + " - " + _footBar.visible + " / " + footer.visible + " / " + footer.height + " / " + _footerContent.implicitHeight  + " / " + _footerContent.implicitHeight
    //}

    /*!
         *
         */
    property Item footer : Maui.ToolBar
    {
        id: _footBar
        visible: count > 0
        width: visible ? parent.width : 0
        height: visible ? implicitHeight : 0

        position: ToolBar.Footer

        translucencySource: ShaderEffectSource
        {
            //textureSize: Qt.size(_headBarBG.width * 0.2, _headBarBG.height * 0.2)
            sourceItem: _content
            sourceRect: _footBar.background ? (control.floatingFooter  ?  Qt.rect(0, _content.height - _footBar.background.height, _footBar.background.width, _footBar.background.height) : Qt.rect(0, _content.height, _footBar.background.width, _footBar.background.height)) : null
        }
        
        Behavior on height
        {
            id: _footerAnimation
            enabled: false
            NumberAnimation
            {
                duration: Maui.Style.units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    states: [  State
        {
            when: !altHeader
            
            AnchorChanges
            {
                target: _headerContent
                anchors.top: parent.top
                anchors.bottom: undefined
            }
            
            AnchorChanges
            {
                target: _footerContent
                anchors.top: undefined
                anchors.bottom: parent.bottom
            }
        },
        
        State
        {
            when: altHeader
            
            AnchorChanges
            {
                target: _headerContent
                anchors.top: undefined
                anchors.bottom: parent.bottom
            }
            
            AnchorChanges
            {
                target: _footerContent
                anchors.top: undefined
                anchors.bottom: _headerContent.top
            }
        } ]

    onAutoHideHeaderChanged:
    {
        if(control.autoHideHeader)
        {
            pullBackHeader()
        }else
        {
            pullDownHeader()
        }
    }

    onAutoHideFooterChanged:
    {
        if(control.autoHideFooter)
        {
            pullBackFooter()
        } else
        {
            pullDownFooter()
        }
    }
    onAltHeaderChanged: pullDownHeader()


    //                 Label
    //                 {
    //                     anchors.centerIn: _headerContent
    //                     text: header.height + "/" + _headerContent.height + " - " + _layout.anchors.topMargin
    //                     color: "orange"
    //                     z: _headerContent.z + 1
    //                     visible: header.visible
    //                 }
    //
    //                    Label
    //                 {
    //                     anchors.centerIn: _footerContent
    //                     text: footer.height + "/" + _footerContent.height + " - " + _layout.anchors.topMargin
    //                     color: "orange"
    //                     z: _footerContent.z + 9999
    //                 }

    contentItem: Item
    {
        Item
        {
            id: _content
            anchors.fill: parent

            anchors.topMargin: _private.topMargin
            anchors.bottomMargin: _private.bottomMargin

            anchors.leftMargin: control.leftMargin
            anchors.rightMargin: control.rightMargin
        }

        Column
        {
            id: _headerContent
            anchors.left: parent.left
            anchors.right: parent.right
        }
        
        Column
        {
            id: _footerContent
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Loader
        {
            anchors.fill: parent
            asynchronous: true
            sourceComponent: MouseArea // to support tbutton go back and forward
            {
                propagateComposedEvents: true
                acceptedButtons: Qt.BackButton | Qt.ForwardButton
                cursorShape: undefined
                
                //        hoverEnabled: true
                //        onEntered: _splitView.currentIndex = control.index
                onPressed:
                {
                    mouse.accepted = false
                    if(mouse.button === Qt.BackButton)
                    {
                        control.goBackTriggered()
                    }

                    if(mouse.button === Qt.ForwardButton)
                    {
                        control.goForwardTriggered()
                    }
                }
            }
        }

        Loader
        {
            anchors.fill: parent
            asynchronous: true
            z: _content.z +1
            active: (control.autoHideFooter || control.autoHideHeader ) && Maui.Handy.isTouch

            sourceComponent: MouseArea
            {
                parent: _content
                propagateComposedEvents: true
                drag.filterChildren: true

                Timer
                {
                    id: doubleClickTimer
                    interval: 900
                    onTriggered:
                    {
                        if(control.autoHideHeader)
                        {
                            if(header.height !== 0)
                            {
                                _autoHideHeaderTimer.start()
                                _revealHeaderTimer.stop()

                            }else
                            {
                                _autoHideHeaderTimer.stop()
                                _revealHeaderTimer.start()
                            }
                        }

                        if(control.autoHideFooter)
                        {
                            if(footer.height !== 0)
                            {
                                _autoHideFooterTimer.start()

                            }else
                            {
                                pullDownFooter()
                                _autoHideFooterTimer.stop()
                            }
                        }
                    }
                }

                onPressed:
                {
                    doubleClickTimer.restart();
                    mouse.accepted = false
                }
            }
        }

        Loader
        {
            asynchronous: true
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: active ? _headerContent.implicitHeight + control.autoHideHeaderMargins : 0
            z: _content.z +1
            active: control.autoHideHeader && !control.altHeader && !Maui.Handy.isTouch

            sourceComponent: Item
            {

                HoverHandler
                {
                    target: parent
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus

                    onHoveredChanged:
                    {
                        if(!control.autoHideHeader || control.altHeader)
                        {
                            _autoHideHeaderTimer.stop()
                            return
                        }

                        if(!hovered)
                        {
                            _autoHideHeaderTimer.start()
                            _revealHeaderTimer.stop()

                        }else
                        {
                            _autoHideHeaderTimer.stop()
                            _revealHeaderTimer.start()
                        }
                    }
                }
            }
        }

        Loader
        {
            asynchronous: true
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: active ? _footerContent.implicitHeight + control.autoHideFooterMargins : 0
            z: _footerContent.z - 1
            active: control.autoHideFooter && !control.altHeader && !Maui.Handy.isTouch

            sourceComponent: Item
            {
                HoverHandler
                {
                    target: parent

                    acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus

                    onHoveredChanged:
                    {
                        if(!control.autoHideFooter)
                        {
                            return
                        }

                        if(!hovered)
                        {
                            _autoHideFooterTimer.start()

                        }else
                        {
                            pullDownFooter()
                            _autoHideFooterTimer.stop()
                        }
                    }
                }
            }
        }
    }

    Timer
    {
        id: _revealHeaderTimer
        interval: autoHideHeaderDelay

        onTriggered:
        {
            pullDownHeader()
        }
    }

    Timer
    {
        id: _autoHideHeaderTimer
        interval: autoHideHeaderDelay
        onTriggered:
        {
            if(control.autoHideHeader)
            {
                pullBackHeader()
            }

            stop()
        }
    }

    Timer
    {
        id: _autoHideFooterTimer
        interval: control.autoHideFooterDelay
        onTriggered:
        {
            if(control.autoHideFooter)
            {
                pullBackFooter()
            }

            stop()
        }
    }

    //Keys.onBackPressed:
    //{
    //control.goBackTriggered();
    //}

    //Shortcut
    //{
    //sequence: "Forward"
    //onActivated: control.goForwardTriggered();
    //}

    //Shortcut
    //{
    //sequence: StandardKey.Forward
    //onActivated: control.goForwardTriggered();
    //}

    //Shortcut
    //{
    //sequence: StandardKey.Back
    //onActivated: control.goBackTriggered();
    //}


    Component.onCompleted :
    {
        if(footer)
        {
            _footerContent.data.push(footer)
        }
        
        if(header)
        {
            let data = [header]
            
            for(var i in _headerContent.data)
            {
                data.push(_headerContent.data[i])
            }
            _headerContent.data = data
        }
    }

    /*!
         *
         */
    function returnToBounds()
    {
        if(control.header)
        {
            // pullDownHeader()
        }

        if(control.footer)
        {
            // pullDownFooter()
        }
    }

    /*!
         *
         */
    function pullBackHeader()
    {
        _headerAnimation.enabled = true
        header.height = 0
    }

    /*!
         *
         */
    function pullDownHeader()
    {
        _headerAnimation.enabled = true
        header.height = header.implicitHeight
    }

    /*!
         *
         */
    function pullBackFooter()
    {
        _footerAnimation.enabled = true
        footer.height= 0
    }

    /*!
         *
         */
    function pullDownFooter()
    {
        _footerAnimation.enabled = true
        footer.height = _footerContent.implicitHeight
    }
}
