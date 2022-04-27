import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.14 as Kirigami

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
T.ItemDelegate
{
    id: control

    hoverEnabled: !Kirigami.Settings.isMobile
    implicitHeight: Maui.Style.iconSizes.big
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    padding: spacing
    bottomPadding: padding
    rightPadding: padding
    leftPadding: padding
    topPadding: padding
    spacing: Maui.Style.space.medium
    
    property alias label : _label1
    property alias iconSource : _icon.source

    property bool showCloseButton : false
    
    property color color : control.Kirigami.Theme.backgroundColor

    ToolTip.visible: hovered
    ToolTip.text: label.text

    signal close()

    background: Rectangle
    {
        id: _background
//         opacity: 0.5
               
        color: Qt.lighter( control.pressed ? control.Kirigami.Theme.highlightColor : (control.hovered ? control.Kirigami.Theme.hoverColor : control.color))
        radius:  Maui.Style.radiusV         
    }

    contentItem: RowLayout
    {
        id: _layout
        spacing: control.spacing
        
        Item
        {
            visible: _icon.valid
            Layout.fillHeight: true
            Layout.preferredWidth: visible ? Maui.Style.iconSizes.medium : 0
            
            Kirigami.Icon
            {
                id: _icon
                anchors.centerIn: parent
                implicitWidth: Maui.Style.iconSizes.small
                implicitHeight: implicitWidth
                color: _label1.color
            }            
        }
    
        Label
        {
            id: _label1
            text: control.text
            Layout.fillHeight: true
            Layout.fillWidth: true
            verticalAlignment: Qt.AlignVCenter
            color: Kirigami.ColorUtils.brightnessForColor(_background.color) === Kirigami.ColorUtils.Light ? Qt.darker(_background.color) : Qt.lighter(_background.color)
        }

        Loader
        {
            active: control.showCloseButton
            visible: active
            
            asynchronous: true
            Layout.fillHeight: true
            Layout.preferredWidth: visible ? Maui.Style.iconSizes.medium : 0
            Layout.alignment: Qt.AlignRight
            
            sourceComponent: MouseArea
            {
                hoverEnabled: true
                
                onClicked: control.close()
                
                Maui.X
                {
                    height: Maui.Style.iconSizes.tiny
                    width: height
                    anchors.centerIn: parent
                    color: parent.containsMouse || parent.containsPress ? Kirigami.Theme.negativeTextColor : _label1.color
                }
            }
        }     
    }
}
