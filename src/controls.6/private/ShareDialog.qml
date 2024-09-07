import QtQuick 2.14

import org.mauikit.controls 1.2 as Maui

import "."

/**
  * @since org.mauikit.controls 1.0
  * @brief A dialog listing the available services for sharing the given set of local files.
*/
Item
{
    id: control

    /**
      *
      */
    property var urls : []

    /**
      *
      */
    property string mimeType

    Loader
    {
        id: _shareDialogLoader
        // asynchronous: true
        active: !Maui.Handy.isAndroid
        source: "ShareDialogLinux.qml"
    }

    /**
      *
      */
    function open()
    {
        if(Maui.Handy.isLinux)
        {
            console.log(control.urls)
            _shareDialogLoader.item.urls = control.urls
            // _shareDialogLoader.item.mimeType = control.mimeType
            _shareDialogLoader.item.open()
            return;
        }
    }

    /**
      *
      */
    function close()
    {
        if(Maui.Handy.isLinux)
            _shareDialogLoader.item.close()
    }
}
