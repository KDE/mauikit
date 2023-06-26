import org.mauikit.controls 1.3 as Maui
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQuick 2.13

Loader
{
    id: control
    
    focus: true
    active: ListView.isCurrentItem || item
    
    // default property alias content: control.sourceComponent
    
}
