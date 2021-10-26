
import QtQuick 2.9
import QtQuick.Layouts 1.3

Item
{
    id: control
    visible: _layout.children.length
    implicitWidth: _layout.implicitWidth
    implicitHeight: _layout.implicitHeight
    property alias spacing : _layout.spacing
    default property alias content : _layout.data
    property alias visibleChildren: _layout.visibleChildren
    property alias layout : _layout
        
    RowLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: control.spacing                               
    }  
}
