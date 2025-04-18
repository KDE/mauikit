import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml

import org.mauikit.controls as Maui
import "private" as Private

/**
 * @inherit QtQuick.Controls.Control
 * @brief A set of grouped action visually joined together.
 *
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-control.html">This control inherits from QQC2 Control, to checkout its inherited properties refer to the Qt Docs.</a>
 *
 * The set actions can be checkable and auto-exclusive or not.
 *
 * @image html Misc/toolactions.png "[1] Non-checkable. [2] Checkable non-auto-exclusive. [3] Checkable and autoexclusive"
 *
 * @section features Features
 * This control supports checkable and non-checkable actions. Also auto-exclusive and non-auto-exclusive actions.
 *
 * When enabling the `autoExclusive` property, then only one action in the group can be marked as checked at the time.
 *
 * There is also the option to collapse the actions into a single button with a popup menu where the actions are listed, this is useful when the available space changes and the control needs to be made more compact to save space.
 *
 * @image html Misc/toolactions2.png "The collapsed actions into a menu"
 *
 * If only two actions are added and marked as auto-exclusive, then this control has the option to enable a `cyclic` behavior, which means that toggling one button will activate the next action in line and cyclic around.
 * @see canCyclic
 * @see cyclic
 *
 * Heres a example of how to achieve such behavior:
 * @code
 * Maui.ToolActions
 * {
 *    id: _actions
 *    checkable: true
 *    autoExclusive: true
 *    cyclic: true //enable the cyclic behavior
 *    expanded: false //the cyclic behavior needs to be in the collapsed mode
 *
 *    property int currentAction: 0 //here we keep the state for the current action checked
 *
 *    Action
 *    {
 *        id: _action1
 *        icon.name: "view-list-details"
 *        checked: _actions.currentAction === 0
 *        onTriggered:
 *        {
 *            _actions.currentAction = 0
 *        }
 *    }
 *
 *    Action
 *    {
 *        id: _action2
 *        icon.name: "view-list-icons"
 *        checked: _actions.currentAction === 1
 *        onTriggered:
 *        {
 *            _actions.currentAction = 1
 *        }
 *    }
 * }
 * @endcode
 *
 * @code
 * Maui.ToolActions
 * {
 *    checkable: true
 *    autoExclusive: true
 *
 *    Action
 *    {
 *        text: "Pick"
 *    }
 *
 *    Action
 *    {
 *        text: "Only"
 *    }
 *
 *    Action
 *    {
 *        text: "One"
 *    }
 * }
 * @endcode
 *
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/ToolActions.qml">You can find a more complete example at this link.</a>
 */
