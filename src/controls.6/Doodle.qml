import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

/**
    @since org.mauikit.controls.labs 1.0
    
    @brief A drawing component wrapped in a popup surface.
    This controls inherits from MauiKit PopupPage, to checkout its inherited properties refer to the docs.
    @see PopupPage
    
    @image html Misc/doodle.png

    @warning This control is incomplete and will be moved out its own plugin named MauiKit::Painting   

    @code
    Maui.Page
    {
        id: _page

        anchors.fill: parent
        Maui.Controls.showCSD: true
        Maui.Theme.colorSet: Maui.Theme.Window
        headBar.forceCenterMiddleContent: true

        Button
        {
            anchors.centerIn: parent
            text: "Doodle Me!"
            onClicked: _doodle.open()
        }
    }

    Maui.Doodle
    {
        id: _doodle
        sourceItem: _page
    }
    @endcode
    
    <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/Doodle.qml">You can find a more complete example at this link.</a>
 */
Maui.PopupPage
{
    id: control
    
    Maui.Theme.backgroundColor: Qt.rgba(bgColor.r, bgColor.g, bgColor.b, 0.85)
    Maui.Theme.textColor:"#fefefe"
    //     deafultButtons: false
    
    maxHeight: img.height + Maui.Style.toolBarHeight + Maui.Style.space.medium
    maxWidth: img.width
    
    /**
     * @brief A source item can be captured to start doodling over it and to be saved later as an image.
     */
    property Item sourceItem : null
    
    /**
     * @brief The background color of the canvas.
     */
    readonly property color bgColor : "#333"
    
    /**
     * @brief An image source to be used as the background to doodle over it.
     */
    property alias source : img.source
    
    /**
     * @brief The size of the brush.
     * @property double Doodle::brushSize
     */
    property alias brushSize : _canvas.brushSize 
    
    /**
     * @brief The opacity of the brush.
     * @property double Doodle::brushOpacity
     */
    property alias brushOpacity : _canvas.brushOpacity
    
    /**
     * @brief The shape of the brush.
     * Possibel values are:
     * - 0 for circular
     * - 1 for rectangular
     * @property int Doodle::brushShape
     */
    property alias brushShape : _canvas.brushShape //0 -Circular, 1 - rectangular.
    
    /**
     * @brief The maximum size of the brush.
     * @property double Doodle::maxBrushSize
     */
    property alias maxBrushSize: _canvas.maxBrushSize
    
    /**
     * @brief The color of the paint to use with the brush.
     * @property color Doodle::paintColor
     */
    property alias paintColor: _canvas.paintColor
    
    onOpened:
    {
        if(control.visible)
        {
            if(control.sourceItem)
            {
                control.sourceItem.grabToImage(function(result) {
                    img.source = result.url;
                })
            }
        }else
        {
            _canvas.buffer.clear()
        }
    }
    
    onSourceItemChanged:
    {
        if(control.visible && control.opened)
        {
            if(control.sourceItem)
            {
                control.sourceItem.grabToImage(function(result) { img.source = result.url })
            }
        }
    }
    
    footBar.visible: true
    
    footBar.rightContent: ToolButton
    {
        icon.name: "document-share"
        onClicked: {}
    }
    
    footBar.leftContent: Maui.ToolActions
    {
        expanded: true
        autoExclusive: true
        checkable: false
        
        Action
        {
            icon.name: "edit-undo"
        }
        
        Action
        {
            icon.name: "edit-redo"
        }
    }
    
    footBar.middleContent:[
        
        Maui.ToolActions
        {
            autoExclusive: true
            expanded: true
            display: ToolButton.TextBesideIcon
            
            Action
            {
                icon.name: "draw-highlight"
                text: i18nd("mauikit", "Highlighter")
                onTriggered:
                {
                    control.paintColor = "yellow"
                    control.brushShape = 1
                }
            }
            
            Action
            {
                icon.name: "draw-brush"
                text: i18nd("mauikit", "Marker")
                onTriggered:
                {
                    control.paintColor = "blue"
                    control.brushShape = 0
                }
            }
            
            Action
            {
                icon.name: "draw-calligraphic"
                text: i18nd("mauikit", "Highlighter")
                onTriggered:
                {
                    control.paintColor = "#333"
                    control.brushShape = 1
                }
            }
            
            Action
            {
                id: _eraserButton
                text: i18nd("mauikit", "Eraser")
                
                icon.name: "draw-eraser"
            }
        },
        
        Maui.ToolActions
        {
            expanded: true
            autoExclusive: false
            display: ToolButton.TextBesideIcon
            
            Action
            {
                id: _colorsButton
                text: i18nd("mauikit", "Color")
                icon.name: "color-fill"
            }
            
            Action
            {
                id: _opacityButton
                text: i18nd("mauikit", "Opacity")
                
                icon.name: "edit-opacity"
            }
            
            Action
            {
                id: _sizeButton
                text: i18nd("mauikit", "Size")
                
            }
        }
        
    ]
    
    page.footerColumn: [
        Maui.ToolBar
        {
            id: _sizeBar
            visible: _sizeButton.checked
            width: parent.width
            position: ToolBar.Footer
            leftContent: Label
            {
                text: i18nd("mauikit", "Size")
                color: Maui.Theme.textColor
            }
            
            rightContent: Label
            {
                text: _sizeSlider.value
                color: Maui.Theme.textColor
            }
            
            middleContent: Slider
            {
                id: _sizeSlider
                Layout.fillWidth: true
                value: 20
                from : 10
                to : 100
                stepSize: 10
            }
        },
        
        Maui.ToolBar
        {
            id: _opacityBar
            visible: _opacityButton.checked
            width: parent.width
            position: ToolBar.Footer
            
            leftContent: Label
            {
                text: i18nd("mauikit", "Opacity")
                color: Maui.Theme.textColor
            }
            
            middleContent: Slider
            {
                id: _opacitySlider
                Layout.fillWidth: true
                value: 1
                from: 0
                to: 1
            }
            
            rightContent: Label
            {
                text: _opacitySlider.value
                color: Maui.Theme.textColor
            }
        },
        
        Maui.ToolBar
        {
            id: _colorsBar
            visible: _colorsButton.checked
            width: parent.width
            position: ToolBar.Footer
            middleContent: Maui.ColorsRow
            {
                onColorPicked: 
                {
                    currentColor = color
                    control.paintColor = currentColor                    
                }
                
                colors: ["yellow", "pink", "orange", "blue", "magenta", "black", "grey", "cian",
                "#63b598", "#ce7d78", "#ea9e70", "#a48a9e", "#c6e1e8", "#648177" ,"#0d5ac1" ,
                "#f205e6" ,"#1c0365" ,"#14a9ad" ,"#4ca2f9" ,"#a4e43f" ,"#d298e2" ,"#6119d0",
                "#d2737d" ,"#c0a43c" ,"#f2510e" ,"#651be6" ,"#79806e" ,"#61da5e" ,"#cd2f00" ,
                "#9348af" ,"#01ac53" ,"#c5a4fb" ,"#996635","#b11573" ,"#4bb473" ,"#75d89e" ,
                "#2f3f94" ,"#2f7b99" ,"#da967d" ,"#34891f" ,"#b0d87b" ,"#ca4751" ,"#7e50a8" ,
                "#c4d647" ,"#e0eeb8" ,"#11dec1" ,"#289812" ,"#566ca0" ,"#ffdbe1" ,"#2f1179" ,
                "#935b6d" ,"#916988" ,"#513d98" ,"#aead3a", "#9e6d71", "#4b5bdc", "#0cd36d",
                "#250662", "#cb5bea", "#228916", "#ac3e1b", "#df514a", "#539397", "#880977",
                "#f697c1", "#ba96ce", "#679c9d", "#c6c42c", "#5d2c52", "#48b41b", "#e1cf3b",
                "#5be4f0", "#57c4d8", "#a4d17a", "#225b8", "#be608b", "#96b00c", "#088baf",
                "#f158bf", "#e145ba", "#ee91e3", "#05d371", "#5426e0", "#4834d0", "#802234",
                "#6749e8", "#0971f0", "#8fb413", "#b2b4f0", "#c3c89d", "#c9a941", "#41d158",
                "#409188", "#911e20", "#1350ce", "#10e5b1", "#fff4d7", "#cb2582", "#ce00be",
                "#32d5d6", "#17232", "#608572", "#c79bc2", "#00f87c", "#77772a", "#6995ba",
                "#fc6b57", "#f07815", "#8fd883", "#060e27", "#96e591", "#21d52e", "#d00043",
                "#b47162", "#1ec227", "#4f0f6f", "#1d1d58", "#947002", "#bde052", "#e08c56",
                "#28fcfd", "#bb09b", "#36486a", "#d02e29", "#1ae6db", "#3e464c", "#a84a8f",
                "#911e7e", "#3f16d9", "#0f525f", "#ac7c0a", "#b4c086", "#c9d730", "#30cc49",
                "#3d6751", "#fb4c03", "#640fc1", "#62c03e", "#d3493a", "#88aa0b", "#406df9",
                "#615af0", "#4be47", "#2a3434", "#4a543f", "#79bca0", "#a8b8d4", "#00efd4",
                "#7ad236", "#7260d8", "#1deaa7", "#06f43a", "#823c59", "#e3d94c", "#dc1c06",
                "#f53b2a", "#b46238", "#2dfff6", "#a82b89", "#1a8011", "#436a9f", "#1a806a",
                "#4cf09d", "#c188a2", "#67eb4b", "#b308d3", "#fc7e41", "#af3101", "#ff065",
                "#71b1f4", "#a2f8a5", "#e23dd0", "#d3486d", "#00f7f9", "#474893", "#3cec35",
                "#1c65cb", "#5d1d0c", "#2d7d2a", "#ff3420", "#5cdd87", "#a259a4", "#e4ac44",
                "#1bede6", "#8798a4", "#d7790f", "#b2c24f", "#de73c2", "#d70a9c", "#25b67",
                "#88e9b8", "#c2b0e2", "#86e98f", "#ae90e2", "#1a806b", "#436a9e", "#0ec0ff",
                "#f812b3", "#b17fc9", "#8d6c2f", "#d3277a", "#2ca1ae", "#9685eb", "#8a96c6",
                "#dba2e6", "#76fc1b", "#608fa4", "#20f6ba", "#07d7f6", "#dce77a", "#77ecca"]
                
            }
        }
    ]
    
    headBar.visible: false
    ScrollView
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        
        contentHeight: img.height
        contentWidth: img.width
        
        Image
        {
            
            id: img
            height: sourceSize.height
            width: sourceSize.width
            fillMode: Image.PreserveAspectFit
            autoTransform: true
            asynchronous: true
            anchors.centerIn: parent
            
            
            //     Label
            //     {
            //         color: "yellow"
            //         text: parent.height + "-" + parent.width + " / " + control.height + "-" + control.width + " / " + buffer.width + "-"+ buffer.height
            //     }
            
            
        }
        
        Maui.DoodleCanvas
        {
            id: _canvas
            anchors.fill: parent
            brushSize : _sizeSlider.value
            brushOpacity :_opacitySlider.value
        }
    }  
}
