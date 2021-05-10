import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.2 as Maui
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.filebrowsing 1.0 as FB

import "."

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
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
            _shareDialogLoader.item.mimeType = control.mimeType ? control.mimeType : FB.FM.getFileInfo(control.urls[0]).mime
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