Control
{
    id: control
    
    implicitWidth: _loader.implicitWidth + leftPadding + rightPadding
    implicitHeight: _loader.implicitHeight + topPadding + bottomPadding
    
    opacity: enabled ? 1 : 0.5
    
    spacing: 2
    padding: 0
    
    font.pointSize: Maui.Style.fontSizes.small
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    
    /**
     * @brief The list of QQC2 Action to be listed. These can be declared a children elements of this control.
     */
    default property list<Action> actions
    
    /**
     * @brief Whether this control should only allow one action to be checked at the time.
     * By default this is set to `true`
     */
    property bool autoExclusive: true
    
    /**
     * @brief Whether the action button can be checked. If enabled, then the state will be styled accordingly.
     * @By default this is set to `true`.
     */
    property bool checkable: true
    
    /**
     * @brief Options on how to display the button text and icon.
     * Available options are:
     * - ToolButton.IconOnly
     * - ToolButton.TextBesideIcon
     * - ToolButton.TextOnly
     * - ToolButton.TextUnderIcon
     * By default this is set to `ToolButton.TextBesideIcon`
     */
    property int display: ToolButton.TextBesideIcon
    
    /**
     * @brief Whether two actions can be triggered in a cyclic manner. So one press will activate the next action and then cycle around to the first one again.
     * @note For this to work only two actions can be added
     * @see canCyclic
     * By default this is set to `false`
     */
    property bool cyclic: false
    
    /**
     * @brief Whether the `cyclic` behavior can be activated.
     * For it to be possible, the conditions are: only two actions and those must be auto-exclusive.
     * @see cyclic
     * @see autoExclusive
     * @see count
     */
    readonly property bool canCyclic : control.cyclic && control.count === 2  && control.autoExclusive
    
    /**
     * @brief Whether the style of this control should be styled as flat.
     * By default this is set to `false`.
     */
    property bool flat : false
    
    /**
     * @brief The total amount of actions declared.
     */
    readonly property int count : actions.length
    
    
    /**
     * @brief Whether the control should display all the actions as buttons in a  row, or to collapse them into a popup menu.
     * By default this is set to `true`.
     */
    property bool expanded : true
    
    /**
     * @brief The icon name to be used in the button that opens the menu popup, when the view is collapsed.
     * By default this is set to `application-menu`.
     */
    property string defaultIconName: "application-menu"
    
    /**
     * @brief Forces to uncheck all the actions except the one action sent as the argument.
     * @param except the action that should not be unchecked.
     */
    function uncheck(except)
    {
        for(var i in control.actions)
        {
            if(control.actions[i] === except)
            {
                continue
            }
            
            control.actions[i].checked = false
        }
    }
    
    Behavior on implicitWidth
    {
        NumberAnimation
        {
            duration: Maui.Style.units.shortDuration
            easing.type: Easing.InQuad
        }
    }   
    
    contentItem: Loader
    {
        id: _loader
        asynchronous: true
        sourceComponent: control.expanded ? _rowComponent : (control.canCyclic ? _buttonComponent : _toolButtonMenuComponent)        
    }
    
    background: null
    
    Component
    {
        id: _rowComponent
        
        Row
        {
            id: _row
            property int biggerHeight : 0
            spacing: control.spacing
            
            Behavior on width
            {
                enabled: Maui.Style.enableEffects
                
                NumberAnimation
                {
                    duration: Maui.Style.units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }
            
            function calculateBiggerHeight()
            {
                var value = 0
                for(var i in _row.children)
                {
                    const height = _row.children[i].implicitHeight
                    if(height > value)
                    {
                        value = height
                    }
                }
                
                return value
            }
            
            Repeater
            {
                id: _repeater
                model: control.actions
                
                ToolButton
                {
                    id: _actionButton
                    action : modelData
                    Maui.Controls.status: control.Maui.Controls.status
                    
                    checkable: control.checkable || action.checkable
                    
                    height: Math.max(implicitHeight, _row.biggerHeight)
                    
                    onImplicitHeightChanged: _row.biggerHeight = _row.calculateBiggerHeight()
                    
                    autoExclusive: control.autoExclusive
                    enabled: action.enabled
                    
                    display: control.display
                    font: control.font
                    
                    background: Maui.ShadowedRectangle
                    {
                        color:  (checked || down ? Maui.Theme.highlightColor : ( hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor))
                        corners
                        {
                            topLeftRadius: index === 0 ? Maui.Style.radiusV : 0
                            topRightRadius: index === _repeater.count - 1 ? Maui.Style.radiusV : 0
                            bottomLeftRadius: index === 0 ? Maui.Style.radiusV : 0
                            bottomRightRadius:  index === _repeater.count - 1 ? Maui.Style.radiusV : 0
                        }
                        
                        Behavior on color
                        {
                            Maui.ColorTransition{}
                        }
                        
                        Behavior on border.color
                        {
                            Maui.ColorTransition{}
                        }
                        
                        border.color: statusColor(_actionButton)
                        
                        function statusColor(control)
                        {
                            if(control.Maui.Controls.status)
                            {
                                switch(control.Maui.Controls.status)
                                {
                                    case Maui.Controls.Positive: return control.Maui.Theme.positiveBackgroundColor
                                    case Maui.Controls.Negative: return control.Maui.Theme.negativeBackgroundColor
                                    case Maui.Controls.Neutral: return control.Maui.Theme.neutralBackgroundColor
                                    case Maui.Controls.Normal:
                                    default:
                                        return "red"
                                }
                            }
                            
                            return "red"
                        }
                    }
                }
            }
        }
    }
    
    Component
    {
        id: _toolButtonMenuComponent
        
        Maui.ToolButtonMenu
        {
            Maui.Controls.status: control.Maui.Controls.status
            flat: false
            property Action m_action
            hoverEnabled: true
            display: control.display
            icon.name: m_action ? m_action.icon.name : control.defaultIconName
            text: m_action ? m_action.text: ""
            
            Component.onCompleted:
            {
                m_action = buttonAction()
            }
            
            Repeater
            {
                model: control.autoExclusive && control.canCyclic ? undefined : control.actions
                
                delegate: MenuItem
                {
                    action: modelData
                    enabled: modelData.enabled
                    autoExclusive: control.autoExclusive
                    checkable: control.checkable || action.checkable
                }
            }
            
            Row
            {
                visible: false
                Repeater
                {
                    model: control.actions
                    delegate: Item
                    {
                        property bool checked : modelData.checked
                        onCheckedChanged: m_action = buttonAction()
                    }
                }
            }
            
            function buttonAction()
            {
                if(control.autoExclusive)
                {
                    var currentAction
                    var actionIndex = -1
                    for(var i in control.actions)
                    {
                        console.log("Checking current action", i)
                        if(control.actions[i].checked)
                        {
                            actionIndex = i
                            currentAction = control.actions[actionIndex]
                            console.log("Found current action", i, actionIndex)
                            return currentAction
                        }
                    }
                }
                
                return null
            }
        }
    }
    
    Component
    {
        id: _buttonComponent
        
        Button
        {
            id: _defaultButtonIcon
            Maui.Controls.status: control.Maui.Controls.status
            
            property Action m_action
            
            function buttonAction()
            {
                if(control.autoExclusive)
                {
                    var currentAction
                    var actionIndex = -1
                    for(var i in control.actions)
                    {
                        console.log("Checking current action", i)
                        if(control.actions[i].checked)
                        {
                            actionIndex = i
                            currentAction = control.actions[actionIndex]
                            console.log("Found current action", i, actionIndex)
                        }
                    }
                    
                    if(control.canCyclic)
                    {
                        actionIndex++
                        
                        let m_index = actionIndex >= control.actions.length ? 0 : actionIndex
                        //
                        console.log("Setting current action at", m_index)
                        if(control.actions[m_index].enabled)
                        {
                            return control.actions[m_index];
                        }
                    }
                    
                    return currentAction
                }
                
                return null
            }
            
            Row
            {
                visible: false
                Repeater
                {
                    model: control.actions
                    delegate: Item
                    {
                        property bool checked : modelData.checked
                        onCheckedChanged: _defaultButtonIcon.m_action = _defaultButtonIcon.buttonAction()
                    }
                }
            }
            
            onClicked:
            {
                if(_defaultButtonIcon.m_action && control.canCyclic)
                {
                    console.log("Trigger next cyclic action", _defaultButtonIcon.m_action.icon.name)
                    // var previousAction = _defaultButtonIcon.action
                    _defaultButtonIcon.m_action.triggered()
                    _defaultButtonIcon.m_action = _defaultButtonIcon.buttonAction()                    
                }
            }
            
            icon.color:  m_action ? (m_action.icon.color && m_action.icon.color.length ? m_action.icon.color : (pressed || checked ? control.Maui.Theme.highlightedTextColor : control.Maui.Theme.textColor)) :  control.Maui.Theme.textColor
            
            icon.name: m_action ? m_action.icon.name : control.defaultIconName
            text: m_action ? m_action.text: ""
            
            enabled: m_action ? m_action.enabled : true
            
            Component.onCompleted:
            {
                _defaultButtonIcon.m_action = _defaultButtonIcon.buttonAction()
            }
            
            display: control.display
            
            checkable: control.checkable && (action ? action.checkable : false)
        }
    }
}
