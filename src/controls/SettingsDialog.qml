import org.mauikit.controls 1.3 as Maui
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

/*!
  \since org.mauikit.controls 1.0
  \inqmlmodule org.mauikit.controls
*/
Maui.Dialog
{
    id: control
    
    default property alias content: _content.content
      property alias stackView: _stackView
      
      
    maxHeight: implicitHeight
    maxWidth: 500
    defaultButtons: false
    hint: 1
    page.title: _stackView.currentItem.title ?  _stackView.currentItem.title  : ""
    headBar.visible: true
    spacing: Maui.Style.space.huge
    
    headBar.leftContent: ToolButton
    {
      icon.name: "go-previous"
      visible: _stackView.depth >= 2
      onClicked: _stackView.pop()
    }

    stack: StackView
    {
      id: _stackView
      Layout.fillHeight: true
      Layout.fillWidth: true
      implicitHeight: initialItem.implicitHeight+topPadding +bottomPadding
      
      initialItem: Maui.SettingsPage
      {
        id:_content
        spacing: control.spacing
      }
      
    }
    
    function addPage(component)
    {
      _stackView.push(component)
    }
    
    
}
