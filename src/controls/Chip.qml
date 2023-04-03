import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui

/*!
 \ since org.mauikit.controls.*labs 1.0
 \inqmlmodule org.mauikit.controls.labs
 */
T.ItemDelegate
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Tooltip 
    
    hoverEnabled: !Maui.Handy.isMobile
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.medium
    
    icon.height: Maui.Style.iconSizes.small
    icon.width: Maui.Style.iconSizes.small

    property alias label : _label1
    property alias iconSource : control.icon.name
    
    property bool showCloseButton : false
    
    property color color : Maui.Theme.backgroundColor
    
    ToolTip.visible: hovered &&  ToolTip.text.length > 0
    
    signal close()
    
    background: Rectangle
    {
        id: _background
        //         opacity: 0.5
        
        color:  control.checked ? Maui.Theme.highlightColor : (control.pressed ? Qt.darker(control.color) : (control.hovered ? Qt.lighter(control.color): control.color))
        radius:  Maui.Style.radiusV   
    }
    
    contentItem: RowLayout
    {
        id: _layout
        spacing: control.spacing        

            Maui.Icon
            {

                id: _icon
                visible: valid
                implicitWidth: control.icon.width
                implicitHeight: control.icon.height
                color: _label1.color
                source: control.icon.name
            }            

        
        Label
        {
            id: _label1
            text: control.text
            Layout.fillHeight: true
            Layout.fillWidth: true
            verticalAlignment: Qt.AlignVCenter
            color: Maui.ColorUtils.brightnessForColor(_background.color) === Maui.ColorUtils.Light ? "#333" :"#fafafa"
            wrapMode: Text.Wrap
        }
        
        Loader
        {
            active: control.showCloseButton
            visible: active
            
            asynchronous: true
            
          Layout.fillHeight: true
            
            Layout.alignment: Qt.AlignRight
            
            sourceComponent: MouseArea
            {
                hoverEnabled: true
                implicitHeight: Maui.Style.iconSizes.medium
                implicitWidth: visible ? Maui.Style.iconSizes.medium : 0
                onClicked: control.close()
                
                Maui.X
                {
                    height: Maui.Style.iconSizes.tiny
                    width: height
                    anchors.centerIn: parent
                    color: parent.containsMouse || parent.containsPress ? Maui.Theme.negativeTextColor : _label1.color
                }
            }
        }     
    }
}
