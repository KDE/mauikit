import QtQuick 2.14
import QtQuick.Controls 2.14
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.2 as Maui

import TagsList 1.0
import "."

Maui.ListBrowser
{
    id: control
    orientation: ListView.Horizontal
    spacing: Maui.Style.contentMargins
    implicitHeight: Maui.Style.toolBarHeight
    horizontalScrollBarPolicy: ScrollBar.AlwaysOff
    snapMode: ListView.SnapOneItem
    verticalScrollBarPolicy: ScrollBar.AlwaysOff
    
    /**
      *
      */
    property string placeholderText: i18n("Add tags...")

    /**
      *
      */
    property alias list : _tagsList

    /**
      *
      */
    property bool showPlaceHolder:  true

    /**
      *
      */
    property bool showDeleteIcon: true

    /**
      *
      */
    signal tagRemoved(int index)

    /**
      *
      */
    signal tagClicked(int index)

    model: Maui.BaseModel
    {
        id: _tagsModel
        list: TagsList
        {
            id: _tagsList
        }
    }

    Label
    {
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        text: control.placeholderText
        opacity: 0.7
        visible: count === 0 && control.showPlaceHolder
        color: Kirigami.Theme.textColor
    }

    delegate: TagDelegate
    {
        showCloseButton: control.showDeleteIcon
        Kirigami.Theme.textColor: control.Kirigami.Theme.textColor
       
        ListView.onAdd:
        {
            control.flickable.positionViewAtEnd()
        }
        
        onRemoveTag: tagRemoved(index)
        onClicked: tagClicked(index)
    }
    
}
