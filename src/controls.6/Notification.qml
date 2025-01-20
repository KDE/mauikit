// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtCore
import QtQuick.Controls

import org.mauikit.controls as Maui

/**
 * @inherit QtObject
 * @brief A wrapper for easily composing a notification that can be dispatched.
 * The notification is dispatched to the current application window overlay area.
 * @image html controls_notification.png "Multiple notifications. Different types, with callback actions, only simple text, or more complex."
 * 
 * By default this control will take QQC2 Action as children. For showing the notification just call the function `dispatch`
 * 
 * @code
 * Maui.Notification
 * { 
 * iconName: "dialog-info"
 * title: i18n("Tagged")
 * message: i18n("File was tagged successfully")
 * 
 * Action
 * {
 * text: "Test"
 * onTriggered:
 * {
 * }
 * }
 * }
 * @endcode
 */
QtObject
{
    id: control
    
    /*
     * @brief A set of callback actions to be listed in the notification popup
     */
    default property list<Action> actions : []
        
        /**
         * @brief The title for the notification
         */
        property string title
        
        /**
         * @brief The body message of the notification
         */
        property string message
        
        /**
         * @brief The icon from a file source, such as an image to be used
         */
        property string iconSource
        
        /**
         * @brief The name of the icon to be used
         */
        property string iconName
        
        /**
         * Sends the notification to the toast-area to be visible.
         */
        function dispatch()
        {
            Maui.App.rootComponent.notify(control.iconName, control.title, control.message, control.actions)
        }
}
