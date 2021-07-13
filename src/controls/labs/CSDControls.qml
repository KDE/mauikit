import QtQuick 2.13
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

import QtGraphicalEffects 1.0

import org.mauikit.controls 1.3 as Maui
import org.kde.kirigami 2.7 as Kirigami

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Loader
{
    id: control

    active: Maui.App.controls.enableCSD
    visible: model.length && active

    required property int side

    readonly property var model : control.side === Qt.LeftEdge ?  Maui.App.controls.leftWindowControls :  Maui.App.controls.rightWindowControls


    /**
     *
     */
    signal buttonClicked(var type)


    sourceComponent: Item
    {
        implicitHeight: visible ? Maui.Style.iconSizes.medium : 0
        implicitWidth: visible ? _row.implicitWidth : 0

        visible: control.model.length > 0

        Row
        {
            id: _row
            height: parent.height
            spacing: Maui.Style.space.medium

            Repeater
            {
                model: control.model
                delegate: pluginButton
            }
        }

        Component
        {
            id: pluginButton

            AbstractButton
            {
                id: _button
                hoverEnabled: true
                width: 22
                height: 22

                Maui.CSDButton
                {
                    id: button
                    type: mapControl(modelData)
                    isHovered: _button.hovered
                    isPressed: _button.pressed
                    isFocused:  root.active
                    isMaximized: root.visibility === Window.Maximized

                }

                contentItem: Item
                {
                    Kirigami.Icon
                    {
                        width: 16
                        height: 16
                        source: button.source
                        anchors.centerIn: parent
                    }
                }
                onClicked: buttonClicked(button.type)
            }
        }

        function mapControl(key)
        {
            switch(key)
            {
            case "X": return  Maui.CSDButton.Close;
            case "I": return  Maui.CSDButton.Minimize;
            case "A": return  Maui.CSDButton.Maximize;
            default: return null;
            }
        }
    }
}
