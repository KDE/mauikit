import QtQuick

import QtQuick.Layouts
import QtQuick.Controls

import org.mauikit.controls as Maui

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Pane
{
    id: control
    
    /**
     *
     */
    default property alias content : _layout.data

    /**
         *
         */
    property string title

    /**
         *
         */
    property string description

    /**
         *
         */
    property alias template: _template

    /**
         *
         */
    spacing: Maui.Style.defaultSpacing

    Layout.fillWidth: true
    padding: 0

    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    background: null

    contentItem: ColumnLayout
    {
        id: _layout

        spacing: control.spacing

        Maui.SectionHeader
        {
            id: _template
            Layout.fillWidth: true
            label1.text: control.title
            label2.text: control.description
            template.iconSizeHint: Maui.Style.iconSizes.medium
        }
    }
}
