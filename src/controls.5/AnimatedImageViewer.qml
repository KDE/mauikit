/*
 * SPDX-FileCopyrightText: (C) 2015 Vishesh Handa <vhanda@kde.org>
 * SPDX-FileCopyrightText: (C) 2017 Atul Sharma <atulsharma406@gmail.com>
 * SPDX-FileCopyrightText: (C) 2017 Marco Martin <mart@kde.org>
 *
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui

Flickable
{
    id: flick
    property string currentImageSource

    contentWidth: width
    contentHeight: height
    boundsBehavior: Flickable.StopAtBounds
    boundsMovement: Flickable.StopAtBounds
    interactive: contentWidth > width || contentHeight > height
    clip: true

    ScrollBar.vertical: ScrollBar {
        visible: false
    }
    ScrollBar.horizontal: ScrollBar {
        visible: false
    }

    /**
      * image : Image
      */
   property alias image:  image

   property alias sourceSize : image.sourceSize
    /**
      * fillMode : Image.fillMode
      */
    property int fillMode: Image.PreserveAspectFit

    /**
      * asynchronous : bool
      */
    property alias asynchronous : image.asynchronous

    /**
      * cache : bool
      */
    property alias cache: image.cache

    /**
      * imageWidth : int
      */
    property alias imageWidth: image.sourceSize.width

    /**
      * imageHeight : int
      */
    property alias imageHeight: image.sourceSize.height

    /**
      * animated : bool
      */
    property bool animated: false

    /**
      * source : url
      */
    property alias source : image.source

    /**
      * rightClicked
      */
    signal rightClicked()

    /**
      * pressAndHold
      */
    signal pressAndHold()

    PinchArea {
        width: Math.max(flick.contentWidth, flick.width)
        height: Math.max(flick.contentHeight, flick.height)

        property real initialWidth
        property real initialHeight

        onPinchStarted: {
            initialWidth = flick.contentWidth
            initialHeight = flick.contentHeight
        }

        onPinchUpdated: {
            // adjust content pos due to drag
            flick.contentX += pinch.previousCenter.x - pinch.center.x
            flick.contentY += pinch.previousCenter.y - pinch.center.y

            // resize content
            flick.resizeContent(Math.max(flick.width*0.7, initialWidth * pinch.scale), Math.max(flick.height*0.7, initialHeight * pinch.scale), pinch.center)
        }

        onPinchFinished: {
            // Move its content within bounds.
            if (flick.contentWidth < flick.width ||
                flick.contentHeight < flick.height) {
                zoomAnim.x = 0;
                zoomAnim.y = 0;
                zoomAnim.width = flick.width;
                zoomAnim.height = flick.height;
                zoomAnim.running = true;
            } else {
                flick.returnToBounds();
            }
        }

        ParallelAnimation {
            id: zoomAnim
            property real x: 0
            property real y: 0
            property real width: flick.width
            property real height: flick.height
            NumberAnimation {
                target: flick
                property: "contentWidth"
                from: flick.contentWidth
                to: zoomAnim.width
                duration: Maui.Style.units.longDuration
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: flick
                property: "contentHeight"
                from: flick.contentHeight
                to: zoomAnim.height
                duration: Maui.Style.units.longDuration
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: flick
                property: "contentY"
                from: flick.contentY
                to: zoomAnim.y
                duration: Maui.Style.units.longDuration
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: flick
                property: "contentX"
                from: flick.contentX
                to: zoomAnim.x
                duration: Maui.Style.units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        AnimatedImage {
            id: image
            width: flick.contentWidth
            height: flick.contentHeight
            fillMode: AnimatedImage.PreserveAspectFit
            autoTransform: true
            asynchronous: true
            onStatusChanged: playing = (status == AnimatedImage.Ready)

            BusyIndicator
            {
                anchors.centerIn: parent
                running: parent.status === AnimatedImage.Loading
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons:  Qt.RightButton | Qt.LeftButton
                onClicked:  if(!Maui.Handy.isMobile && mouse.button === Qt.RightButton)
                flick.rightClicked()

                onPressAndHold: flick.pressAndHold()
                onDoubleClicked: {
                    if (flick.interactive) {
                        zoomAnim.x = 0;
                        zoomAnim.y = 0;
                        zoomAnim.width = flick.width;
                        zoomAnim.height = flick.height;
                        zoomAnim.running = true;
                        flick.interactive = !flick.interactive
                    } else {
                        zoomAnim.x = mouse.x * 2;
                        zoomAnim.y = mouse.y *2;
                        zoomAnim.width = flick.width * 3;
                        zoomAnim.height = flick.height * 3;
                        zoomAnim.running = true;
                        flick.interactive = !flick.interactive
                    }
                }
                onWheel: {
                    if (wheel.modifiers & Qt.ControlModifier) {
                        if (wheel.angleDelta.y != 0) {
                            var factor = 1 + wheel.angleDelta.y / 600;
                            zoomAnim.running = false;

                            zoomAnim.width = Math.min(Math.max(flick.width, zoomAnim.width * factor), flick.width * 4);
                            zoomAnim.height = Math.min(Math.max(flick.height, zoomAnim.height * factor), flick.height * 4);

                            //actual factors, may be less than factor
                            var xFactor = zoomAnim.width / flick.contentWidth;
                            var yFactor = zoomAnim.height / flick.contentHeight;

                            zoomAnim.x = flick.contentX * xFactor + (((wheel.x - flick.contentX) * xFactor) - (wheel.x - flick.contentX))
                            zoomAnim.y = flick.contentY * yFactor + (((wheel.y - flick.contentY) * yFactor) - (wheel.y - flick.contentY))
                            zoomAnim.running = true;

                        } else if (wheel.pixelDelta.y != 0) {
                            flick.resizeContent(Math.min(Math.max(flick.width, flick.contentWidth + wheel.pixelDelta.y), flick.width * 4),
                                                Math.min(Math.max(flick.height, flick.contentHeight + wheel.pixelDelta.y), flick.height * 4),
                                                wheel);
                        }
                    } else {
                        flick.contentX += wheel.pixelDelta.x;
                        flick.contentY += wheel.pixelDelta.y;
                    }
                }
            }
        }
    }


    /**
      *
      */
    function fit()
    {
        image.width = image.sourceSize.width
    }

    /**
      *
      */
    function fill()
    {
        image.width = parent.width
    }

    /**
      *
      */
    function rotateLeft()
    {
        image.rotation = image.rotation - 90
    }

    /**
      *
      */
    function rotateRight()
    {
        image.rotation = image.rotation + 90
    }
}
