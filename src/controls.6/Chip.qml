import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Controls.ItemDelegate
 * @since org.mauikit.controls 1.0
 * 
 *    @brief This an information element, similar to a button, but more compact.
 * 
 *    Chips allow users to enter information, make selections, filter content, or trigger actions. While buttons are expected to appear consistently and with familiar calls to action, chips should appear dynamically as a group of multiple interactive elements.
 * 
 *    This component is similar to the MauiKit Badge control, but this one is interactive.
 *    @see Badge
 * 
 *    @image html Chip/chips.png "Colorful chips"
 * 
 *    @code
 *    Flow
 *    {
 *        width: 400
 *        anchors.centerIn: parent
 *        spacing: Maui.Style.space.big
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip1"
 *            color: "#757575"
 *        }
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip2"
 *            icon.name: "actor"
 *            color: "#03A9F4"
 *        }
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip3"
 *            icon.name: "anchor"
 *            color: "#4CAF50"
 *        }
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip4"
 *            color: "#E1BEE7"
 *        }
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip5"
 *            color: "#FFC107"
 *        }
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip6"
 *            color: "#607D8B"
 *        }
 * 
 *        Maui.Chip
 *        {
 *            text: "Chip7"
 *            color: "#FF5722"
 *            icon.source: "/home/camiloh/Downloads/5911329.jpeg"
 *        }
 *    }
 *    @endcode
 * 
 *    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/Chip.qml">You can find a more complete example at this link.</a>
 */
ItemDelegate
{
    id: control
    
    Maui.Theme.colorSet: Maui.Theme.Tooltip 
    
    hoverEnabled: !Maui.Handy.isMobile
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    icon.height: Maui.Style.iconSize
    icon.width: Maui.Style.iconSize
    
    /**
     * @brief The Label element used for the title text.
     * This is exposed to tweak the text font properties.
     * @property Label Chip::label
     */
    property alias label : _label1
    
    /**
     * @brief The name of the icon to be used.
     * This is an alias to the `icon.name` group property.
     * @property string Chip::iconSource
     */
    property alias iconSource : control.icon.name
    
    /**
     * @brief The name of the image source to be used.
     * This is an alias to the `icon.source` group property.
     * @property url Chip::imageSource
     */
    property alias imageSource : control.icon.source
    
    /**
     * @brief Whether a close button should be displayed, to dismiss the chip.
     * By default it is set to `false`.
     */
    property bool showCloseButton : false
    
    /**
     * @brief The background color for the chip. The label text color will be adapted from this color considering the brightness, to use either a light or dark text color.
     */
    property color color : Maui.Theme.backgroundColor
    
    ToolTip.visible: hovered &&  ToolTip.text.length > 0
    
    /**
     * @brief Emitted once the close button is clicked. To enable the close button see the `showCloseButton: true` property.
     * @see showCloseButton
     */
    signal close()
    
    background: Rectangle
    {
        id: _background
        
        color:  control.checked ? Maui.Theme.highlightColor : (control.pressed ? Qt.darker(control.color) : (control.hovered ? Qt.lighter(control.color): control.color))
        radius:  Maui.Style.radiusV   
    }
    
    contentItem: RowLayout
    {
        id: _layout
        spacing: control.spacing        
        
        Maui.IconItem
        {            
            iconSizeHint: Math.max(control.icon.width, control.icon.height)
            imageSizeHint:  Math.max(control.icon.width, control.icon.height)
            
            fillMode: Image.PreserveAspectCrop
            
            color: _label1.color
            iconSource: control.icon.name
            imageSource: control.icon.source
            
            maskRadius: height
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
            font: control.font
        }
        
        Loader
        {
            active: control.showCloseButton
            visible: active
            
            asynchronous: true
            
            Layout.alignment: Qt.AlignRight
            
            sourceComponent: Maui.CloseButton
            {
                icon.width: 16
                icon.height: 16
                icon.color: hovered ? Maui.Theme.negativeTextColor : _label1.color
                
                padding: 0
                onClicked: control.close()
            }
        }     
    }
}
