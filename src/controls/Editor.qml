    import QtQuick 2.15
    import QtQuick.Controls 2.15
    import QtQuick.Layouts 1.3
    
    import org.kde.mauikit 1.3 as Maui
    import org.kde.kirigami 2.14 as Kirigami
    
    import "private"
    
    /**
     * Editor
     * A text area for editing text with convinient functions.
     * The Editor is controlled by the DocumentHandler which controls the files I/O,
     * the syntax highlighting styles, and many more text editing properties.
     *
     *
     *
     *
     *
     */
    Maui.Page
    {
        id: control
        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        
        /**
         * showLineCount : bool
         * If a small text tooltip should be visible at the editor right bottom area, displaying the
         * number of count of lines and words.
         */
        property bool showLineCount : true
        
        /**
         * showSyntaxHighlightingLanguages : bool
         */
        property bool showSyntaxHighlightingLanguages: false
        
        /**
         * body : TextArea
         * Access to the editor text area.
         */
        property alias body : body
        
        /**
         * document : DocumentHandler
         *  The DocumentHandler
         */
        property alias document : document
        
        /**
         * scrollView : ScrollablePage
         */
        property alias scrollView: _scrollView
        
        /**
         * text : string
         */
        property alias text: body.text
        
        /**
         * uppercase : bool
         */
        property alias uppercase: document.uppercase
        
        /**
         * underline : bool
         */
        property alias underline: document.underline
        
        /**
         * italic : bool
         */
        property alias italic: document.italic
        
        /**
         * bold : bool
         */
        property alias bold: document.bold
        
        /**
         * canRedo : bool
         */
        property alias canRedo: body.canRedo
        
        /**
         * fileUrl : url
         * If a file url is provided the DocumentHandler will try to open its contents and display it.
         */
        property alias fileUrl : document.fileUrl
        
        /**
         * showLineNumbers : bool
         * If a sidebar listing each line number should be visible.
         */
        property bool showLineNumbers : false
        
        focus: true
        title: document.fileName
        showTitle: false
        flickable: _flickable
        
        Maui.DocumentHandler
        {
            id: document
            document: body.textDocument
            cursorPosition: body.cursorPosition
            selectionStart: body.selectionStart
            selectionEnd: body.selectionEnd
            backgroundColor: control.Kirigami.Theme.backgroundColor
            enableSyntaxHighlighting: false
            
            onCurrentLineIndexChanged:
            {
                //_scrollView.flickable.contentY = documentcurrentLineIndex * 
            }
            
            onSearchFound:
            {
                body.select(start, end)
            }
        }
        
        Row
        {
            z: _scrollView.z +1
            visible: showLineCount
            anchors
            {
                right: parent.right
                bottom: parent.bottom
                margins: Maui.Style.space.big
            }
            
            width: implicitWidth
            height: implicitHeight
            
            Label
            {
                text: body.length + " / " + body.lineCount
                color: control.Kirigami.Theme.textColor
                opacity: 0.5
            }
        }
        
        Menu
        {
            id: documentMenu
            z: 999
            
            MenuItem
            {
                text: i18n("Copy")
                onTriggered: body.copy()
                enabled: body.selectedText.length
            }
            
            MenuItem
            {
                text: i18n("Cut")
                onTriggered: body.cut()
                enabled: !body.readOnly && body.selectedText.length
            }
            
            MenuItem
            {
                text: i18n("Paste")
                onTriggered: body.paste()
                enabled: !body.readOnly
            }
            
            MenuItem
            {
                text: i18n("Select All")
                onTriggered: body.selectAll()
            }
            
            MenuItem
            {
                text: i18n("Search Selected Text on Google...")
                onTriggered: Qt.openUrlExternally("https://www.google.com/search?q="+body.selectedText)
                enabled: body.selectedText.length
            }
        }
        
        
        headBar.visible: !body.readOnly
        headBar.leftContent: [
        
        Maui.ToolActions
        {
            expanded: true
            autoExclusive: false
            checkable: false
            
            Action
            {
                icon.name: "edit-undo"
                enabled: body.canUndo
                onTriggered: body.undo()
            }
            
            Action
            {
                icon.name: "edit-redo"
                enabled: body.canRedo
                onTriggered: body.redo()
            }
        },
        
        Maui.ToolActions
        {
            visible: (document.isRich || body.textFormat === Text.RichText) && !body.readOnly
            expanded: true
            autoExclusive: false
            checkable: false
            
            Action
            {
                icon.name: "format-text-bold"
                checked: document.bold
                onTriggered: document.bold = !document.bold
            }
            
            Action
            {
                icon.name: "format-text-italic"
                checked: document.italic
                onTriggered: document.italic = !document.italic
            }
            
            Action
            {
                icon.name: "format-text-underline"
                checked: document.underline
                onTriggered: document.underline = !document.underline
            }
            
            Action
            {
                icon.name: "format-text-uppercase"
                checked: document.uppercase
                onTriggered: document.uppercase = !document.uppercase
            }
        }
        ]
        
        footBar.rightContent: ComboBox
        {
            visible: control.showSyntaxHighlightingLanguages
            model: document.getLanguageNameList()
            currentIndex: -1
            onCurrentIndexChanged: document.formatName = model[currentIndex]
        }
        
        ColumnLayout
        {
            anchors.fill: parent
            spacing: 0
            
            Repeater
            {
                model: document.alerts
                
                Maui.ToolBar
                {
                    id: _alertBar
                    property var alert : model.alert
                    readonly property int index_ : index
                    Layout.fillWidth: true
                    
                    Kirigami.Theme.backgroundColor:
                    {
                        switch(alert.level)
                        {
                            case 0: return Kirigami.Theme.positiveTextColor
                            case 1: return Kirigami.Theme.neutralTextColor
                            case 2: return Kirigami.Theme.negativeTextColor
                        }
                    }
                    
                    leftContent: Maui.ListItemTemplate
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        label1.text: alert.title
                        label2.text: alert.body
                    }
                    
                    rightContent: Repeater
                    {
                        model: alert.actionLabels()
                        
                        Button
                        {
                            id: _alertAction
                            property int index_ : index
                            text: modelData
                            onClicked: alert.triggerAction(_alertAction.index_, _alertBar.index_)
                            
                            Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.2)
                            Kirigami.Theme.textColor: Kirigami.Theme.textColor
                        }
                    }
                }
            }
            
            PinchArea
            {
                id: pinchArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                property real minScale: 1.0
                property real maxScale: 3.0
                
                pinch.minimumScale: minScale
                pinch.maximumScale: maxScale
                pinch.dragAxis: Pinch.XandYAxis
                
                onPinchFinished:
                {
                    console.log("pinch.scale", pinch.scale)
                    
                    if(pinch.scale > 1.5)
                        control.zoomIn()
                        else control.zoomOut()
                }                        
                
                ScrollView
                {
                    id: _scrollView
                    anchors.fill: parent
                    
                    Flickable
                    {
                        id: _flickable
                        interactive: Kirigami.Settings.hasTransientTouchInput
                        boundsBehavior: Flickable.StopAtBounds
                        boundsMovement :Flickable.StopAtBounds 
                        
                        TextArea.flickable: TextArea
                        {
                            id: body                           
                           
                            text: document.text
                            placeholderText: i18n("Body")
                            selectByKeyboard: !Kirigami.Settings.isMobile
                            selectByMouse : !Kirigami.Settings.hasTransientTouchInput
                            textFormat: TextEdit.AutoText
                            wrapMode: TextEdit.WrapAnywhere
                            color: control.Kirigami.Theme.textColor
                            activeFocusOnPress: true
                            activeFocusOnTab: true
                            persistentSelection: true
                            
                            leftInset: leftPadding
                            leftPadding: _linesCounter.width + Maui.Style.space.small
                            
                            background: Rectangle
                            {
                                color: "transparent"       
                            }   
                            
                            Keys.onPressed:
                            {
                                if(event.key === Qt.Key_PageUp)
                                {
                                    flickable.flick(0,  60*Math.sqrt(flickable.height))
                                }   
                                
                                if(event.key === Qt.Key_PageDown)
                                {
                                    flickable.flick(0, -60*Math.sqrt(flickable.height))                                    
                                }                                    // TODO: Move cursor
                            }
                            
                            onPressAndHold:
                            {
                                documentMenu.popup()
                            } 
                            
                            onPressed:
                            {
                                if(!Kirigami.Settings.isMobile && event.button === Qt.RightButton)
                                    documentMenu.popup()
                            }
                            
                            HoverHandler
                            {
                                //active: true
                                target: _scrollView
                                cursorShape: Qt.IBeamCursor
                            }
                            
                            Loader
                            {
                                id: _linesCounter
                                active: control.showLineNumbers && !document.isRich
                                anchors.left: parent.left
                                height: Math.max(body.height, control.height)
                                width: active ? 32 : 0
                                sourceComponent: _linesCounterComponent
                            }
                            
                            Component
                            {
                                id: _linesCounterComponent
                                
                                Rectangle
                                {
                                    Kirigami.Theme.inherit: false
                                    Kirigami.Theme.colorSet: Kirigami.Theme.Window
                                    color: Qt.darker(Kirigami.Theme.backgroundColor, 1)
                                    
                                    ListView
                                    {
                                        currentIndex: document.currentLineIndex
                                        model: body.lineCount
                                        orientation: ListView.Vertical
                                        interactive: false
                                        anchors.fill: parent
                                        anchors.topMargin: 7
                                        snapMode: ListView.NoSnap
                                        
                                        boundsBehavior: Flickable.StopAtBounds
                                        boundsMovement :Flickable.StopAtBounds 
                                        
                                        preferredHighlightBegin: 0
                                        preferredHighlightEnd: width
                                        
                                        highlightRangeMode: ListView.StrictlyEnforceRange
                                        highlightMoveDuration: 0
                                        highlightFollowsCurrentItem: false
                                        highlightResizeDuration: 0
                                        highlightMoveVelocity: -1
                                        highlightResizeVelocity: -1
                                        
                                        maximumFlickVelocity: 4 * (orientation === Qt.Horizontal ? width : height)
                                        
                                        delegate: RowLayout
                                        {
                                            //property bool foldable : document.isFoldable(index)
                                            //property bool folded : document.isFolded(index)
                                            readonly property int line : index
                                            width:  ListView.view.width
                                            height: document.lineHeight(index)
                                            spacing: 0
                                            
                                            readonly property bool isCurrentItem : ListView.isCurrentItem
                                            
                                            Label
                                            {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                
//                                                 Layout.leftMargin: Maui.Style.space.small
                                                opacity: isCurrentItem  ? 1 : 0.7
                                                color:  isCurrentItem ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                                                font.pointSize: Math.min(Maui.Style.fontSizes.medium, body.font.pointSize)
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignTop
                                                renderType: Text.NativeRendering
                                                font.family: "Monospace"
                                                text: index+1
                                            }
                                            
                                            //MouseArea
                                            //{
                                                //visible: foldable
                                                
                                                //Layout.preferredWidth: visible ? 16 : 0
                                                //Layout.fillHeight: true
                                                //onClicked:
                                                //{
                                                    //console.log("toggle fold", line)
                                                    //document.toggleFold(line)                                            
                                                //}
                                                
                                                //Kirigami.Icon
                                                //{
                                                    //source: folded ? "arrow-down" : "arrow-up"
                                                    //anchors.centerIn: parent
                                                    //height: visible ? 12 : 0
                                                    //width: height
                                                    //color: Kirigami.Theme.textColor
                                                    //isMask: true
                                                //}
                                            //}
                                        }
                                    }
                                    
                                    Kirigami.Separator
                                    {
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: parent.right
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        /**
         * 
         */
        function zoomIn()
        {
            body.font.pointSize = body.font.pointSize *1.5
        }
        
        /**
         * 
         */
        function zoomOut()
        {
            body.font.pointSize = body.font.pointSize / 1.5
            
        }
    }
    
