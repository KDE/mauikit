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
import QtQuick.Effects

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.Pane
 * @since org.mauikit.controls 1.0
 *
 * @brief A page with a header and footer, that can be flipped among many other features.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-pane.html">This control inherits from QQC2 Pane, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 *  This page has a predefined header and footer bars that by default are set to a MauiKit ToolBar.
 *  The header bar can be dynamically moved to the bottom area, under the footer, for better
 *  reachability on hand held devices like phones.
 *  @see ToolBar
 *
 *  Any other item can replace the header and/or footer. And the default toolbars can be populated easily via the aliases:
 *  @see headBar
 *  @see footBar
 *
 *  Thje following code snippet is a quick example for setting a custom header:
 *  @code
 *    Page
 *    {
 *        id: _page
 *
 *        header: Rectangle
 *        {
 *            width: parent.width
 *            height: 40
 *            color: "pink"
 *        }
 *    }
 * @endcode
 *
 * @image html Page/page_structure.png "A Page with a header and footer - and then the header moved to the bottom under the footer"

 * @note The Page control supports the Controls attached properties for level, status and showCSD. By default a Page level is set to be Secondary, but if the Page has been set to display the Client Side Decoration buttons via `Controls.showCSD`, then it will be set as Primary. This `level` property is then propagated to the deafult header bar.
 *
 * @section features Features
 *
 * Among other features, the page can make use of a reference to a flickable element to allow to have "pull-back toolbar" behaviour, floating toolbars, etc.
 *
 * @subsection pullback-bars Pull-Back Bars
 *
 * Pull-back bars allow to expand the content area by pulling away the header or footer when content is being flicked/scrolled - which is useful on phone screens. To enable this behaviour you need to reference the Flickable element via the `flickable` property.
 * @see flickable
 *
 * Then set the header/footer positioning properties to `ListView.PullBackHeader`. This property is automatically set to the default header if a flickable element has been assigned, so you can disable it by setting the property to `ListView.InlineHeader` instead.
 * @see footerPositioning
 * @see headerPositioning
 *
 * @subsection bars Bars Layout
 *
 * As mentioned before, the Page has a header and footer area- the header can be moved to the bottom via the alternate header property: `altHeader`. But you can also stack multiple bars vertically. So you can have two or more header/footer bars.
 * @see altHeader
 *
 * To attach more bars use the header and footer columns property.
 * @see headerColumn
 * @see footerColumn
 *
 * @code
 *    Page
 *    {
 *        id: _page
 *
 *        headerColumn: [
 *            Rectangle
 *            {
 *                width: parent.width
 *                height: 40
 *                color: "pink"
 *            },
 *
 *            Rectangle
 *            {
 *                width: parent.width
 *                height: 40
 *                color: "yellow"
 *            }
 *        ]
 *    }
 * @endcode
 *
 * The header/footer layout is handled by a Column control, which can be accessed via the aliases to tweak the spacing, for example.
 * @see headerContainer
 * @see footerContainer
 *
 * @image html Page/headerColumn.png "A Page with a default header bar and two rectangles stacked as part of the header column"
 *
 * @subsection floatingbars Floating & AutoHide
 *
 * The header and/or footer bars can be set to a floating position - which means they will flow over the page contents at the bottom and top. When this is enable a translucency effect will be applied to hint about the content being covered underneath.
 * @see floatingFooter
 * @see floatingHeader
 *
 * The bars can also be set to auto-hide, when the cursor moves out or shown again when the cursor enters the bar area.
 * @see autoHideFooter
 * @see autoHideHeader
 *
 * The time to trigger this actions can be tweaked using the delay properties.
 * @see autoHideFooterDelay
 * @see autoHideHeaderDelay
 *
 * And to finetune the target area which reacts to enter and exit events, use the margins property:
 * @see autoHideFooterMargins
 * @see autoHideHeaderMargins
 *
 * @image html Page/floating_header.png "A Page with a floating header - and a translucent effect"
 *
 * @section notes Notes
 * This component is an alternative to the QQC2 Page control, where the header and footer can not be moved easily - and it adds a few more functionality.
 *
 * The padding properties will affect the header and footer, so if instead you meant to add internal padding to the page contents, you can use the margins properties.
 *
 * When used in a StackView or SwipeView, this Page emits two signals for the go forward/back actions, which can be consumed to pop or push pages.
 * @see goBackTriggered
 *
 * @code
 *    Page
 *    {
 *        id: _page
 *
 *        headBar.rightContent: Switch
 *        {
 *            text: "Alt Header"
 *            checked: _page.altHeader
 *            onToggled: _page.altHeader = checked
 *        }
 *    }
 * @endcode
 *
 * @image html Page/alt_header_dark.png "An ApplicationWindow filled with a Page and with the CSD controls enabled"
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/Page.qml">You can find a more complete example at this link.</a>
 *
 * @note This control supports the attached Controls.showCSD property to display the window control buttons when using CSD. This is only supported if used with the MauiKit ToolBar as the header bar - which is the default. If use with another header element, the window control buttons need to be added manually.
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

    Maui.Controls.showCSD: false
    Maui.Controls.level: control.Maui.Controls.showCSD === true ? Maui.Controls.Primary : Maui.Controls.Secondary
    Maui.Controls.flat: true

    /**
     * @brief The default content of the page.
     * To position child elements use anchors or do it manually.
     *
     * @note This is a `default` property
     *
     * @property list<QtObject> Page::content
     */
    default property alias content: _content.data

    /**
         * @brief An alias to the actual page container.
         * @property Item Page::pageContent
         */
    readonly property alias pageContent : _parentContainer

    /**
         *
         * The actual height of the page contents without the header or footer bars height.
         * @property int Page::internalHeight
         */
    readonly property alias internalHeight : _content.height

    /**
         * @brief A flickable element can be referenced in order to support the header and footer positioning options such as Inline, Pullback or floating.
         * If a flickable is set, the page will modify its top or bottom margins properties.
         * And watch for changes in the Flickable properties, such as contentX and contentY in order to support the formerly mentioned features.
         */
    property Flickable flickable : null

    /**
         * @brief  The footer bar can be place static and always visible with the InlineFooter value, or moved along with the flickable contents when using the PullBackFooter value.
         * This is only supported if a flickable element has been set.
         * @see flickable
         * By default this is set to InlineFooter.
         *
         * Possible values are:
         * - ListView.PullBackFooter
         * - ListView.InlineFooter
         */
    property int footerPositioning : ListView.InlineFooter

    /**
         * @brief The header bar can be place static and always visible with the InlineHeader value, or moved along with the flickable contents when using the PullBackHeader value.
         * This is only supported if a flickable element has been set.
         * @see flickable
         *
         * By default this is set to `InlineHeader` unless a Flickable has been attached, in which case it is set to `PullBackHeader`.
         *
         * Possible values are:
         * - ListView.PullBackHeader
         * - ListView.InlineHeader
         */
    property int headerPositioning : flickable ? ListView.PullBackHeader : ListView.InlineHeader


    /**
         * @brief Convinient way to change the color set of the default header.
         * @code
         * Page
         * {
         *  headerColorSet: Theme.Complementary
         * }
         * @endcode
         */
    property int headerColorSet : altHeader ? Maui.Theme.Window : Maui.Theme.Header

    /**
         * @brief A title for the page.
         * This title is shown in the middle of the default header bar if the show title property is set to true.
         * @see showTitle
         * The displayed title in the header bar won't wrap, but will elide in the middle.
         */
    property string title

    /**
         * @brief If a title is set and this is set to true, such title will be displayed in the default header bar in the middle.
         */
    property bool showTitle : true

    /**
         * @brief An alias to the default ToolBar as the header bar.
         * The toolbar is a MauiKit ToolBar.
         * @see ToolBar
         * @property ToolBar Page::headBar
         */
    property alias headBar : _headBar

    /**
         * @brief An alias to the default ToolBar as the footer bar.
         * The toolbar is a MauiKit ToolBar.
         * @property ToolBar Page::footBar
         */
    property alias footBar: _footBar

    /**
         * @brief Quick way to add more children to the footer bar.
         * The footer bar is handled by a Column.
         * @property list<QtObject> Page::footerColumn
         */
    property alias footerColumn : _footerContent.data

    /**
         * @brief The actual container for all the footer bars.
         * @property Column Page::footerContainer
         */
    readonly property alias footerContainer : _footerContent

    /**
         * @brief Quick way to add more children to the header bar.
         * The header bar is handled by a Colum.
         * @property list<QtObject> Page::headerColumn
         */
    property alias headerColumn : _headerContent.data

    /**
         * @brief The actual container for all the header bars.
         * @property Column Page::headerContainer
         */
    readonly property alias headerContainer : _headerContent

    /**
         * @brief The page margins for the page contents.
         * This margins do not affect the header or footer bars.
         * By default this is set to 0
         */
    property int margins: 0

    /**
         * @brief Page left margins
         */
    property int leftMargin : margins

    /**
         * @brief Page right margins
         */
    property int rightMargin: margins

    /**
         * @brief Page top margins
         */
    property int topMargin: margins

    /**
         * @brief Page bottom margins
         */
    property int bottomMargin: margins

    /**
      * @brief Margins around the footer column section
      */
    property alias footerMargins: _footerContent.margins

    /**
      * @brief Margins around the footer header section
      */
    property alias headerMargins: _headerContent.margins

    /**
         * @brief If set to `true` the header bar will be positioned to the bottom under the footer bar.
         * This makes sense in some cases for better reachability, or custom design patterns.
         */
    property bool altHeader : false

    /**
         * @brief If the header bar should autohide under certain given condition.
         * To fine tune a enter/exit threshold, a margin can be set, and a time delay.
         */
    property bool autoHideHeader : false

    /**
         * @brief If the footer bar should autohide under certain given condition.
         * To fine tune a enter/exit threshold, a margin can be set, and a time delay.
         */
    property bool autoHideFooter : false

    /**
         * @brief Size in pixels for the cursor enter/exit threshold for when the header should autohide.
         * The default value is set to `Style.toolBarHeight`.
         */
    property int autoHideHeaderMargins : Maui.Style.toolBarHeight

    /**
         * @brief Size in pixels for the cursor enter/exit threshold for when the footer should autohide.
         * The default value is set to `Style.toolBarHeight`.
         */
    property int autoHideFooterMargins : Maui.Style.toolBarHeight

    /**
         * @brief Span of time to hide the footer bar after the conditions have been met.
         * If within the span of time the conditions changed then the timer gets reseted.
         */
    property int autoHideFooterDelay : Maui.Handy.isTouch ? 0 : 800

    /**
         * @brief Span of time to hide the header bar after the conditions have been met.
         * If within the span of time the conditions changed then the timer gets reseted.
         */
    property int autoHideHeaderDelay : Maui.Handy.isTouch ? 0 : 800


    /**
         * @brief If the header bar should float over the page contents, if set- then the default footer bar will have a translucent `ShaderEffect` to hint about the content under it.
         */
    property bool floatingHeader : false

    /**
         * @brief If the footer bar should float over the page contents, if a flickable has been set then the default footer bar will have a translucent `ShaderEffect`
         * to hint about the content under it.
         */
    property bool floatingFooter: false

    property bool interactive : false
    readonly property alias translateY : _private.translateY
    readonly property alias pulling : _dragHandler.active

    /**
         * @brief Emitted when the user has requested to go back by a gesture or keyboard shortcut.
         */
    signal goBackTriggered()

    /**
         * @brief Emitted when the user has requested to go forward by a gesture or keyboard shortcut.
         */
    signal goForwardTriggered()

    signal pulled(var distance, var velocity)

    QtObject
    {
        id: _private
        readonly property int headerTotalHeight : _headerContent.visibleChildren.length > 0 ? (control.floatingHeader ? 0 : _headerContent.implicitHeight + _headerContent.topMargin + _headerContent.bottomMargin) : 0
        readonly property int footerTotalHeight : _footerContent.visibleChildren.length > 0 ? (control.floatingFooter ? 0: _footerContent.implicitHeight +  _footerContent.topMargin + _footerContent.bottomMargin) : 0

        readonly property int topMargin : (control.altHeader ? 0 : headerTotalHeight) + control.topMargin
        readonly property int bottomMargin: ((control.altHeader ? headerTotalHeight + footerTotalHeight : footerTotalHeight)) + control.bottomMargin

        property int translateY : 0

    }

    onFlickableChanged:
    {
        returnToBounds()
    }

    Binding
    {
        when:  control.floatingFooter && _footerContent.implicitHeight > 0
        target: control.flickable
        property: "bottomMargin"
        value: _footerContent.implicitHeight+control.footerMargins
        restoreMode: Binding.RestoreBindingOrValue
    }

    Binding
    {
        when:  control.floatingHeader && _headerContent.implicitHeight > 0
        target: control.flickable
        property: "topMargin"
        value: _headerContent.implicitHeight+control.headerMargins*2
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

                if (!control.header.pullBack || control.flickable.atYBeginning )
                {
                    control.header.pullBack =  false

                } else
                {
                    control.header.pullBack = true
                }
            }

            if (control.footer && control.footer.visible && control.footerPositioning === ListView.PullBackFooter)
            {
                _footerAnimation.enabled = true

                if (!control.footer.pullBack ||  control.flickable.atYEnd)
                {
                    if(control.flickable.atYEnd)
                    {
                        control.footer.pullBack =  false

                        control.flickable.contentY = control.flickable.contentHeight - control.flickable.height
                        oldContentY = control.flickable.contentY
                    }else
                    {
                        control.footer.pullBack = true

                    }

                } else
                {
                    control.footer.pullBack = true
                }
            }
        }
    }

    /**
         * @brief The main single header bar.
         * By default this header is set to a MauiKit ToolBar, but it can be changed to any other item.
         * @see ToolBar
         */
    property Item header : Maui.ToolBar
    {
        id: _headBar
        property bool pullBack: false
        visible: count > 0
        width: _headerContent.width
        position: control.altHeader ? ToolBar.Footer : ToolBar.Header
        Maui.Controls.showCSD: control.Maui.Controls.showCSD && control.Maui.Controls.showCSD === true && !control.altHeader
        Maui.Controls.level: control.Maui.Controls.level
        Maui.Controls.flat: control.Maui.Controls.flat

        background: Rectangle
        {
            id: _headerBg
            color: Maui.Theme.backgroundColor
            radius: control.headerMargins > 0 ? Maui.Style.radiusV : 0
            border.color: control.headerMargins > 0 ? Maui.Theme.alternateBackgroundColor : "transparent"

            border.pixelAligned :false
            antialiasing: true

            Item
    {
        id: _handleItem
        visible: control.interactive
        anchors.fill: parent
        // color: "red"

        Rectangle
        {
            width: _dragHandler.active  ? 100 : 60
            height: 4
            radius: 6
            anchors.margins: 2
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            color: _dragHandler.active ? Maui.Theme.highlightColor : Maui.Theme.textColor
        }

        DragHandler
        {
            id: _dragHandler
            enabled: control.interactive
            yAxis.enabled: true
            xAxis.enabled: false
            target: null
            property int position : 0
            readonly property int value : activeTranslation.y
            property int distance : 0
            acceptedPointerTypes: PointerDevice.Finger
             acceptedDevices: PointerDevice.TouchScreen
            // grabPermissions: PointerHandler.ApprovesTakeOverByItems

            onValueChanged:
            {
                if(!active || value<0)
                    return

                    distance = value
                    _private.translateY = 0+distance
            }

            onActiveChanged:
            {
                if(!active)
                {
                    control.pulled(value, centroid.velocity.y)
                    _private.translateY = 0

                }
            }
        }
    }

            ShaderEffectSource
            {
                id: _effect
                anchors.fill: parent
                visible: false
                textureSize: Qt.size(_headBar.width, _headBar.height)
                sourceItem: _parentContainer
                sourceRect: control.altHeader ? _headBar.mapToItem(_parentContainer, Qt.rect(_headBar.x, _headBar.y, _headBar.width, _headBar.height)) : _headBar.mapToItem(_parentContainer, Qt.rect(_headBar.x, _headBar.y, _headBar.width, _headBar.height))
            }

            Loader
            {
                asynchronous: true
                active: Maui.Style.enableEffects && GraphicsInfo.api !== GraphicsInfo.Software
                anchors.fill: parent
                sourceComponent: MultiEffect
                {
                    opacity: 0.2
                    saturation: -0.5
                    blurEnabled: true
                    blurMax: 32
                    blur: 1.0

                    autoPaddingEnabled: false
                    source: _effect
                }
            }

            layer.enabled: _headerBg.radius > 0 &&  GraphicsInfo.api !== GraphicsInfo.Software
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
                        width: _headerBg.width
                        height: _headerBg.height
                        radius: _headerBg.radius
                    }
                }
            }
        }

        transform: Translate
        {
            y: _headBar.pullBack ? -_headBar.implicitHeight : 0

            Behavior on y
            {
                id: _headerAnimation
                enabled: true
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: _headBar.pullBack ?Easing.OutBack: Easing.InBack
                }
            }
        }


        Component
        {
            id: _titleComponent

            Label
            {
                id: _titleLabel
                text: control.title
                elide : Text.ElideRight
                // font: Maui.Style.h2Font
                horizontalAlignment : Text.AlignHCenter
                verticalAlignment :  Text.AlignVCenter
            }
        }

        middleContent: Loader
        {
            visible: item
            active: control.title && control.showTitle
            sourceComponent: _titleComponent

            asynchronous: true

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: 200
            Layout.alignment: Qt.AlignCenter
        }
    }

    /**
         * @brief The main single footer bar.
         * By default this footer is set to a MauiKit ToolBar, but it can be changed to any other item.
         * @see ToolBar
         */
    property Item footer : Maui.ToolBar
    {
        id: _footBar
        property bool pullBack: false

        visible: count > 0
        width: _footerContent.width

        position: ToolBar.Footer

        background: Rectangle
        {
            id:_footerBg
            color: Maui.Theme.backgroundColor
            radius: control.footerMargins > 0 ? Maui.Style.radiusV : 0
            border.color: control.footerMargins > 0 ? Maui.Theme.alternateBackgroundColor : "transparent"
            border.pixelAligned :false
            antialiasing: true

            ShaderEffectSource
            {
                id: _footerEffect
                anchors.fill: parent
                visible: false
                // recursive: true
                textureSize: Qt.size(_footBar.width, _footBar.height)
                sourceItem: _parentContainer
                sourceRect: Qt.rect(_footerContent.x, _footerContent.y, _footBar.width, _footBar.height)
                // sourceRect: _parentContainer.mapFromItem(_footBar, Qt.rect(_footBar.x, _footBar.y, _footBar.width, _footBar.height))

            }

            Loader
            {
                asynchronous: true
                active: Maui.Style.enableEffects && GraphicsInfo.api !== GraphicsInfo.Software
                anchors.fill: parent
                sourceComponent: MultiEffect
                {
                    opacity: 0.2
                    saturation: -0.5
                    blurEnabled: true
                    blurMax: 32
                    blur: 1.0

                    autoPaddingEnabled: true
                    source: _footerEffect
                }
            }

            layer.enabled: _footerBg.radius > 0 &&  GraphicsInfo.api !== GraphicsInfo.Software
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
                        width: _footerBg.width
                        height: _footerBg.height
                        radius: _footerBg.radius
                    }
                }
            }
        }

        transform: Translate
        {
            y: _footBar.pullBack ? _footBar.implicitHeight : 0

            Behavior on y
            {
                id: _footerAnimation
                // enabled: false
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                     easing.type: _footBar.pullBack ?Easing.OutBack: Easing.InBack
                }
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

            // PropertyChanges
            // {
            //     target: _headerContent
            //     data: {
            //         _headerContent.data = data.reverse()
            //     }
            // }
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

            // PropertyChanges
            // {
            //     target: _headerContent
            //     data: {
            //         var data = []
            //         data = _headerContent.data
            //         _headerContent.data = data.reverse()
            //     }
            // }
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

    onAltHeaderChanged:
    {
        pullDownHeader()
    }


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
        transform: Translate
        {
            y: _private.translateY
        }

        Item
        {
            anchors.fill: parent
            id: _parentContainer

            Item
            {
                id: _content
                focus: true
                objectName: "Page Content Item"

                anchors.fill: parent

                anchors.topMargin: _private.topMargin
                anchors.bottomMargin: _private.bottomMargin

                anchors.leftMargin: control.leftMargin
                anchors.rightMargin: control.rightMargin
            }
        }


        Loader
        {
            active: control.Maui.Controls.showCSD === true && control.altHeader && !Maui.Handy.isMobile
            asynchronous: true
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: control.headerMargins
            sourceComponent: Maui.ToolBar
            {

                Maui.Controls.showCSD: true
                background: Rectangle
                {
                    radius: control.headerMargins > 0 ?  Maui.Style.radiusV : 0
                    Maui.Theme.colorSet: control.Maui.Theme.colorSet
                    Maui.Theme.inherit: false
                    opacity: 0.8
                    scale: -1 //for mirroring
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Maui.Theme.backgroundColor }
                        GradientStop { position: 0.33; color: "transparent" }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
            }
        }

        component ViewColumn : Column
        {
            property int margins : 0
            property int leftMargin: margins
            property int rightMargin: margins
            property int topMargin: margins
            property int bottomMargin: margins
        }

        ViewColumn
        {
            id: _headerContent
            spacing: margins
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: margins
            anchors.topMargin: topMargin
            anchors.bottomMargin: bottomMargin
            anchors.leftMargin: leftMargin
            anchors.rightMargin: rightMargin
        }


        ViewColumn
        {
            id: _footerContent
            spacing: margins
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: margins
            anchors.topMargin: topMargin
            anchors.bottomMargin: bottomMargin
            anchors.leftMargin: leftMargin
            anchors.rightMargin: rightMargin

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

                onPressed: (mouse) =>
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
                            if(!header.pullBack)
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
                            if(!footer.pullBack)
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

                onPressed: (mouse) =>
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
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    // cursorShape: Qt.PointingHandCursor
                    blocking: true
                    // grabPermissions: PointerHandler.CanTakeOverFromAnything
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
            z: _content.z + 1
            active: control.autoHideFooter && !control.altHeader && !Maui.Handy.isTouch

            sourceComponent: Item
            {
                HoverHandler
                {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    blocking: true

                    onHoveredChanged:
                    {                    console.log("Hovered footer changed", hovered)

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

    Component.onCompleted :
    {
        if(footer)
        {
            let fdata = [footer] //ordering the headers for the main headBar to always be the first/top in the column

            for(var i in _footerContent.data)
            {
                fdata.push(_footerContent.data[i])
            }
            _footerContent.data = fdata
        }

        if(header)
        {
            let data = [header] //ordering the headers for the main headBar to always be the first/top in the column

            for(var i in _headerContent.data)
            {
                data.push(_headerContent.data[i])
            }

            // if(control.altHeader)
            //     data.reverse()
            _headerContent.data = data
        }
    }

    /**
         * @brief If the header or footer are hidden, invoking this method will make them show again
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

    /**
         * @brief Forces the header to be hidden by pulling it back
         */
    function pullBackHeader()
    {
        // _headerAnimation.enabled = true
        header.pullBack = true
    }

    /**
         * @brief Forces the header to be shown by pulling it back in place
         */
    function pullDownHeader()
    {
        // _headerAnimation.enabled = true
        header.pullBack = false
    }

    /**
         * @brief Forces the footer to be hidden by pulling it back
         */
    function pullBackFooter()
    {
        // _footerAnimation.enabled = true
        footer.pullBack = true
    }

    /**
         * @brief Forces the footer to be shown by pulling it back in place
         */
    function pullDownFooter()
    {
        // _footerAnimation.enabled = true
        footer.pullBack = false
    }
}
