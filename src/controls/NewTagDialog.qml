import QtQuick 2.14
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.14
import org.kde.kirigami 2.2 as Kirigami
import org.kde.mauikit 1.3 as Maui

/**
 * NewTagDialog
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.Dialog
{
    id: control

    property string currentColor
    property var defaultColors : ["#4DD0E1", "#64B5F6", "#9575CD", "#F06292", "#81C784", "#DCE775", "#FFD54F", "#FF8A65", "#90A4AE"]

    entryField: true
    spacing: Maui.Style.space.big
    
    title: i18n("New tags")
    message: i18n("Create new tags to organize your files. You can create multiple tags separate by a comma.")

    closeButton.visible: false
    
    acceptButton.text: i18n("Add")
    rejectButton.text: i18n("Cancel")

    onAccepted: done()
    onRejected:
    {
        control.close()
    }

    page.margins: Maui.Style.space.big
    
    page.footerBackground.color: "transparent"
    footBar.leftContent: Repeater
    {
        model: control.defaultColors
        MouseArea
        {
            readonly property bool checked : control.currentColor === modelData
            implicitHeight: Maui.Style.iconSizes.medium
            implicitWidth: implicitHeight
            
            onClicked: control.currentColor = modelData
            
            Rectangle
            {
                anchors.fill: parent
                radius: height/2
                color: modelData             
                
                Kirigami.Icon
                {
                    visible: opacity > 0
                    color: "white"
                    anchors.centerIn: parent
                    height: checked ? Math.round(parent.height * 0.9) : 0
                    width: height
                    opacity: checked ? 1 : 0
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
    }
    
    Flow
    {
        visible: control.textEntry.text.length
        Layout.fillWidth: true
//         implicitHeight: Math.min(200, contentHeight) + Maui.Style.space.big
//         implicitHeight: Maui.Style.toolBarHeight * 1.2
//         orientation: ListView.Horizontal
        spacing: Maui.Style.space.medium
        
//         horizontalScrollBarPolicy: ScrollBar.AlwaysOff
        //snapMode: ListView.SnapOneItem
//         verticalScrollBarPolicy: ScrollBar.AlwaysOff        
        
        Repeater
        {
            model: textEntry.text.split(",")
            
            delegate: Maui.Chip
            {
                label.text: modelData
                showCloseButton: false
                Kirigami.Theme.backgroundColor: control.currentColor
                iconSource: "tag"
            }
        }       
    }
    
    onClosed:
    {
        control.clear()
    }

    function clear()
    {
        control.currentColor = ""
        textEntry.clear()
    }
    
    function done()
    {
        for(var tag of textEntry.text.split(","))
        {
             Maui.Tagging.tag(tag, control.currentColor, "")
        }
        
        control.close()
        //control.alert(i18n("Tag could not be created. Check all fields are correct"))
    }
}
