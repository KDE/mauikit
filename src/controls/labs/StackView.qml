import QtQuick 2.15
import QtQml 2.14

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.10

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import QtQuick.Templates 2.15 as T

T.StackView
{
    id: control
    focus: true
    
    pushEnter: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 0
            to:1
            duration: 200
        }
    }
    
    pushExit: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 1
            to:0
            duration: 200
        }
    }
    
    popEnter: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 0
            to:1
            duration: 200
        }
    }
    
    popExit: Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: 1
            to:0
            duration: 200
        }
    }
}
