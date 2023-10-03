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
        Maui.Theme.colorSet: Maui.Theme.Window
        headBar.forceCenterMiddleContent: true

        Button
        {
            anchors.centerIn: parent
            text: "Files!"
            onClicked: _dialog.open()
        }
    }

    Maui.FileListingDialog
    {
        id: _dialog
        title: "File Listing"
        message: "This is a file listing dialog. Used to list files and suggest to perfom an action upon them."

        urls: ["/home/camiloh/Downloads/premium_photo-1664203068007-52240d0ca48f.avif", "/home/camiloh/Downloads/ide_4x.webp", "/home/camiloh/Downloads/photo-app-fereshtehpb.webp", "/home/camiloh/Downloads/ide-reskin.webp", "/home/camiloh/Downloads/nx-software-center-latest-x86_64.AppImage", "/home/camiloh/Downloads/hand-drawn-flat-design-metaverse-background.zip"]

        actions: [
            Action
            {
                text: "Action1"
            },

            Action
            {
                text: "Action2"
            },

            Action
            {
                text: "Action3"
            }
        ]
    }
}

