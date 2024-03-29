import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

Maui.SectionItem
{
    id: control

    default property alias content : _content.data
    property alias column : _column.data

    property string title
    property string body

    property alias sampleText : _textArea.text

    label1.text: control.title
    label2.text: control.body
    flat: false

    Flow
    {
        id: _content
        Layout.fillWidth: true
        spacing: control.spacing
        visible: children.length > 0

    }

    ColumnLayout
    {
        id: _column
        Layout.fillWidth: true

        visible: children.length > 0
    }

    Item
    {
        Layout.fillWidth: true
        implicitHeight: Maui.Style.space.big
    }

    Label
    {
        visible: _textArea.visible
        Layout.fillWidth: true
        text: i18n("Sample Code")
        font: Maui.Style.h2Font
    }

    TextArea
    {
        id: _textArea
        visible: text.length > 0
        readOnly: true
        font.family: "Monospace"
        //        Layout.minimumHeight: 300
        Layout.fillWidth: true
        hoverEnabled: true

        Maui.Chip
        {
            visible: parent.hovered
            text: i18n("Copy")
            color: Maui.Theme.positiveBackgroundColor
            onClicked: Maui.Handy.copyTextToClipboard(_textArea.text)
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Maui.Style.space.big
        }
    }

}
