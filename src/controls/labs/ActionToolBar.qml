import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.0 as Maui
import org.mauikit.controls 1.1 as MauiLab

/*!
  \since org.mauikit.controls.labs 1.0
  \inqmlmodule org.mauikit.controls.labs
*/
Kirigami.ActionToolBar
{
    id: control

    /*!
      List of actions on this toolbar.
    */
    default property list<MauiLab.ToolButtonAction> mauiActions
    actions:  mauiActions
}
