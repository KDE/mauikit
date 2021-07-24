import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQml 2.14

import org.kde.kirigami 2.14 as Kirigami
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
Item
{
    id: control
    implicitWidth: _loader.item.implicitWidth 
    implicitHeight: Maui.Style.rowHeight
    opacity: enabled ? 1 : 0.5
    
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    
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
    property int display: ToolButton.IconOnly
    
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
    //     border.color: control.flat ? "transparent" : Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))
    
    //radius: Maui.Style.radiusV
    //color: !control.enabled || control.flat ? "transparent" : Kirigami.Theme.backgroundColor
    
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
    
    Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
        sourceComponent: control.expanded ? _rowComponent : _menuComponent
    } 
    
    Component
    {
        id: _rowComponent
        
        Row
        {
            id: _row
            spacing: 2
            
            Behavior on width
            {
                NumberAnimation
                {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
            
            Repeater
            {
                id: _repeater
                model: control.actions
                
                Private.BasicToolButton
                {
                    id: _buttonMouseArea
                    
                    action : modelData
                    checkable: control.checkable && action.checkable
                    rec.radius: 0
                    rec.color: (hovered || checked || down) && checkable ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.15)  : Qt.lighter(Kirigami.Theme.backgroundColor)
                    rec.border.color: "transparent"
                    
                    Binding on checked
                    {
                        when: autoExclusive
                        value: control.currentIndex === index
                    }
                    
                    autoExclusive: control.autoExclusive
                    height: parent.height
                    width : implicitWidth + Maui.Style.space.medium
                    
                    enabled: action.enabled                    
                    
                    display: control.autoExclusive ? (checked && control.enabled ? control.display : ToolButton.IconOnly) : control.display
                    
                    icon.name: action.icon.name
                    icon.width:  action.icon.width ?  action.icon.width : Maui.Style.iconSizes.small
                    icon.height:  action.icon.height ?  action.icon.height : Maui.Style.iconSizes.small
                    
                    onClicked:
                    {
                        if(autoExclusive)
                            control.currentIndex = index
                    }
                    
                    background: Kirigami.ShadowedRectangle
                    {
                        color: checked || down ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.15) : Qt.lighter(Kirigami.Theme.backgroundColor)
                        
                        corners
                        {
                            topLeftRadius: index === 0 ? Maui.Style.radiusV : 0
                            topRightRadius: index === _repeater.count - 1 ? Maui.Style.radiusV : 0
                            bottomLeftRadius: index === 0 ? Maui.Style.radiusV : 0
                            bottomRightRadius:  index === _repeater.count - 1 ? Maui.Style.radiusV : 0
                        }
                    }
                }
            }
        }
    }
    
    Component
    {
        id: _menuComponent
        
        MouseArea
        {
            id: _defaultButtonMouseArea
            hoverEnabled: true
            implicitWidth: _defaultButtonLayout.implicitWidth
            
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
            
            onClicked: triggerAction()
            
            Maui.ContextualMenu
            {
                id: _menu
                
                Repeater
                {
                    model: control.actions
                    
                    MenuItem
                    {
                        enabled: modelData.enabled
                        text: modelData.text
                        icon.name: modelData.icon.name
                        autoExclusive: control.autoExclusive
                        checked: index === control.currentIndex && control.checkable
                        checkable: control.checkable
                        onTriggered:
                        {
                            control.currentIndex = index
                            modelData.triggered()
                        }
                    }
                }
            }                
            
            RowLayout
            {
                id: _defaultButtonLayout
                height: parent.height
                spacing: 2
                
                Private.BasicToolButton
                {
                    id: _defaultButtonIcon
                    Layout.fillHeight: true
                    
                    property var m_item : buttonAction()
                    property Action m_action : m_item.action
                    
                    onClicked: triggerAction()                    
                    
                    icon.width:  Maui.Style.iconSizes.small
                    icon.height: Maui.Style.iconSizes.small
                    icon.color: m_action ? (m_action.icon.color && m_action.icon.color.length ? m_action.icon.color : ( _defaultButtonMouseArea.containsPress ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor)) :  control.Kirigami.Theme.textColor
                    
                    icon.name: m_action ? m_action.icon.name : control.defaultIconName
                    
                    enabled: m_action ? m_action.enabled : true
                    
                    text: m_action ?  m_action.text : ""
                    
                    display: control.display  
                    
                    checkable: control.checkable && action.checkable
                    
                    background: Kirigami.ShadowedRectangle
                    {
                        color: Qt.lighter(Kirigami.Theme.backgroundColor)
                        
                        corners
                        {
                            topLeftRadius: Maui.Style.radiusV
                            topRightRadius: 0
                            bottomLeftRadius: Maui.Style.radiusV
                            bottomRightRadius: 0
                        }
                    }
                }
                
                Kirigami.ShadowedRectangle
                {
                    visible: !control.canCyclic
                    Layout.fillHeight: true
                    Layout.preferredWidth: visible ? Maui.Style.iconSizes.small : 0
                    
                    color: Qt.lighter(Kirigami.Theme.backgroundColor)
                    
                    corners
                    {
                        topLeftRadius: 0
                        topRightRadius: Maui.Style.radiusV
                        bottomLeftRadius: 0
                        bottomRightRadius: Maui.Style.radiusV
                    }
                    
                    Maui.Triangle
                    {
                        anchors.centerIn: parent
                        rotation: -45
                        color: _defaultButtonIcon.icon.color
                        width: Maui.Style.iconSizes.tiny-3
                        height:  width
                    }
                }
            }
        }
    }
}
