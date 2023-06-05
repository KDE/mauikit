import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml

import QtQuick.Templates as T

import org.mauikit.controls as Maui

/**
 * ToolActions
 * A global sidebar for the application window that can be collapsed.
 *
 *
 *
 *
 *
 *
 */
T.Control
{
    id: control
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    
    opacity: enabled ? 1 : 0.5
    
    spacing: 2
    padding: 0
    
    Maui.Theme.colorSet: Maui.Theme.Button
    Maui.Theme.inherit: false
    /**
     * actions : list<Action>
     */
    default property list<Action> actions
    
    /**
     * autoExclusive : bool
     */
    property bool autoExclusive: true
    
    /**
     * checkable : bool
     */
    property bool checkable: true
    
    /**
     * display : int
     */
    property int display: ToolButton.TextBesideIcon
    
    /**
     * cyclic : bool
     */
    property bool cyclic: false
    
    readonly property bool canCyclic : control.cyclic && control.count === 2  && control.autoExclusive
    
    /**
     * flat : bool
     */
    property bool flat : false
    
    /**
     * count : int
     */
    readonly property int count : actions.length
    

    /**
     * expanded : bool
     */
    property bool expanded : true
    
    /**
     * defaultIconName : string
     */
    property string defaultIconName: "application-menu"
    //     border.color: control.flat ? "transparent" : Qt.tint(Maui.Theme.textColor, Qt.rgba(Maui.Theme.backgroundColor.r, Maui.Theme.backgroundColor.g, Maui.Theme.backgroundColor.b, 0.7))
    
    //radius: Maui.Style.radiusV
    //color: !control.enabled || control.flat ? "transparent" : Maui.Theme.backgroundColor

    
    /**
     *
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
    
    contentItem: Loader
    {
        id: _loader
        asynchronous: true
        sourceComponent: control.expanded ? _rowComponent : _buttonComponent
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
                    checkable: control.checkable || action.checkable
                    
                    height: Math.max(implicitHeight, _row.biggerHeight)
                    
                    onImplicitHeightChanged: _row.biggerHeight = _row.calculateBiggerHeight()

                    autoExclusive: control.autoExclusive
                    enabled: action.enabled
                    
                    display: control.display
                    
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
                    }
                }
            }
        }
    }
    
    Component
    {
        id: _buttonComponent
        
        ToolButton
        {
            id: _defaultButtonIcon

            property Action m_action

            Component.onCompleted: _defaultButtonIcon.m_action = _defaultButtonIcon.buttonAction()

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


            data: Maui.ContextualMenu
            {
                id: _menu

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
            }

            onClicked:
            {
                if(_defaultButtonIcon.m_action && control.canCyclic && control.autoExclusive)
                {
                    console.log("Trigger next cyclic action", _defaultButtonIcon.m_action.icon.name)
                    // var previousAction = _defaultButtonIcon.action
                    _defaultButtonIcon.m_action.triggered()
                    _defaultButtonIcon.m_action = _defaultButtonIcon.buttonAction()

                }else
                {
                    if(!_menu.visible)
                    {
                        _menu.show(0, control.height, control)

                    }else
                    {
                        _menu.close()
                    }
                }
            }

            icon.width:  Maui.Style.iconSize
            icon.height: Maui.Style.iconSize
            icon.color: m_action ? (m_action.icon.color && m_action.icon.color.length ? m_action.icon.color : (pressed ? control.Maui.Theme.highlightColor : control.Maui.Theme.textColor)) :  control.Maui.Theme.textColor

            icon.name: m_action ? m_action.icon.name : control.defaultIconName
            text: m_action ? m_action.text: ""

            enabled: m_action ? m_action.enabled : true

//            subMenu: !control.canCyclic

            display: control.display

            checkable: control.checkable && (action ? action.checkable : false)

            background: Rectangle
            {
                color: Maui.Theme.backgroundColor
                radius: Maui.Style.radiusV

                Behavior on color
                {
                    Maui.ColorTransition{}
                }
            }
        }
        
    }
}
