/*
 * SPDX-FileCopyrightText: (C) 2015 Vishesh Handa <vhanda@kde.org>
 * SPDX-FileCopyrightText: (C) 2017 Atul Sharma <atulsharma406@gmail.com>
 * SPDX-FileCopyrightText: (C) 2017 Marco Martin <mart@kde.org>
 *
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.9 as Kirigami

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
            flick.resizeContent(Math.max(root.width*0.7, initialWidth * pinch.scale), Math.max(root.height*0.7, initialHeight * pinch.scale), pinch.center)
        }

        onPinchFinished: {
            // Move its content within bounds.
            if (flick.contentWidth < root.width ||
                flick.contentHeight < root.height) {
                zoomAnim.x = 0;
                zoomAnim.y = 0;
                zoomAnim.width = root.width;
                zoomAnim.height = root.height;
                zoomAnim.running = true;
            } else {
                flick.returnToBounds();
            }
        }

        ParallelAnimation {
            id: zoomAnim
            property real x: 0
            property real y: 0
            property real width: root.width
            property real height: root.height
            NumberAnimation {
                target: flick
                property: "contentWidth"
                from: flick.contentWidth
                to: zoomAnim.width
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: flick
                property: "contentHeight"
                from: flick.contentHeight
                to: zoomAnim.height
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: flick
                property: "contentY"
                from: flick.contentY
                to: zoomAnim.y
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: flick
                property: "contentX"
                from: flick.contentX
                to: zoomAnim.x
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        Image {
            id: image
            width: flick.contentWidth
            height: flick.contentHeight
            fillMode: Image.PreserveAspectFit
            autoTransform: true
            asynchronous: true

            BusyIndicator
            {
                anchors.centerIn: parent
                running: parent.status === Image.Loading
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons:  Qt.RightButton | Qt.LeftButton
                onClicked:  if(!Kirigami.Settings.isMobile && mouse.button === Qt.RightButton)
                flick.rightClicked()

                onPressAndHold: flick.pressAndHold()
                onDoubleClicked: {
                    if (flick.interactive) {
                        zoomAnim.x = 0;
                        zoomAnim.y = 0;
                        zoomAnim.width = root.width;
                        zoomAnim.height = root.height;
                        zoomAnim.running = true;
                        flick.interactive = !flick.interactive
                    } else {
                        zoomAnim.x = mouse.x * 2;
                        zoomAnim.y = mouse.y *2;
                        zoomAnim.width = root.width * 3;
                        zoomAnim.height = root.height * 3;
                        zoomAnim.running = true;
                        flick.interactive = !flick.interactive
                    }
                }
                onWheel: {
                    if (wheel.modifiers & Qt.ControlModifier) {
                        if (wheel.angleDelta.y != 0) {
                            var factor = 1 + wheel.angleDelta.y / 600;
                            zoomAnim.running = false;

                            zoomAnim.width = Math.min(Math.max(root.width, zoomAnim.width * factor), root.width * 4);
                            zoomAnim.height = Math.min(Math.max(root.height, zoomAnim.height * factor), root.height * 4);

                            //actual factors, may be less than factor
                            var xFactor = zoomAnim.width / flick.contentWidth;
                            var yFactor = zoomAnim.height / flick.contentHeight;

                            zoomAnim.x = flick.contentX * xFactor + (((wheel.x - flick.contentX) * xFactor) - (wheel.x - flick.contentX))
                            zoomAnim.y = flick.contentY * yFactor + (((wheel.y - flick.contentY) * yFactor) - (wheel.y - flick.contentY))
                            zoomAnim.running = true;

                        } else if (wheel.pixelDelta.y != 0) {
                            flick.resizeContent(Math.min(Math.max(root.width, flick.contentWidth + wheel.pixelDelta.y), root.width * 4),
                                                Math.min(Math.max(root.height, flick.contentHeight + wheel.pixelDelta.y), root.height * 4),
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
