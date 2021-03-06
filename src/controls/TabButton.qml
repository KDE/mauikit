
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

/**
 * TabButton
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
TabButton
{
    id: control
    implicitWidth: 200
    

    property alias content: _content.data

    property alias closeButtonVisible: _closeButton.visible
    property bool centerLabel : true

    /**
         * closeClicked :
         */
    signal closeClicked()
    signal rightClicked(var mouse)

    Kirigami.Separator
    {
        color: Kirigami.Theme.highlightColor
        height: 2
        visible: checked
        anchors
        {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    background: null

    contentItem: RowLayout
    {
        id: _content

        Maui.CloseButton
        {
            id: _closeButton

            opacity: Kirigami.Settings.isMobile ? 1 : (control.hovered || control.checked ? 1 : 0)

            implicitWidth: height
            Layout.fillHeight: true

            onClicked: control.closeClicked()
            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }

        }

        Label
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: control.text
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            color: control.checked ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
            wrapMode: Text.NoWrap
            elide: Text.ElideMiddle
        }
        
        Item
        {
            Layout.fillHeight: true
            implicitWidth: height
            visible: _closeButton.visible && control.centerLabel
        }
    }
    
    MouseArea
    {
        anchors.fill: parent
        acceptedButtons:  Qt.RightButton
        
        onClicked:
        {
            if(mouse.button === Qt.RightButton)
            {
                control.rightClicked(mouse)
            }          
        }
    }
}

