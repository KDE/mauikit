import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/

Pane
{
    id: control

    property alias template : _template
    property alias label1 : _template.label1
    property alias label2 : _template.label2
    
    implicitHeight: _template.implicitHeight + topPadding + bottomPadding
    
    padding: Maui.Style.defaultPadding
    spacing: Maui.Style.space.small
    
    contentItem: Maui.ListItemTemplate
    {
        id: _template

        label1.font: Maui.Style.h2Font
        label2.wrapMode: Text.WordWrap
        label1.color: Maui.Theme.textColor
        isMask: iconSizeHint <= 22
        spacing: control.spacing
    }
    
    background: null
}
