import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        id: _page
        anchors.fill: parent

        Maui.Controls.showCSD: true

        floatingFooter: true
        flickable: _listBrowser.flickable //helps to keep the content from under the selectionbar at the end.

        headBar.leftContent: Switch
        {
            text: "Single selection"
            checked: _selectionBar.singleSelection
            onToggled: _selectionBar.singleSelection = !_selectionBar.singleSelection
        }

        Maui.ListBrowser
        {
            id: _listBrowser

            anchors.fill: parent

            model: 60

            delegate: Maui.ListBrowserDelegate
            {
                id: _delegate

                property string id : index // we need an unique ID for the selectionbar

                width: ListView.view.width

                label1.text: "An example delegate."
                label2.text: "The ID of this element is " + id

                iconSource: "folder"

                checkable: true

                Connections
                {
                    target: _selectionBar
                    function onUriRemoved(uri) //watch when a uri is removed from the selection bar
                    {
                        if(uri == _delegate.id)
                        {
                            _delegate.checked = false
                        }
                    }

                    function onUriAdded(uri) //watch when an uri is sucessfully added and mark the delegate as checked
                    {
                        if(uri == _delegate.id)
                        {
                            _delegate.checked = true
                        }
                    }

                    function onCleared() //watch when the selection has been cleared and uncheck all the delegates
                    {
                        _delegate.checked = false
                    }
                }

                onToggled: (state) =>
                           {
                               if(state)
                               {
                                   _selectionBar.append(_delegate.id, ({'title': "Testing"}))
                               }else
                               {
                                   _selectionBar.removeAtUri(_delegate.id)
                               }
                           } // when the item is toggled, we mark it as checked and add it to the selection bar, otherwise we unchecked it and remove it from selection.
            }
        }

        footer: Maui.SelectionBar
        {
            id: _selectionBar

            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width-(Maui.Style.space.medium*2), implicitWidth)
            maxListHeight: root.height - (Maui.Style.contentMargins*2)

            Action
            {
                icon.name: "love"
                onTriggered: console.log(_selectionBar.getSelectedUrisString())
            }

            Action
            {
                icon.name: "folder"
                onTriggered: console.log(_selectionBar.contains("0"))
            }

            Action
            {
                icon.name: "list-add"
            }

            onExitClicked: clear()
        }
    }
}

