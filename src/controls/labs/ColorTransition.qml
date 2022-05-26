import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import QtGraphicalEffects 1.0

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui

ColorAnimation
{
    easing.type: Easing.InQuad
                        //easing.type: Easing.OutCubic

    duration: Kirigami.Units.shortDuration
    //duration: 100
}

