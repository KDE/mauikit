import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import org.mauikit.controls 1.3 as Maui

/**
 * @inherit QtQuick.Loader
 * @brief Just a basic wrapper around a QQC2 Loader, to put in a TabView view and lazy-load it, only when it is the current view or already has been activated.
 * 
 * This can be used to lazy loading tab views, used with the TabView::addTab silent mode.
 */
Loader
{
    id: control
    
    focus: true
    active: ListView.isCurrentItem || item
}
