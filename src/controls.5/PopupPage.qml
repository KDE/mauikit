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

import QtQuick 2.14

import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import QtGraphicalEffects 1.0

/*!
 * \since org.mauikit.controls 1.0
 * \inqmlmodule org.mauikit.controls
 *
 * A scrollable dialog popup, with a Page as its main content.
 * With default buttons styled, a close button and a predefiend layout.
 *
 * The dialog can be used with its main default ColumnLayout or with an Item stacked.
 *
 * The dialog contents will be hanlded by a ColumnLayout, so the positioning of its child elements should use the attached property
 * Layout.fillheight layout.fillWidth, etc.
 */
Popup
{
    id: control

    focus: true

    Maui.Theme.colorSet: Maui.Theme.Window
    Maui.Theme.inherit: false

    closePolicy: control.persistent ? Popup.NoAutoClose | Popup.CloseOnEscape : Popup.CloseOnEscape | Popup.CloseOnPressOutside

    maxWidth: 300
    maxHeight: implicitHeight
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding + topMargin + bottomMargin

    hint: 0.9
    heightHint: 0.9
    spacing: Maui.Style.space.big

    filling: persistent && mWidth === control.parent.width
    /*!
   *    \qmlproperty list<Item> ApplicationWindow::scrollable
   *
   *    Default content will be added to a scrollable ColumnLayout.
   *    When adding a item keep on mind that to correctly have the scrollable behavior
   *    the item must have an implicit height. And the positioning should be done via the Layout attached properties.
   */
    default property alias scrollable : _scrollView.content

    /*!
     *    \qmlproperty list<Item> ApplicationWindow::stack
     *
     *    To skip the scrollable behavior there is a stacked component to which items can be added, this is also
     *    controlled by a ColumnLayout
     */
    property alias stack : _stack.data

    /*!
     *    \qmlproperty string ApplicationWindow::title
     *
     *    Default title text or title of the dialog page.
     */
    property alias title : _page.title

    /*!
     *    \qmlproperty bool ApplicationWindow::persistent
     *
     *    If the dialog should be closed when it loses focus or not.
     *    If it is marked as persistent a close button is shown in the header bar, other wise the header bar is
     *    hidden if there is not more elements on it.
     */
    property bool persistent : true

    /*!
     *    \qmlproperty Page ApplicationWindow::page
     *
     *    Access to the default dialog content.
     */
    property alias page : _page

    /*!
     *    \qmlproperty ToolBar ApplicationWindow::footBar
     *
     *    Dialog footer bar.
     */
    property alias footBar : _page.footBar

    /*!
     *    \qmlproperty ToolBar ApplicationWindow::headBar
     *
     *    Dialog header bar.
     */
    property alias headBar: _page.headBar

    /*!
     *    \qmlproperty bool closeButton
     *
     *    MouseArea for the close button when the dialog is marked as persistent.
     */
    property bool closeButtonVisible: control.persistent

    /*!
     *    \qmlproperty Flickable Dialog::closeButton
     *
     *    MouseArea for the close button when the dialog is marked as persistent.
     */
    property alias flickable : _scrollView.flickable

    /*!
     *    \qmlproperty ScrollView Dialog::scrollView
     *
     *    MouseArea for the close button when the dialog is marked as persistent.
     */
    property alias scrollView : _scrollView

    /*!
     *    \qmlproperty int ScrollBar::policy
     *
     *    MouseArea for the close button when the dialog is marked as persistent.
     */
    property int verticalScrollBarPolicy: ScrollBar.AsNeeded


    /*!
     *    \qmlproperty int ScrollBar::policy
     *
     *    MouseArea for the close button when the dialog is marked as persistent.
     */
    property int horizontalScrollBarPolicy: ScrollBar.AlwaysOff

    property bool autoClose : true

    /*!
     *    List of actions to be added to the dialog footer bar as styled buttons.
     */
    property list<Action> actions

    property alias actionBar : _defaultButtonsLayout

    /*!
     * Triggered when the accepted button is clicked.
     */
    signal accepted()

    /*!
     * Triggered when the rejected button is clicked.
     */
    signal rejected()

    signal closeTriggered()

    ColumnLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: 0

        Maui.Page
        {
            id: _page

            clip: true

            Maui.Theme.colorSet: control.Maui.Theme.colorSet

            Layout.fillWidth: true
            Layout.fillHeight: true

            implicitHeight: Math.max(_scrollView.contentHeight + _scrollView.topPadding + _scrollView.bottomPadding, _stack.implicitHeight) + _page.footerContainer.implicitHeight + (_page.topPadding + _page.bottomPadding) + _page.headerContainer.implicitHeight + (_page.topMargin + _page.bottomMargin)

            headerPositioning: ListView.InlineHeader

            padding: 0
            margins: 0

            headBar.visible: control.persistent
            headBar.borderVisible: false

            background: null

            headBar.farRightContent: Loader
            {
                asynchronous: true
                visible: active
                active: control.persistent && closeButtonVisible

                sourceComponent: Maui.CloseButton
                {
                    onClicked:
                    {
                        if(control.autoClose)
                        {
                            control.close()
                        }else
                        {
                            control.closeTriggered()
                        }
                    }
                }
            }

            ColumnLayout
            {
                id: _stack

                anchors.fill: parent

                spacing: control.spacing
            }

            Maui.ScrollColumn
            {
                id: _scrollView

                anchors.fill: parent

                visible: _stack.children.length === 0

                spacing: control.spacing
                padding: Maui.Style.space.big

                ScrollBar.horizontal.policy: control.horizontalScrollBarPolicy
                ScrollBar.vertical.policy: control.verticalScrollBarPolicy
            }
        }

        GridLayout
        {
            id: _defaultButtonsLayout

            rowSpacing: Maui.Style.space.small
            columnSpacing: Maui.Style.space.small

            Layout.fillWidth: true
            Layout.margins: Maui.Style.contentMargins

            property bool isWide : control.width > Maui.Style.units.gridUnit*10

            visible: control.actions.length

            rows: isWide? 1 : _defaultButtonsLayout.children.length
            columns: isWide ? _defaultButtonsLayout.children.length : 1

            Repeater
            {
                model: control.actions

                Button
                {
                    id: _actionButton
                    focus: true
                    Layout.fillWidth: true

                    action: modelData
                }
            }
        }
    }
}
