import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    title: i18n("SideBarView")

    Maui.SectionGroup
    {
        title: control.title
        spacing: control.spacing

        DemoSection
        {
            title: i18n("Static")
            column: Maui.SideBarView
            {
                id: _sideBar

                Layout.fillWidth: true
                implicitHeight: 500

                sideBarContent: Pane
                {
                    anchors.fill: parent
                }

                Maui.Page
                {
                    anchors.fill: parent

                    headBar.leftContent: ToolButton
                    {
                        icon.name: _sideBar.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                        onClicked: _sideBar.sideBar.toggle()
                    }
                }
            }
        }
    }
}
