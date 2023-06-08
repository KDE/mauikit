import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

Maui.SectionItem
{
    id: control

    default property alias content : _content.data

    property string title
    property string body

    property alias sampleText : _textArea.text

    label1.text: control.title
    label2.text: control.body
    columns: 1
    flat: false

    Flow
    {
        id: _content
        Layout.fillWidth: true
        spacing: control.spacing
    }

    TextArea
    {
        id: _textArea
        visible: text.length > 0
        readOnly: true
        font.family: "Monospace"
//        Layout.minimumHeight: 300
        Layout.fillWidth: true
    }

}
