import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    Maui.Controls.status: Maui.Controls.Negative

    Maui.SectionGroup
    {
        title: i18n("Page")
        spacing: control.spacing
        
        DemoSection
        {
            title: "Maui Page"
            body: i18n("A pane based page with movable toolbars, pullback toolbars effects, and much more")
            
            sampleText: 'import org.mauikit.controls as Maui
            Maui.Page
            {
                title: i18n("Title")
                
                headBar.leftContent : Switch
                {}
                
                headBar.rightContent: Button
                {
                    text: "Hello!"
                }
            }'
            
            column: Maui.Page
            {
                id: _page
                Layout.fillWidth: true
                implicitHeight: 500
                Maui.Controls.level: Maui.Controls.Primary
                Maui.Controls.status: Maui.Controls.Negative
                title: i18n("Title")
                
                headBar.leftContent : Switch
                {}
                
                headBar.rightContent: Button
                {
                    text: "Hello!"
                    onClicked: _page.altHeader = !_page.altHeader
                }
                
                Maui.Holder
                {
                    anchors.fill: parent
                    emoji: "dialog-info"
                    isMask: false
                    title:  i18n("Maui Page")
                    body: i18n("Something to say here!")
                }
            }
        }
        
        DemoSection
        {
            title: "Page"
            body: i18n("A QQC page.")
            
            column: Page
            {
                Layout.fillWidth: true
                implicitHeight: 500
                
                title: i18n("Title")
                
                header: ToolBar
                {
                    width: parent.width
                }
                
                footer: ToolBar
                {
                    width: parent.width
                }
                
                Maui.Holder
                {
                    anchors.fill: parent
                    title:  i18n("QQC Page")
                    body: i18n("Something to say here!")
                }
            }
        }
        
        DemoSection
        {
            title: "PageLayout"
            body: i18n("A pane based page with movable toolbars, pullback toolbars effects, and much more")
            
            sampleText: 'import org.mauikit.controls as Maui
            Maui.Page
            {
                title: i18n("Title")
                
                headBar.leftContent : Switch
                {}
                
                headBar.rightContent: Button
                {
                    text: "Hello!"
                }
            }'
            
            column: Maui.PageLayout
            {
                id: _pageLayout
                Layout.fillWidth: true
                implicitHeight: 500
                
                split: width < 800
                
                leftContent : [
                    Switch {},
                    Switch {}
                ]
                
                rightContent: [
                    Button
                    {
                        text: "Hello!"
                        onClicked: _page.altHeader = !_page.altHeader
                    },
                    
                    Button
                    {
                        text: "Hello!"
                        onClicked: _page.altHeader = !_page.altHeader
                    }
                ]
                
                middleContent: Maui.SearchField
                {
                    Layout.maximumWidth: _pageLayout.split ? -1 : 500
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Maui.Holder
                {
                    anchors.fill: parent
                    emoji: "dialog-info"
                    isMask: false
                    title:  i18n("Maui Page")
                    body: i18n("Somethign to say here!")
                }
            }
        }

        DemoSection
        {
            title: "Maui Page"
            body: i18n("Floating & auto-hide bars demo")

            sampleText: 'import org.mauikit.controls as Maui
            Maui.Page
            {
                title: i18n("Title")

                headBar.leftContent : Switch
                {}

                headBar.rightContent: Button
                {
                    text: "Hello!"
                }
            }'

            column: Maui.Page
            {
                id: _page2
                Layout.fillWidth: true
                implicitHeight: 500
                Maui.Controls.level: Maui.Controls.Primary
                title: i18n("Title")

                floatingHeader: _floatSwitch.checked
                autoHideHeader:_hideSwitch.checked

                floatingFooter: _floatSwitch2.checked
                autoHideFooter:_hideSwitch2.checked

                headBar.leftContent : Switch
                {
                    id: _floatSwitch
                    text: i18n("Float")
                    checked: _page2.floatingHeader
                }

                headBar.rightContent : Switch
                {
                    id: _hideSwitch
                    text: i18n("Auto hide")
                    checked: _page2.autoHideHeader
                }


                footBar.leftContent : Switch
                {
                    id: _floatSwitch2
                    text: i18n("Float")
                    checked: _page2.floatingFooter
                }

                footBar.rightContent : Switch
                {
                    id: _hideSwitch2
                    text: i18n("Auto hide")
                    checked: _page2.autoHideFooter
                }

                Image
                {
                    anchors.fill: parent
                    source: "qrc:/assets/6588168.jpg"
                    fillMode: Image.PreserveAspectCrop
                }
            }
        }
    }
}
