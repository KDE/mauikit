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
 * @inherit Page
 * @brief A MauiKit Page with a toolbar bar content that is dynamically split onto two bars upon request.
 * This control inherits from MauiKit Page, to checkout its inherited properties refer to docs.
 *
 * The default header for the Page is set to MauiKit ToolBar, which is divided into three main sections; the left and right side section are the one that can be wrapped into another tool bar when requested - for example, due to space constrains.
 * To know more see the ToolBar documentation.
 * @see ToolBar
 * @see Page
 *
 * For it to work just populate the left and right side sections. And then set a constrain check on the `split` property.
 * When it is set to `split: true`, the left and right side contents will be moved to a new tool bar under the main header.
 * @see leftContent
 * @see middleContent
 * @see rightContent
 *
 * @image html Misc/pagelayout.png
 *
 * @warning It is important to not change the `header` to a different control. PageLayout depends on MauiKit ToolBar being used.
 *
 * If it is desired to keep any controls from moving out of the main header, use the `farLeftContent` and/or `farRightContent` properties for placing such items, that will insure those items will stay always in place.
 *
 * @code
 * Maui.PageLayout
 * {
 *    id: _page
 *
 *    anchors.fill: parent
 *    Maui.Controls.showCSD: true
 *
 *    split: width < 600
 *    leftContent: [Switch
 *        {
 *            text: "Hello"
 *        },
 *
 *        Button
 *        {
 *            text: "Button"
 *        }
 *    ]
 *
 *    rightContent: Rectangle
 *    {
 *        height: 40
 *        implicitWidth: 60
 *        color: "gray"
 *    }
 *
 *    middleContent: Rectangle
 *    {
 *        implicitHeight: 40
 *        implicitWidth: 60
 *        Layout.alignment: Qt.AlignHCenter
 *        Layout.fillWidth: _page.split
 *        color: "yellow"
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/PageLayout.qml">You can find a more complete example at this link.</a>
 */
Maui.Page
{
    id: control

    /**
     * @brief The toolbar left side content.
     * This content will be wrapped into a secondary tool bar under the header.
     */
    property list<QtObject> leftContent

    /**
     * @brief The toolbar bar right side content.
     * This content will be wrapped into a secondary tool bar under the header.
     */
    property list<QtObject> rightContent

    /**
     * @brief The toolbar middle content.
     * This elements will not be wrapped and will stay in place.
     * @note The contents are placed using a RowLayout, so use the layout attached properties accordingly.
     */
    property list<QtObject> middleContent

    /**
     * @brief Whether the toolbar content should be wrapped - as in split - into a new secondary toolbar.
     * By default this is set to `false`.
     * @note You can bind this to some space constrain condition.
     */
    property bool split : false

    /**
     * @brief Where the left and right content will be moved, either to the header or the footer. The available options are `ToolBar.Header` or `ToolBar.Footer`
     * By default it is se to `ToolBar.Header`
     */
    property int splitIn : ToolBar.Header

    enum Section
    {
        Left, Right, Middle, Sides
    }

    property int splitSection : PageLayout.Section.Sides

    headBar.forceCenterMiddleContent: !control.split

    headBar.leftContent:
    {
        if(!control.leftContent)
            return null

        if(control.split)
        {
            if(control.splitSection === PageLayout.Section.Middle
                    || control.splitSection === PageLayout.Section.Right)
            {
                return control.leftContent
            }else return null
        }
        return control.leftContent
    }

    headBar.rightContent:
    {
        if(!control.rightContent)
            return null

        if(control.split)
        {
            if(control.splitSection === PageLayout.Section.Middle
                    || control.splitSection === PageLayout.Section.Left)
            {
                return control.rightContent
            }else return null
        }
        return control.rightContent
    }


    headBar.middleContent:
    {
        if(!control.middleContent)
            return null

        if(control.split)
        {
            if(control.splitSection !== PageLayout.Section.Middle)
            {
                return control.middleContent
            }else return null
        }
        return control.middleContent
    }

    headerColumn: Loader
    {
        active: control.splitIn === ToolBar.Header
        visible: control.split && control.splitIn === ToolBar.Header
        width: parent.width

        sourceComponent: Maui.ToolBar
        {
            id: _headBar
            Maui.Controls.level: control.Maui.Controls.level ? control.Maui.Controls.level : Maui.Controls.Secondary
            leftContent: control.split && control.leftContent && (control.splitSection === PageLayout.Section.Left || control.splitSection === PageLayout.Section.Sides) ? control.leftContent : null
            rightContent: control.split && control.rightContent && (control.splitSection === PageLayout.Section.Right || control.splitSection === PageLayout.Section.Sides) ? control.rightContent : null
            middleContent: control.split && control.middleContent && (control.splitSection === PageLayout.Section.Middle) ? control.middleContent : null

            background: Rectangle
            {
                id:_headerBg
                color: Maui.Theme.backgroundColor
                radius: control.headerMargins > 0 ? Maui.Style.radiusV : 0

                ShaderEffectSource
                {
                    id: _effect
                    anchors.fill: parent
                    visible: false
                    textureSize: Qt.size(_headBar.width, _headBar.height)
                    sourceItem:  control.pageContent
                    sourceRect: _headBar.mapToItem(control.pageContent, Qt.rect(_headBar.x, _headBar.y, _headBar.width, _headBar.height))
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
        }
    }

    footerColumn: Loader
    {
        active: control.splitIn === ToolBar.Footer
        visible: control.split && control.splitIn === ToolBar.Footer
        width: parent.width

        sourceComponent: Maui.ToolBar
        {
            id: _footBar
            leftContent: control.split && control.leftContent && (control.splitSection === PageLayout.Section.Left || control.splitSection === PageLayout.Section.Sides) ? control.leftContent : null
            rightContent: control.split && control.rightContent && (control.splitSection === PageLayout.Section.Right || control.splitSection === PageLayout.Section.Sides) ? control.rightContent : null
            middleContent: control.split && control.middleContent && (control.splitSection === PageLayout.Section.Middle) ? control.middleContent : null

            background: Rectangle
            {
                id:_footerBg
                color: Maui.Theme.backgroundColor
                radius: control.footerMargins > 0 ? Maui.Style.radiusV : 0

                ShaderEffectSource
                {
                    id: _footerEffect
                    anchors.fill: parent
                    visible: false
                    textureSize: Qt.size(_footBar.width, _footBar.height)
                    sourceItem: control.pageContent
                    // sourceRect: Qt.rect(_footerContent.x, _footerContent.y, _footBar.width, _footBar.height)
                    sourceRect: _footBar.mapToItem(control.pageContent, Qt.rect(_footBar.x, _footBar.y, _footBar.width, _footBar.height))
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
        }
    }
}
