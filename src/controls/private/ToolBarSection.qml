
import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item
{
    id: control
    
    implicitWidth: _layout.implicitWidth
    property alias spacing : _layout.spacing
    default property alias content : _layout.data
    property alias visibleChildren: _layout.visibleChildren
    
    
    RowLayout
    {
        id: _layout
        anchors.fill: parent
        spacing: control.spacing                               
    }  
    
}
