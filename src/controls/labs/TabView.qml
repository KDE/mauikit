import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10

import QtGraphicalEffects 1.0

import org.kde.kirigami 2.13 as Kirigami
import org.kde.mauikit 1.3 as Maui

SwipeView
{
    id: control
    interactive: true
    clip: true
    focus: true

    property bool mobile : true
    property int tabBarPosition : TabBar.Header

    property url sourceUrl

    signal newTabClicked()

    contentItem: ColumnLayout
    {
        spacing: 0

        Maui.TabBar
        {
            id: tabsBar
            visible: control.count > 1 && !mobile
            Layout.fillWidth: true

            position: control.position

            currentIndex : control.currentIndex

            onNewTabClicked: control.newTabClicked()

            Keys.onPressed:
            {
                if(event.key == Qt.Key_Return)
                {
                    control.currentIndex = currentIndex
                }

                if(event.key == Qt.Key_Down)
                {
                    control.currentItem.forceActiveFocus()
                }
            }

            Repeater
            {
                id: _repeater
                model: control.count

                Maui.TabButton
                {
                    id: _tabButton
                    implicitHeight: tabsBar.implicitHeight
                    implicitWidth: Math.max(parent.width / _repeater.count, 160)
                    checked: index === control.currentIndex
                    text: control.contentModel.get(index).title

                    onClicked:
                    {
                        control.currentIndex = index
                    }

                    onCloseClicked: control.removeItem(control.takeIndex(index))

                    DropArea
                    {
                        id: _dropArea
                        anchors.fill: parent
                        onEntered: control.currentIndex = index
                    }
                }
            }
        }

        ListView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: control.contentModel

            interactive: control.interactive
            currentIndex: control.currentIndex
            spacing: control.spacing
            orientation: control.orientation
            snapMode: ListView.SnapOneItem
            boundsBehavior: Flickable.StopAtBounds

            preferredHighlightBegin: 0
            preferredHighlightEnd: width

            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 0
            highlightFollowsCurrentItem: true
            highlightResizeDuration: 0
            highlightMoveVelocity: -1
            highlightResizeVelocity: -1

            maximumFlickVelocity: 4 * (control.orientation === Qt.Horizontal ? width : height)

            Rectangle
            {
                id: _overview
                visible: _tabsOverview.checked
                anchors.fill: parent

                Kirigami.Theme.colorSet: Kirigami.Theme.Window
                Kirigami.Theme.inherit: false

                color: kirigami.Theme.backgroundColor

                Maui.GridView
                {
                    id: _overviewGrid
                    anchors.fill: parent
                    model: control.count
                    currentIndex: control.currentIndex
                    itemSize: width / 3
                    itemHeight:  (height / 3)

                    onAreaClicked: _tabsOverview.checked = false

                    delegate: Item
                    {
                        height: _overviewGrid.cellHeight
                        width: _overviewGrid.cellWidth

                        property bool isCurrentItem : GridView.isCurrentItem

                        Maui.GridBrowserDelegate
                        {
                            anchors.fill: parent
                            anchors.margins: Maui.Style.space.medium
                            iconSizeHint: height
                            isCurrentItem: parent.isCurrentItem
                            //                            label1.text: control.contentModel.get(index).title || index

                            onClicked:
                            {
                                control.currentIndex = index
                                _tabsOverview.checked = false
                            }

                            template.iconComponent: Rectangle
                            {
                                color: Kirigami.Theme.backgroundColor
                                radius: Maui.Style.radiusV

                                ShaderEffectSource
                                {
                                    id: _effect
                                    anchors.fill: parent
                                    anchors.margins: Maui.Style.space.tiny

                                    hideSource: visible
                                    live: true
                                    textureSize: Qt.size(width,height)
                                    sourceItem: control.contentModel.get(index)
                                    layer.enabled: true
                                    layer.effect: OpacityMask
                                    {
                                        maskSource: Item
                                        {
                                            width: control.width
                                            height: control.height
                                            Rectangle
                                            {
                                                anchors.fill: parent
                                                radius: Maui.Style.radiusV
                                            }
                                        }
                                    }
                                }

                                Rectangle
                                {
                                    height: parent.height * 0.2
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right

                                    Maui.Separator
                                    {
                                        edge: Qt.TopEdge
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                    }

                                    RowLayout
                                    {
                                        anchors.fill: parent

                                        Label
                                        {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            horizontalAlignment: Qt.AlignHCenter
                                            verticalAlignment: Qt.AlignVCenter
                                            text: control.contentModel.get(index).title || index
                                        }

                                        MouseArea
                                        {
                                            hoverEnabled: true
                                            onClicked: control.removeItem(control.takeItem(index))
                                            Layout.fillHeight: true
                                            implicitWidth: height

                                            opacity: Kirigami.Settings.isMobile ? 1 : (control.hovered || control.checked ? 1 : 0)
                                            Behavior on opacity
                                            {
                                                NumberAnimation
                                                {
                                                    duration: Kirigami.Units.longDuration
                                                    easing.type: Easing.InOutQuad
                                                }
                                            }

                                            Maui.X
                                            {
                                                height: Maui.Style.iconSizes.tiny
                                                width: height
                                                anchors.centerIn: parent
                                                color: parent.containsMouse || parent.containsPress ? Kirigami.Theme.negativeTextColor : Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
                                            }
                                        }
                                    }
                                }

                                Rectangle
                                {
                                    anchors.fill: parent
                                    border.color: isCurrentItem ? Kirigami.Theme.highlightColor : Qt.darker(Kirigami.Theme.backgroundColor, 2.2)
                                    radius: parent.radius

                                    border.width: isCurrentItem ? 2 : 1
                                    color: "transparent"
                                    opacity: 0.8

                                    Rectangle
                                    {
                                        anchors.fill: parent
                                        color: "transparent"
                                        anchors.margins: 1
                                        radius: parent.radius - 0.5
                                        border.color: Qt.lighter(Kirigami.Theme.backgroundColor, 2)
                                        opacity: 0.3
                                    }
                                }

                            }
                        }
                    }
                }
            }
        }


        Maui.ToolBar
        {
            visible: control.count > 1 && mobile
            position: ToolBar.Footer
            preferredHeight: Maui.Style.rowHeight + Maui.Style.space.tiny
            Layout.fillWidth: true
            middleContent: Maui.TabButton
            {
                Layout.fillWidth: true
                closeButtonVisible: control.count > 1
                text: control.currentItem.title
                onCloseClicked: control.removeItem(control.currentItem)
            }

            rightContent: [

                ToolButton
                {
                    id: _tabsOverview
                    checkable: true
                    icon.name: "tab"
                    text: control.count
                },
                ToolButton
                {
                    icon.name: "list-add"
                    onClicked: control.newTabClicked()
                }
            ]
        }
    }
}
