import QtQuick
import QtQuick.Layouts
import QtQuick.Window

import QtQuick.Controls as QQC

import org.mauikit.controls as Maui
import "private" as Private

/**
 * @inherit QtQuick.Controls.TabBar
 * @brief Tab bar alternative to QQC TabBar, and based on it.
 *
 *  <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-tabbar.html">This controls inherits from QQC2 TabBar, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * Mostly used together with the TabView control.
 *
 * The layout of this control is divided into three sections: left, middle and right area.
 * The middle area is reserved for placing the tab buttons. The right and left side areas can be populated with any child item.
 *
 * All the child items are expected to be a TabButton or inherit from it. If you need to add an extra button, label or other item, consider adding them using the left and right containerizes.
 * @see leftContent
 * @see rightContent
 *
 * @code
 * TabBar
 * {
 *    leftContent: Button
 *    {
 *        text: "Button1"
 *    }
 *
 *    rightContent: [
 *
 *        Button
 *        {
 *            text: "Button2"
 *        },
 *
 *        Button
 *        {
 *            text: "Button3"
 *        }
 *    ]
 * }
 * @endcode
 *
 * @section notes Notes
 *
 * The contents of this bar will become flickable/scrollable if the implicit width of the child elements is higher than the available width.
 * When using it on a mobile device and a flick/swipe action is performed by the user, a signal will be emitted informing about the tab focused in the view port.
 * @see newTabFocused
 *
 * @note This control supports the attached Controls.showCSD property to display the window control buttons when using CSD.
 */
QQC.TabBar
{
    id: control
    
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    /**
     * @brief An alias to manually add elements to the container directly. This is the middle section of the control.
     * @property list<QtObject> TabBar::content
     */
    property alias content : _rightLayout.content
    
    /**
     * @brief An alias to add elements to the left area section.
     * @property list<QtObject> TabBar::leftContent
     */
    property alias leftContent: _leftLayout.content
    
    /**
     * @brief An alias to add elements to the right area section.
     * @property list<QtObject> TabBar::rightContent
     */
    property alias rightContent: _rightLayout.content
    
    /**
     * @brief Whether the control will react to touch events to flick the tabs.
     * @property bool TabBar::interactive
     */
    property alias interactive: _content.interactive
    
    /**
     * @brief Whether to display a button which represents the "add new tab" action.
     * If this button is clicked a signal is triggered.
     * @see newTabClicked
     */
    property bool showNewTabButton : true
    
    /**
     * @brief Whether the tab buttons will be visible or not.
     */
    property bool showTabs : true
    
    /**
     * @brief This signal is emitted when the "add new tab" button has been clicked.
     * @see showNewTabButton
     */
    signal newTabClicked()
    
    /**
     * @brief This signal is emitted when a new tab button is focused after a swipe/flick action has been performed.
     * To set the new focused tab as the current one, use the index value passed as the argument to the currentIndex property. To make sure the tab is fully visible in the view port you can use the positioning function.
     * @see positionViewAtIndex
     */
    signal newTabFocused(int index)
    
    background: Rectangle
    {
        color: Maui.Theme.backgroundColor
        
        Behavior on color
        {
            Maui.ColorTransition{}
        }
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_content.atXEnd && !parent.fits
            visible: active
            
            anchors
            {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Maui.EdgeShadow
            {
                edge: Qt.RightEdge
            }
        }
        
        Loader
        {
            z: 999
            
            asynchronous: true
            width: Maui.Style.iconSizes.medium
            height: parent.height
            active: !_content.atXBeginning && !parent.fits
            visible: active
            anchors
            {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            
            sourceComponent: Maui.EdgeShadow
            {
                edge: Qt.LeftEdge
            }
        }
    }
    
    contentItem: Item
    {
        implicitHeight: _layout.implicitHeight
        readonly property bool fits : _content.contentWidth <= width
        
        Loader
        {
            // active: control.draggable
            asynchronous: true
            anchors.fill: parent
            sourceComponent: Item
            {
                DragHandler
                {
                    target: null
                    grabPermissions: TapHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) {  control.Window.window.startSystemMove(); }
                }
            }
        }
        
        RowLayout
        {
            id: _layout
            width: parent.width
            height: parent.height
            spacing: control.spacing
            
            Private.ToolBarSection
            {
                id: _leftLayout
                spacing: control.spacing
                Layout.fillHeight: true
                Layout.maximumWidth: implicitWidth
                Layout.minimumWidth: implicitWidth
            }
            
            QQC.ScrollView
            {
                Layout.fillWidth: true
                
                orientation : Qt.Horizontal
                
                QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff
                QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AlwaysOff
                
                contentHeight: availableHeight
                implicitHeight: _content.currentItem ? _content.currentItem.height : 0
                
                ListView
                {
                    id: _content
                    opacity: control.showTabs ? 1 : 0
                    visible: opacity > 0
                    
                    clip: true
                    
                    orientation: ListView.Horizontal
                    
                    spacing: control.spacing
                    
                    model: control.contentModel
                    currentIndex: control.currentIndex
                    
                    interactive: Maui.Handy.isMobile
                    snapMode: ListView.SnapOneItem
                    
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0
                    highlightResizeDuration : 0
                    
                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement: Flickable.StopAtBounds
                    
                    keyNavigationEnabled : true
                    keyNavigationWraps : true
                    
                    onMovementEnded:
                    {
                        const newIndex = indexAt(contentX, contentY)
                        control.newTabFocused(newIndex)
                    }
                    
                    moveDisplaced: Transition
                    {
                        NumberAnimation { properties: "x"; duration: Maui.Style.shortDuration }
                    }
                    
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
            
            Loader
            {
                active: control.showNewTabButton
                visible: active
                asynchronous: true
                
                sourceComponent: QQC.ToolButton
                {
                    icon.name: "list-add"
                    onClicked: control.newTabClicked()
                    flat: true
                }
            }
            
            Private.ToolBarSection
            {
                id: _rightLayout
                spacing: control.spacing
                Layout.fillHeight: true
                Layout.maximumWidth: implicitWidth
                Layout.minimumWidth: implicitWidth
            }
            
            Loader
            {
                active: control.Maui.Controls.showCSD === true
                visible: active
                
                asynchronous: true
                
                sourceComponent: Maui.WindowControls {}
            }
        }
    }
    
    /**
     * @brief Positions the TabButton at the given index to be centered and visible in the viewport.
     */
    function positionViewAtIndex(index)
    {
        _content.positionViewAtIndex(index, ListView.SnapPosition)
    }
    
    function itemAt(x, y)
    {
        return _content.itemAt(x,y)
    }
}
