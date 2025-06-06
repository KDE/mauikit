
import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
    * @inherit QtQuick.Controls.TabButton
    * @brief A expanded implementation of the QQC2 TabButton with a predefined horizontal layout.
    *
    * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-tabbutton.html">This control inherits from QQC2 TabButton, to checkout its inherited properties refer to the Qt Docs.</a>
    *
    * By default the layout of this control is divided into three sections.
    * Extra items can be appended to the left and right side areas, while the center area is reserved for the title text.
    * @see leftContent
    * @see rightContent
    */
QQC.TabButton
{
    id: control
    focus: false
    focusPolicy: Qt.NoFocus

    /**
        * @brief An alias exposed to append more elements into the main container of this control.
        * @property list<QtObject> TabButton::content
        */
    default property alias content: _content.data

    /**
        * @brief Use this to append items to the left area of this control.
        * @property list<QtObject> TabButton::leftContent
        */
    property alias leftContent: _leftContent.data

    /**
        * @brief Use this to append items to the right area of this control.
        * @property list<QtObject> TabButton::rightContent
        */
    property alias rightContent: _rightContent.data

    /**
        * @brief Use this to add items between the background and the control contents.
        * @property list<QtObject> TabButton::underlayContent
        */
    property alias underlayContent: _underlay.data

    /**
        * @brief Whether a close button should be shown in the far left area.
        * If it is visible and pressed, a signal is emitted.
        * @see closeClicked
        * By default this is set to `true`.
        */
    property bool closeButtonVisible: true

    /**
        * @brief Emitted when the close button is pressed.
        * @see closeButtonVisible
        */
    signal closeClicked()

    /**
        * @brief Emitted when the area of the control has been right clicked.
        * This can be consumed in order to open a contextual menu, for example.
        * @param mouse The object with information of the event.
        */
    signal rightClicked(var mouse)

    contentItem: MouseArea
    {
        implicitWidth: _layout.implicitWidth
        implicitHeight: _layout.implicitHeight

        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        preventStealing: false

        onClicked: (mouse) =>
        {
            if(mouse.button === Qt.RightButton)
            {
                control.rightClicked(mouse)
            }

            mouse.accepted = false
        }

        Item
        {
            id: _underlay
            anchors.fill: parent
        }

        RowLayout
        {
            id: _layout
            anchors.fill: parent
            anchors.rightMargin: _badgeLoader.visible ? 8 : 0

            spacing: control.spacing

            Row
            {
                id: _leftContent
            }

            Maui.IconLabel
            {
                id: _content
                Layout.fillWidth: true
                Layout.fillHeight: true
                opacity: control.checked || control.hovered ? 1 : 0.7

                text: control.text
                icon: control.icon
                color: control.Maui.Theme.textColor
                alignment: Qt.AlignHCenter
                display: QQC.ToolButton.TextBesideIcon
                font: control.font
            }

            Row
            {
                id: _rightContent
            }

            Loader
            {
                asynchronous: true
                active: control.closeButtonVisible

                Layout.alignment: Qt.AlignCenter

                sourceComponent: Maui.CloseButton
                {
                    opacity: Maui.Handy.isMobile ? 1 : (control.hovered || control.checked ? 1 : 0)
                    padding: 0

                    implicitHeight: 16
                    implicitWidth: 16

                    icon.width: 16
                    icon.height: 16

                    onClicked: control.closeClicked()

                    Behavior on opacity
                    {
                        NumberAnimation
                        {
                            duration: Maui.Style.units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }

    Loader
    {
        id: _badgeLoader

        asynchronous: true

        active: control.Maui.Controls.badgeText && control.Maui.Controls.badgeText.length > 0 && control.visible
        visible: active

        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenterOffset: -5

        sourceComponent: Maui.Badge
        {
            text: control.Maui.Controls.badgeText

            padding: 2
            font.pointSize: Maui.Style.fontSizes.tiny

            Maui.Controls.status: Maui.Controls.Negative

            OpacityAnimator on opacity
            {
                from: 0
                to: 1
                duration: Maui.Style.units.longDuration
                running: parent.visible
            }

            ScaleAnimator on scale
            {
                from: 0.5
                to: 1
                duration: Maui.Style.units.longDuration
                running: parent.visible
                easing.type: Easing.OutInQuad
            }
        }
    }
}

