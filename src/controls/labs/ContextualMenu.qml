// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import QtQuick 2.10
import QtQuick.Layouts 1.10
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.10 as QQC2

import org.kde.mauikit 1.3 as Maui
import QtQuick.Window 2.15

QQC2.Container {
    id: control

    spacing: Maui.Style.space.medium


    contentItem: Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
        sourceComponent: Kirigami.Settings.isMobile && Kirigami.Settings.hasTransientTouchInput ? mobileMenu : regularMenu
        //sourceComponent: mobileMenu

    }

    Component {
        id: regularMenu

        QQC2.Menu {
            id: _menu
            //             contentData: control.contentData
            implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                    contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0)
            implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                     contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding

            margins: 0
            padding: 0
            //             verticalPadding: 8
            spacing: 0
            //             modal: true
            //transformOrigin: !cascade ? Item.Top : (mirrored ? Item.TopRight : Item.TopLeft)

            contentItem: ListView
            {
                id: _listView
                implicitHeight: contentHeight
                implicitWidth: {
                    var maxWidth = 0;
                    for (var i = 0; i < contentItem.children.length; ++i) {
                        maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
                    }
                    return maxWidth;
                }

                model: control.contentModel
                boundsBehavior: Flickable.StopAtBounds
                interactive: Window.window ? contentHeight > Window.window.height : false
                clip: true
                currentIndex: control.currentIndex || 0
                spacing: 0
                keyNavigationEnabled: true
                keyNavigationWraps: true

                QQC2.ScrollIndicator.vertical: QQC2.ScrollIndicator {}
            }
        }
    }

    Component {
        id: mobileMenu

        QQC2.Menu {
            x: 0
            y: window().height - height

            modal: true
            parent: window()

            width: window().width
            height:Math.min(window().height * 0.5, contentHeight)

            margins: 0

            delegate: QQC2.MenuItem { onImplicitWidthChanged: control.contentItem.contentItem.childrenChanged() }

            contentItem: ListView {
                implicitHeight: contentHeight
                property bool hasCheckables: false
                property bool hasIcons: false
                model: control.contentModel

                implicitWidth: {
                    var maxWidth = 0;
                    for (var i = 0; i < contentItem.children.length; ++i) {
                        maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
                    }
                    return maxWidth;
                }

                interactive: Window.window ? contentHeight > Window.window.height : false
                clip: true
                currentIndex: control.currentIndex || 0
                keyNavigationEnabled: true
                keyNavigationWraps: true

                QQC2.ScrollBar.vertical: QQC2.ScrollBar {}
            }


            background: Kirigami.ShadowedRectangle {
                radius: 2
                implicitWidth: Kirigami.Units.gridUnit * 8
                color: Kirigami.Theme.backgroundColor

                property color borderColor: Kirigami.Theme.textColor
                border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
                border.width: 1

                shadow.xOffset: 0
                shadow.yOffset: 2
                shadow.color: Qt.rgba(0, 0, 0, 0.3)
                shadow.size: 8
            }
        }
    }

    function open() {
        if (Kirigami.Settings.isMobile)
            _loader.item.open()
        else
            _loader.item.popup()
    }

    function close()
    {
        _loader.item.close()
    }
}

