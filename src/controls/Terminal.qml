
import QMLTermWidget 1.0
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui
import "private" as Private

/**
 * Terminal
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
Maui.Page
{
    id: control
    
    title: ksession.title
    showTitle: false
    headBar.visible: false
    focus: true
    
    /**
     * virtualResolution : size
     */
    property size virtualResolution: Qt.size(kterminal.width, kterminal.height)
    
    /**
     * fontWidth : real
     */
    property real fontWidth: 1.0
    
    /**
     * screenScaling : real
     */
    property real screenScaling: 1.0
    
    /**
     * scaleTexture : real
     */
    property real scaleTexture: 1.0
    
    /**
     * kterminal : QMLTermWidget
     */
    property alias kterminal: kterminal
    
    /**
     * session : QMLTermSession
     */
    property alias session: ksession
    
    /**
     * findBar : TextField
     */
    property alias findBar : findBar
    
    /**
     *  menu : Menu
     */
    property alias menu : terminalMenu.contentData
    
    /**
     * terminalSize : size
     */
    property size terminalSize: kterminal.terminalSize
    
    /**
     * fontMetrics : size
     */
    property size fontMetrics: kterminal.fontMetrics
    
    /**
     * urlsDropped :
     */
    signal urlsDropped(var urls)
    
    /**
     * keyPressed :
     */
    signal keyPressed(var event)
    
    /**
     * clicked :
     */
    signal clicked()
    
    
    //Actions
    Action
    {
        id: _copyAction
        text: i18nd("mauikit", "Copy")
        icon.name: "edit-copy"
        onTriggered:  kterminal.copyClipboard();
        //shortcut: "Ctrl+Shift+C"
    }
    
    Action
    {
        id: _pasteAction
        text: i18nd("mauikit", "Paste")
        icon.name: "edit-paste"
        onTriggered: kterminal.pasteClipboard()
        //         shortcut: "Ctrl+Shift+V"
    }
    
    Action
    {
        id: _findAction
        text: i18nd("mauikit", "Find")
        icon.name: "edit-find"
        //         shortcut: "Ctrl+Shift+F"
        onTriggered: footBar.visible = !footBar.visible
    }
    
    onKeyPressed:
    {
        if ((event.key === Qt.Key_A)
            && (event.modifiers & Qt.ControlModifier)
            && (event.modifiers & Qt.ShiftModifier)) {
            kterminal.selectAll()
            event.accepted = true
            }
            
            if ((event.key === Qt.Key_C)
                && (event.modifiers & Qt.ControlModifier)
                && (event.modifiers & Qt.ShiftModifier)) {
                _copyAction.trigger()
                event.accepted = true
                }
                
                if ((event.key === Qt.Key_V)
                    && (event.modifiers & Qt.ControlModifier)
                    && (event.modifiers & Qt.ShiftModifier)) {
                    _pasteAction.trigger()
                    event.accepted = true
                    }
                    
                    if ((event.key === Qt.Key_Q)
                        && (event.modifiers & Qt.ControlModifier)
                        && (event.modifiers & Qt.ShiftModifier)) {
                        Qt.quit()
                        }       
    }
    
    
    Maui.ContextualMenu
    {
        id: terminalMenu
        
        MenuItem
        {
            action: _copyAction
        }
        
        MenuItem
        {
            action: _pasteAction
        }
        
        MenuItem
        {
            action: _findAction
        }
        
        onClosed: control.forceActiveFocus()
    }
    
    
    function correctDistortion(x, y)
    {
        x = x / width;
        y = y / height;
        
        var cc = Qt.size(0.5 - x, 0.5 - y);
        var distortion = 0;
        
        return Qt.point((x - cc.width  * (1+distortion) * distortion) * kterminal.width,
                        (y - cc.height * (1+distortion) * distortion) * kterminal.height)
    }
    
    function updateSources()
    {
        kterminal.update();
    }
    
    footBar.visible: false
    footBar.middleContent: TextField
    {
        id: findBar
        Layout.fillWidth: true
        placeholderText: i18nd("mauikit", "Find...")
        horizontalAlignment: Qt.Left
        onAccepted: ksession.search(text)
    }    
    
    QMLTermWidget
    {
        id: kterminal
        anchors.fill: parent
        //         terminalUsesMouse: true
        enableBold: true
        fullCursorHeight: true
        // 		onKeyPressedSignal: console.log(e.key)
        
        font.family: "Monospace"
        font.pixelSize: 12
        
        // backgroundOpacity: 0
        
        onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
        
        Keys.enabled: true
        Keys.onPressed: 
        {
            if ((event.key == Qt.Key_V) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
            {
                _pasteAction.trigger()
            }
            
            if ((event.key == Qt.Key_C) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
            {
                _copyAction.trigger()
            }
            
            if ((event.key == Qt.Key_F) && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier))
            {
                control.footBar.visible = !control.footBar.visible
            }    
            control.keyPressed(event)
        }
        
        session: QMLTermSession
        {
            id: ksession
            initialWorkingDirectory: "$HOME"
            onFinished: Qt.quit()
            
            // onFinished: control.terminalClosed()
            // initialWorkingDirectory: control.path
            /* Disable search until implemented correctly
             *             
             *            onMatchFound:
             *            {
             *              console.log("found at: %1 %2 %3 %4".arg(startColumn).arg(startLine).arg(endColumn).arg(endLine));
        }
        onNoMatchFound:
        {
        console.log("not found");
        }
        
        */
        }
        
        Loader
        {
            asynchronous: true
            anchors.fill: parent
            
            sourceComponent:  MouseArea
            {
                propagateComposedEvents: true
                cursorShape: kterminal.terminalUsesMouse ? Qt.ArrowCursor : Qt.IBeamCursor
                acceptedButtons:  Qt.RightButton | Qt.LeftButton
                
                onDoubleClicked:
                {
                    var coord = correctDistortion(mouse.x, mouse.y);
                    kterminal.simulateMouseDoubleClick(coord.x, coord.y, mouse.button, mouse.buttons, mouse.modifiers);
                }
                
                onPressed:
                {
                    if((!kterminal.terminalUsesMouse || mouse.modifiers & Qt.ShiftModifier) && mouse.button == Qt.RightButton)
                    {
                        terminalMenu.show();
                    } else
                    {
                        var coord = correctDistortion(mouse.x, mouse.y);
                        kterminal.simulateMousePress(coord.x, coord.y, mouse.button, mouse.buttons, mouse.modifiers)
                    }
                }
                
                onReleased:
                {
                    var coord = correctDistortion(mouse.x, mouse.y);
                    kterminal.simulateMouseRelease(coord.x, coord.y, mouse.button, mouse.buttons, mouse.modifiers);
                }
                
                onPositionChanged:
                {
                    var coord = correctDistortion(mouse.x, mouse.y);
                    kterminal.simulateMouseMove(coord.x, coord.y, mouse.button, mouse.buttons, mouse.modifiers);
                }
                
                onClicked:
                {
                    if(mouse.button === Qt.RightButton)
                    {
                        terminalMenu.show()
                        
                    } else if(mouse.button === Qt.LeftButton)
                    {                    
                        kterminal.forceActiveFocus()
                    }
                    
                    control.clicked()
                }
                
                onPressAndHold:
                {
                    if(Maui.Handy.isTouch)
                        terminalMenu.show()
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            active: Maui.Handy.hasTransientTouchInput
            anchors.fill: parent
            
            sourceComponent: Private.TerminalInputArea
            {
                //         enabled: terminalPage.state != "SELECTION"
                
                // FIXME: should anchor to the bottom of the window to cater for the case when the OSK is up
                
                // This is the minimum wheel event registered by the plugin (with the current settings).
                property real wheelValue: 40
                
                // This is needed to fake a "flickable" scrolling.
                swipeDelta: kterminal.fontMetrics.height
                
                // Mouse actions
                onMouseMoveDetected: kterminal.simulateMouseMove(x, y, button, buttons, modifiers);
                onDoubleClickDetected: kterminal.simulateMouseDoubleClick(x, y, button, buttons, modifiers);
                onMousePressDetected: 
                {
                    kterminal.forceActiveFocus();
                    kterminal.simulateMousePress(x, y, button, buttons, modifiers);
                    control.clicked()
                }
                onMouseReleaseDetected: kterminal.simulateMouseRelease(x, y, button, buttons, modifiers);
                onMouseWheelDetected: kterminal.simulateWheel(x, y, buttons, modifiers, angleDelta);
                
                // Touch actions
                onTouchPress: 
                {
                    kterminal.forceActiveFocus()
                    control.clicked()
                }
                
                onTouchClick:
                {
                    kterminal.forceActiveFocus()
                    kterminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");
                    control.clicked()
                }
                
                onTouchPressAndHold: 
                {
                    alternateAction(x, y);
                }
                
                // Swipe actions
                onSwipeYDetected: {
                    if (steps > 0) {
                        simulateSwipeDown(steps);
                    } else {
                        simulateSwipeUp(-steps);
                    }
                }
                onSwipeXDetected: {
                    if (steps > 0) {
                        simulateSwipeRight(steps);
                    } else {
                        simulateSwipeLeft(-steps);
                    }
                }
                onTwoFingerSwipeYDetected: {
                    if (steps > 0) {
                        simulateDualSwipeDown(steps);
                    } else {
                        simulateDualSwipeUp(-steps);
                    }
                }
                
                function simulateSwipeUp(steps) {
                    while(steps > 0) {
                        kterminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
                        steps--;
                    }
                }
                function simulateSwipeDown(steps) {
                    while(steps > 0) {
                        kterminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");
                        steps--;
                    }
                }
                function simulateSwipeLeft(steps) {
                    while(steps > 0) {
                        kterminal.simulateKeyPress(Qt.Key_Left, Qt.NoModifier, true, 0, "");
                        steps--;
                    }
                }
                function simulateSwipeRight(steps) {
                    while(steps > 0) {
                        kterminal.simulateKeyPress(Qt.Key_Right, Qt.NoModifier, true, 0, "");
                        steps--;
                    }
                }
                function simulateDualSwipeUp(steps) {
                    while(steps > 0) {
                        kterminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, -wheelValue));
                        steps--;
                    }
                }
                function simulateDualSwipeDown(steps) {
                    while(steps > 0) {
                        kterminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, wheelValue));
                        steps--;
                    }
                }
                
                // Semantic actions
                onAlternateAction: {
                    // Force the hiddenButton in the event position.
                    //hiddenButton.x = x;
                    //hiddenButton.y = y;
                    terminalMenu.show()
                }
            }
        }
        
        Loader
        {
            asynchronous: true
            // active: Maui.Handy.hasTransientTouchInput
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }        
            sourceComponent: ScrollBar 
            {
                Maui.Theme.colorSet: Maui.Theme.Complementary // text color of terminal is also complementary
                Maui.Theme.inherit: false
                width: 10
                
                active: hovered || pressed
                visible: true
                orientation: Qt.Vertical
                size: (kterminal.lines / (kterminal.lines + kterminal.scrollbarMaximum - kterminal.scrollbarMinimum))
                position: kterminal.scrollbarCurrentValue / (kterminal.lines + kterminal.scrollbarMaximum)
                // interactive: false
                property double oldPos
                
                       /* onPositionChanged: {
                            var yPos =  (2* position * kterminal.scrollbarMaximum ) * (position > oldPos ? -1 : 1)
                            console.log("Position changed", position, yPos, kterminal.scrollbarMaximum, kterminal.scrollbarCurrentValue)
                            kterminal.simulateWheel(0, 0, 0, 0, Qt.point(0,yPos))
                            oldPos = position
                            
                        } */  
            }  
            
        }
        
        Component.onCompleted:
        {
            ksession.startShellProgram();
            //forceActiveFocus()
        }
    }
    
    opacity: _dropArea.containsDrag ? 0.5 : 1
    
    DropArea
    {
        id: _dropArea
        anchors.fill: parent
        onDropped:
        {
            if(drop.urls)
                control.urlsDropped(drop.urls)
        }
    }
    
    //Component.onCompleted: control.forceActiveFocus();
    
    function forceActiveFocus()
    {
        kterminal.forceActiveFocus()
    }
}
