import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

DemoPage
{
    id: control
    Maui.Controls.status: Maui.Control.Negative

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
                
                Maui.Controls.status: Maui.Control.Negative
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
                    body: i18n("Somethign to say here!")
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
                    body: i18n("Somethign to say here!")
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
                    Layout.maximumWidth: 500
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
    }    
}
