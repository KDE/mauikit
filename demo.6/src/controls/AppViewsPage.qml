import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("AppViews")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("Static")
            column: Maui.AppViews
            {
                id: _sideBar

                Layout.fillWidth: true
                implicitHeight: 500

                Rectangle
                {
                    Maui.AppView.title: i18n("Music")
                    Maui.AppView.iconName: "folder-music"
                    Maui.AppView.badgeText: "1+"

                    color: "blue"
                }

                Rectangle
                {
                    Maui.AppView.title: i18n("Downloads")
                    Maui.AppView.iconName: "folder-downloads"

                    color: "pink"
                }


                Rectangle
                {
                    Maui.AppView.title: i18n("Videos")
                    Maui.AppView.iconName: "folder-video"

                    color: "violet"
                }
            }
        }
    }
}
