import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.7 as Kirigami

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
ItemDelegate
{
    id: control

    hoverEnabled: !Kirigami.Settings.isMobile
    implicitHeight: Maui.Style.iconSizes.big
    implicitWidth: _layout.implicitWidth + Maui.Style.space.big

    property alias label : _label1
    property alias iconSource : _icon.source

    property bool showCloseButton : false

    ToolTip.visible: hovered
    ToolTip.text: label.text

    signal close()

    background: Rectangle
    {
        id: _background
        radius: Maui.Style.radiusV
        opacity: 0.5
        color: Qt.darker(control.Kirigami.Theme.backgroundColor, 1.1)
    }

    RowLayout
    {
        id: _layout
        height: parent.height
        anchors.centerIn: parent
        spacing: Maui.Style.space.medium
        
        Item
        {
            visible: !_icon.valid
            Layout.fillHeight: true
        }
        
        Item
        {
            visible: _icon.valid
            Layout.fillHeight: true
            implicitWidth: visible ? Maui.Style.iconSizes.medium : 0
            
            Kirigami.Icon
            {
                id: _icon
                anchors.centerIn: parent
                implicitWidth: Maui.Style.iconSizes.small
                implicitHeight: implicitWidth
                color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(_background.color.r, _background.color.g, _background.color.b, control.hovered ?  0.4 : 0.7))
            }            
        }
    
        Label
        {
            id: _label1
            Layout.fillHeight: true
            verticalAlignment: Qt.AlignVCenter
            color: Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(_background.color.r, _background.color.g, _background.color.b, control.hovered ?  0.4 : 0.7))
        }

        MouseArea
        {
            id: _closeIcon
            visible: showCloseButton
            hoverEnabled: true

            Layout.fillHeight: true
            implicitWidth: Maui.Style.iconSizes.medium
            Layout.alignment: Qt.AlignRight
            onClicked: control.close()

            Maui.X
            {
                height: Maui.Style.iconSizes.tiny
                width: height
                anchors.centerIn: parent
                color: parent.containsMouse || parent.containsPress ? Kirigami.Theme.negativeTextColor : Qt.tint(control.Kirigami.Theme.textColor, Qt.rgba(_background.color.r, _background.color.g, _background.color.b, control.hovered ?  0.4 : 0.7))
            }
        }
        
        Item
        {
            visible: !showCloseButton
            Layout.fillHeight: true
        }
    }
}
