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
    property list<QtObject> middleContent : control.headBar.middleContent

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

    headBar.forceCenterMiddleContent: !control.split
    headBar.leftContent: !control.split && control.leftContent ? control.leftContent : null
    headBar.rightContent: !control.split && control.rightContent ? control.rightContent : null

    headBar.middleContent: control.middleContent ? control.middleContent : null

    headerColumn: Loader
    {
        active: control.splitIn === ToolBar.Header
        visible: control.split && control.splitIn === ToolBar.Header
        width: parent.width

        sourceComponent: Maui.ToolBar
        {
            id: _headBar
            Maui.Controls.level: control.Maui.Controls.level ?  control.Maui.Controls.level : Maui.Controls.Secondary
            leftContent: control.split && control.leftContent ? control.leftContent : null
            rightContent: control.split && control.rightContent ? control.rightContent : null

            Maui.Controls.item: ShaderEffectSource
            {
                sourceItem: control.pageContent
                sourceRect:  _headBar.background ?
                                 (control.floatingHeader ?
                                      Qt.rect(0, (_headBar.position === ToolBar.Header ? control.headBar.background.height :  control.pageContent.height - _headBar.background.height), _headBar.background.width, _headBar.background.height)
                                    : Qt.rect(0, (_headBar.position === ToolBar.Header ? 0 - (_headBar.background.height) :  control.pageContent.height), _headBar.background.width, _headBar.background.height))
                               : null
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
            leftContent: control.split && control.leftContent ? control.leftContent : null
            rightContent: control.split && control.rightContent ? control.rightContent : null
        }
    }
}
