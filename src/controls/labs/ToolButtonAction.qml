import QtQuick 2.9
import QtQuick.Controls 2.3

import org.kde.kirigami 2.7 as Kirigami

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Kirigami.Action
{
    id: control
    
    displayComponent: ToolButton
    {
        action: kirigamiAction
    }
}
