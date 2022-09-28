import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml 2.14
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui

import "private" as Private

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
     * currentAction : Action
     */
    property Action currentAction : control.autoExclusive ? actions[Math.max(0, control.currentIndex)] : null
    
    /**
     * currentIndex : int
     */
    property int currentIndex : -1
    
    onCurrentIndexChanged:
    {
        if(control.autoExclusive && control.count > 0)
        {
            control.currentAction = actions[control.currentIndex]
        }
    }
    
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
    
    Component.onCompleted:
    {
        if(control.checkable && control.autoExclusive && control.currentIndex >= 0 && control.currentIndex < control.actions.length)
        {
            control.actions[control.currentIndex].checked = true
        }
    }
    
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
            spacing: control.spacing
            
            Behavior on width
            {
                enabled: Maui.Style.enableEffects
                
                NumberAnimation
                {
                    duration: Maui.Style.units.longDuration
                    easing.type: Easing.InOutQuad
                }
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
                    checked: action.checked
                    
                    Binding on checked
                    {
                        when: autoExclusive
                        value: control.currentIndex === index || _actionButton.checked
                    }
                    
                    autoExclusive: control.autoExclusive
                    enabled: action.enabled
                    
                    display: control.display
                    
                    icon.name: action.icon.name
                    icon.width:  action.icon.width ?  action.icon.width : Maui.Style.iconSize
                    icon.height:  action.icon.height ?  action.icon.height : Maui.Style.iconSize
                    
                    onClicked:
                    {
                        if(autoExclusive)
                            control.currentIndex = index
                    }
                    
                    background: Maui.ShadowedRectangle
                    {                        
                        color: checkable ? (checked || down ? Maui.Theme.highlightColor : ( hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor)) : Maui.Theme.backgroundColor
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
        
        T.Control
        {
            id: _defaultButtonMouseArea
            hoverEnabled: true
            implicitWidth: implicitContentWidth + leftPadding + rightPadding
            implicitHeight: implicitContentHeight + topPadding + bottomPadding
            
            function triggerAction()
            {
                if(control.canCyclic)
                {
                    const item = buttonAction()
                    const action = item.action
                    const index = item.index
                    
                    if(action.enabled)
                    {
                        control.currentIndex = index
                        action.triggered()
                    }
                    
                    return
                }
                
                if(!_menu.visible)
                {
                    _menu.show(0, control.height, control)
                    
                }else
                {
                    _menu.close()
                }
            }
            
            function buttonAction()
            {
                if(control.canCyclic)
                {
                    let index = control.currentIndex + 1
                    
                    index = index >= control.actions.length ? 0 : index
                    
                    if(control.actions[index].enabled)
                    {
                        var res = ({
                            'action' : control.actions[index],
                            'index': index
                        })
                        
                        return res;
                    }
                    
                    if(control.currentAction.enabled)
                    {
                        var res = ({
                            'action': control.currentAction,
                            'index': control.currentIndex
                        })
                        
                        return res;
                    }else
                    {
                        var res = ({
                            'action': control.actions[1],
                            'index': 1
                        })
                        
                        return res;
                    }
                }else
                {
                    var res = ({
                        'action': control.currentAction,
                        'index': control.currentIndex
                    })
                    
                    return res;
                }
            }
            
            //onClicked: _defaultButtonMouseArea.triggerAction()
            
            data: Maui.ContextualMenu
            {
                id: _menu
                
                Repeater
                {
                    model: control.actions
                    
                    MenuItem
                    {
                        action: modelData
                        enabled: modelData.enabled
                        text: modelData.text
                        icon.name: modelData.icon.name
                        autoExclusive: control.autoExclusive
                        checked: action.checked
                        
                        Binding on checked
                        {
                            when: autoExclusive
                            value: control.currentIndex === index
                        }
                        
                        checkable: control.checkable || modelData.checkable
                        onTriggered:
                        {
                            if(autoExclusive)
                                control.currentIndex = index
                                
                                //                             modelData.triggered()
                        }
                    }
                }
            }
            
            contentItem:  ToolButton
                {
                    id: _defaultButtonIcon
                                       
                    property var m_item : _defaultButtonMouseArea.buttonAction()
                    property Action m_action : m_item.action
                    
                    onClicked: _defaultButtonMouseArea.triggerAction()
                    
                    icon.width:  Maui.Style.iconSize
                    icon.height: Maui.Style.iconSize
                    icon.color: m_action ? (m_action.icon.color && m_action.icon.color.length ? m_action.icon.color : ( _defaultButtonMouseArea.containsPress ? control.Maui.Theme.highlightColor : control.Maui.Theme.textColor)) :  control.Maui.Theme.textColor
                    
                    icon.name: m_action ? m_action.icon.name : control.defaultIconName
                    
                    enabled: m_action ? m_action.enabled : true
                    
                    subMenu: !control.canCyclic
                    
                    text: m_action ?  m_action.text : ""
                    
                    display: control.display
                    
                    checkable: control.checkable && (m_action ? m_action.checkable : false)
                    
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
}
