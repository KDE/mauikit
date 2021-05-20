import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

MouseArea {
    id: control

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    
    implicitHeight: Maui.Style.iconSizes.medium
    implicitWidth: implicitHeight
    
    property bool checked : false

    signal toggled(bool state)

    onClicked:
    {
        control.checked = !control.checked
        control.toggled(control.checked)
    }
    
    Rectangle
    {
        anchors.fill: parent
        color: control.checked ? Kirigami.Theme.highlightColor : Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.5)
        radius: height/2
        border.color: Kirigami.Theme.highlightedTextColor
        
        Kirigami.Icon
        {
            visible: opacity > 0
            color: Kirigami.Theme.highlightedTextColor
            anchors.centerIn: parent
            height: control.checked ? Math.round(parent.height * 0.9) : 0
            width: height
            opacity: control.checked ? 1 : 0
            isMask: true
            
            source: "qrc:/assets/checkmark.svg"
            
            Behavior on opacity
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }     
}
