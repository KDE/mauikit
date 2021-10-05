import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

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
    default property list<Maui.ToolButtonAction> mauiActions
    actions:  mauiActions
}
