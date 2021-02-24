import QtQuick 2.14
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.8 as Kirigami

/**
 * A visual separator
 *
 * Useful for splitting one set of items from another.
 *
 * @inherit QtQuick.Rectangle
 */

Loader
{
    id: control

    sourceComponent: switch(control.edge)
                     {
                         case Qt.TopEdge: return _horizontalSepBottom
                         case Qt.BottomEdge: return    _horizontalSepTop
                         case Qt.LeftEdge: return _verticalSepRight
                         case Qt.RightEdge: return _verticalSepLeft
                         default: return null
                     }
                     
    /**
      *
      */
    property int edge : Qt.TopEdge
    
    
    /**
     * 
     */
    property int radius : 0
    
    /**
      *
      */
    property color color : Kirigami.Theme.backgroundColor

    Component
    {
        id: _horizontalSepTop
        ColumnLayout
        {
            spacing: 0
            opacity: 0.5

            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.8
                color: Qt.lighter(control.color, 2.5)
                Layout.fillWidth: true
                radius: control.radius
            }
            
            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.9
                color: Qt.darker(control.color, 2.5)
                Layout.fillWidth: true
                radius: control.radius
            }                 
        }
    }
    
    Component
    {
        id: _horizontalSepBottom
        ColumnLayout
        {
            spacing: 0
            opacity: 0.5
            
            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.9
                color: Qt.darker(control.color, 2.5)
                Layout.fillWidth: true
                radius: control.radius
            }            
            
            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.8
                color: Qt.lighter(control.color, 2.5)
                Layout.fillWidth: true
                radius: control.radius
            }
        }
    }

    Component
    {
        id: _verticalSepLeft
        
        RowLayout
        {
            spacing: 0
            opacity: 0.5
            
            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.8
                color: Qt.lighter(control.color, 2.5)
                Layout.fillHeight: true
                radius: control.radius
            }
            
            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.9
                color: Qt.darker(control.color, 2.5)
                Layout.fillHeight: true
                radius: control.radius
            }
        }
    }
    
    Component
    {
        id: _verticalSepRight

        RowLayout
        {
            spacing: 0
            opacity: 0.5

            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.9
                color: Qt.darker(control.color, 2.5)
                Layout.fillHeight: true
                radius: control.radius
            }
            
            Kirigami.Separator
            {
                implicitWidth: 1
                implicitHeight: 1
                opacity: 0.8
                color: Qt.lighter(control.color, 2.5)
                Layout.fillHeight: true
                radius: control.radius
            }          
        }
    }
}
