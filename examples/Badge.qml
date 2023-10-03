import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui

Maui.ApplicationWindow
{
    id: root

    Maui.AppViews
    {
        id: _page
        anchors.fill: parent
        Maui.Controls.showCSD: true
        headBar.forceCenterMiddleContent: true

       Maui.AppViewLoader
       {
           Maui.AppView.title: "View1"
           Maui.AppView.iconName: "love"

           Pane
           {

               Column
               {
                   anchors.centerIn: parent

                   spacing: Maui.Style.space.big
                   Button
                   {
                       text: "Example1"

                       Maui.Badge
                       {
                            icon.name: "actor"
                            color: Maui.Theme.neutralBackgroundColor
                            anchors.horizontalCenter: parent.right
                            anchors.verticalCenter: parent.top
                       }
                   }

                   Button
                   {
                       text: "Example2"

                       Maui.Badge
                       {
                            text: "@"
                            anchors.horizontalCenter: parent.right
                            anchors.verticalCenter: parent.top
                       }
                   }

                   Button
                   {
                       text: "Example3"

                       Maui.Badge
                       {
                            icon.name:"anchor"
                            size: Maui.Style.iconSizes.medium
                            color: Maui.Theme.positiveBackgroundColor
                            anchors.horizontalCenter: parent.right
                            anchors.verticalCenter: parent.top
                       }
                   }

                   Maui.Badge
                   {
                       text: "+200"
                   }
               }


           }
       }

       Maui.AppViewLoader
       {
           Maui.AppView.title: "View2"
           Maui.AppView.iconName: "folder"
           Maui.AppView.badgeText: "30"

           Rectangle
           {
               color: "pink"
           }
       }

       Maui.AppViewLoader
       {
           Maui.AppView.title: "View3"
           Maui.AppView.iconName: "tag"

           Rectangle
           {
               color: "green"
           }
       }
    }
}
