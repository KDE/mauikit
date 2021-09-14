import QtQuick 2.13
import QtQuick.Controls 2.3

import org.mauikit.controls 1.3 as Maui

/*!
 *  \since org.mauikit.controls.labs 1.0
 *  \inqmlmodule org.mauikit.controls.labs
 */
Loader
{
    id: control

    active: Maui.App.controls.enableCSD
    visible: buttonsModel.length && active

    required property int side

    readonly property var buttonsModel : control.side === Qt.LeftEdge ?  Maui.App.controls.leftWindowControls :  Maui.App.controls.rightWindowControls


    /**
     *
     */
    signal buttonClicked(var type)

    source: Maui.App.controls.source
}
