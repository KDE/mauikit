import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.mauikit 1.3 as Maui
import org.kde.kirigami 2.7 as Kirigami

Maui.Chip
{
    id: control

    /**
     * 
     */
    property int tagHeight: Maui.Style.rowHeightAlt
    implicitHeight: tagHeight
    
    /**
     * 
     */
    signal removeTag(int index)
    
    Kirigami.Theme.backgroundColor: model.color ? model.color : Qt.darker(Kirigami.Theme.backgroundColor, 1.1)
    
    onClose: removeTag(index)
    label.text: model.tag   
    
}
