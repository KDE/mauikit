import org.mauikit.controls 1.3 as Maui
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

Maui.ScrollColumn
{
    id: control
    spacing: Maui.Style.defaultSpacing*2
    
    property string title : i18nd("mauikit", "Settings")
}
