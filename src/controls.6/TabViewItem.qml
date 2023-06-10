import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import org.mauikit.controls as Maui

Loader
{
    id: control
    
    focus: true
    active: ListView.isCurrentItem || item
}
