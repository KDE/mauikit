import QtQuick
import QtQuick.Controls

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Flow
 * @brief A row of color buttons
 * 
 * @image html Misc/colorsrow.png "Demo"
 * 
 * @code
 * Column
 * {
 *    width: 400
 *    anchors.centerIn: parent
 *    spacing: Maui.Style.space.big
 * 
 *    Maui.ColorsRow
 *    {
 *        id: _colorsRow
 *        width: parent.width
 * 
 *        currentColor: "#CBFF8C"
 *        defaultColor : "#CBFF8C"
 * 
 *        colors: ["#E3E36A", "#CBFF8C", "#C16200", "#881600", "#6A3937", "#706563", "#748386", "#157A6E", "#77B28C", "#36311F"]
 * 
 *        onColorPicked: (color) =>
 *                        {
 *                            currentColor = color
 *                        }
 *    }
 * 
 *    Rectangle
 *    {
 *        radius: 10
 *        height: 400
 *        width: parent.width
 *        color: _colorsRow.currentColor
 *    }
 * }
 * @endcode
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ColorsRow.qml">You can find a more complete example at this link.</a>
 */
Flow
{
    id: control   
    
    spacing: Maui.Style.defaultSpacing
    
    /**
     * @brief The list of colors to be used.
     */
    default property var colors : []
        
        /**
         * @brief The default color. This is used as the color when the reset/clear button is clicked. The color to reset back to.
         */
        property string defaultColor 
        
        /**
         * @brief The current color. This is useful to be set at startup, it is binded to the `defaultColor` as default.
         */
        property string currentColor : defaultColor
        
        /**
         * @brief The size of the elements in the row.
         */
        property int size : Maui.Handy.isMobile ? 26 : Maui.Style.iconSizes.medium
        
        /**
         * @brief Emitted when one of the color buttons has been clicked. The argument is the color picked.
         * @param color the color picked.
         * 
         * @code
         *  onColorPicked: (color) =>
         *                        {
         *                            currentColor = color
}
* @endcode
*/
        signal colorPicked (string color)
        
        Repeater
        {
            model: control.colors
            
            AbstractButton
            {
                id: _button
                checked : control.currentColor === modelData
                implicitHeight: control.size + topPadding + bottomPadding
                implicitWidth: implicitHeight + leftPadding + rightPadding
                hoverEnabled: true
                onClicked: control.colorPicked(modelData)
                
                property color color : modelData
                
                contentItem: Item
                {                
                    Maui.Icon
                    {
                        visible: opacity > 0
                        color: Maui.ColorUtils.brightnessForColor(_button.color) === Maui.ColorUtils.Light ? "#333" : "#fff"
                        anchors.centerIn: parent
                        height: Math.round(parent.height * 0.9)
                        width: height
                        opacity: checked || hovered ? 1 : 0
                        isMask: true
                        
                        source: "qrc:/assets/checkmark.svg"
                        
                        Behavior on opacity
                        {
                            NumberAnimation
                            {
                                duration: Maui.Style.units.shortDuration
                                easing.type: Easing.InOutQuad
                            }
                        }
                    } 
                }
                
                background: Rectangle
                {
                    radius: Maui.Style.radiusV
                    color: enabled ? modelData : "transparent"                
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            active: control.defaultColor.length
            sourceComponent: Item
            {
                implicitHeight: control.size
                implicitWidth: implicitHeight
                
                ToolButton
                {
                    flat: true
                    anchors.centerIn: parent
                    icon.name: "edit-clear"
                    onClicked:
                    {
                        control.colorPicked(control.defaultColor)
                    }
                }
            }
        }   
}
