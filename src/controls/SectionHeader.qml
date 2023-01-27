import QtQuick 2.15
import QtQuick.Controls 2.15

import org.mauikit.controls 1.2 as Maui
import QtQuick.Templates 2.15 as T

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/

T.Control
{
    id: control

    property alias template : _template
    property alias label1 : _template.label1
    property alias label2 : _template.label2
    
    implicitHeight: _template.implicitHeight + topPadding + bottomPadding
    
    padding: Maui.Style.defaultPadding
    spacing: padding   
    
    contentItem: Maui.ListItemTemplate
    {
        id: _template

        label1.font.pointSize: Maui.Style.fontSizes.big
        label1.font.weight: Font.DemiBold
        label2.wrapMode: Text.WordWrap
        label1.color: Maui.Theme.textColor
        isMask: iconSizeHint <= 22
spacing: control.spacing
    }
    }
