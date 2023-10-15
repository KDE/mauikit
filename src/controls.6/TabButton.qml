
import QtQuick
import QtQuick.Controls 2.15 as QQC
import QtQuick.Layouts

import org.mauikit.controls 1.3 as Maui

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

    /**
     * @brief An alias exposed to append more elements into the main container of this control. The container is hanlded by a RowLayout, so any children added using this property needs to be postioned using the Layout attached properties.
     * @property list<QtObject> TabButton::content
     */
    property alias content: _content.data
    
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
        implicitWidth: _content.implicitWidth
        implicitHeight: _content.implicitHeight
        
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        preventStealing: false
        
        onClicked:
        {
            if(mouse.button === Qt.RightButton)
            {
                control.rightClicked(mouse)
            }
            
            mouse.accepted = false
        }
        
        RowLayout
        {
            id: _content
            anchors.fill: parent
            spacing: control.spacing
            
            Row
            {
                id: _leftContent
            }
            
            Maui.IconLabel
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                opacity: control.checked || control.hovered ? 1 : 0.7
                
                text: control.text
                icon: control.icon
                color: Maui.Theme.textColor
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
}

