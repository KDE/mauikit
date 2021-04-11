import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.0 as Maui
import org.mauikit.controls 1.1 as MauiLab

/*!
  \since org.kde.mauikit.labs 1.0
  \inqmlmodule org.kde.mauikit.labs
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
