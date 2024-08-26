/*
 * SPDX-FileCopyrightText: (C) 2015 Vishesh Handa <vhanda@kde.org>
 * SPDX-FileCopyrightText: (C) 2017 Atul Sharma <atulsharma406@gmail.com>
 * SPDX-FileCopyrightText: (C) 2017 Marco Martin <mart@kde.org>
 *
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

/**
 * @inherit QtQuick.Flickable
 * @brief A view container for displaying images.
 * 
 * <a href="https://doc.qt.io/qt-6/qml-qtquick-controls-flickable.html">This controls inherits from QQC2 Flickable, to checkout its inherited properties refer to the Qt Docs.</a>
 * 
 *  This control along with the AnimatedImageViewer are meant to display images, with support for zooming in and out with touch or mouse gestures, and keyboard shortcuts.  
 *  
 */
Flickable
{
    id: flick
    
    contentWidth: width
    contentHeight: height
    boundsBehavior: Flickable.StopAtBounds
    boundsMovement: Flickable.StopAtBounds
    interactive: contentWidth > width || contentHeight > height
    clip: false
    
    ScrollBar.vertical: ScrollBar
    {
        visible: false
    }
    
    ScrollBar.horizontal: ScrollBar
    {
        visible: false
    }

    /**
     * @brief This an alias to the actual control painting the image. 
     * This control is handled by a QQC2 Image.
     * @note See Qt documentation for more information about the Image control.
     * @property Image ImageViewer::image
     */
    property alias image: image
    
    /**
     * @brief The painted size of the image.
     * As taken from Qt documentation: This property holds the scaled width and height of the full-frame image.
     * Unlike the width and height properties, which scale the painting of the image, this property sets the maximum number of pixels stored for the loaded image so that large images do not use more memory than necessary. 
     * @property size ImageViewer::sourceSize
     */
    property alias sourceSize : image.sourceSize
    
     /**
     * @brief The fill mode of the image. The possible values can be found on the Image control documentation from Qt.
     * By default this is set to `Image.PreserveAspectFit`.
     * @property enumaration ImageViewer::fillMode
     */
    property alias fillMode: image.fillMode
    
    /**
     * @brief Whether the image should be loaded asynchronously. 
     * By default this is set to `true`.
     * @property bool ImageViewer::asynchronous
     */
    property alias asynchronous : image.asynchronous
    
    /**
     * @brief If the image should be cached in memory. 
     * The default value is set to `true`
     * @property bool ImageViewer::cache
     */
    property alias cache: image.cache
    
     /**
     * @brief The painted width of the image. This the same as using the image `sourceSize` property to set the width.
     * @property int ImageViewer::imageWidth
     */
    property alias imageWidth: image.sourceSize.width
    
    /**
     * @brief The painted height of the image. This the same as using the image `sourceSize` property to set the height.
     * @property int ImageViewer::imageHeight
     */
    property alias imageHeight: image.sourceSize.height
    
    /**
     * @brief The source of the image. Can be a remote or local file URL.
     * @property url ImageViewer::source
     */
    property alias source : image.source
    
    /**
     * @brief Emitted when the image area has been right clicked with a mouse event.
     */
    signal rightClicked()
    
    /**
     * @brief Emitted when the image area has been pressed for a few seconds. 
     */
    signal pressAndHold()
    
    PinchArea
    {
        width: Math.max(flick.contentWidth, flick.width)
        height: Math.max(flick.contentHeight, flick.height)
        
        property real initialWidth
        property real initialHeight
        
        onPinchStarted: {
            initialWidth = flick.contentWidth
            initialHeight = flick.contentHeight
        }
        
        onPinchUpdated: (pinch) => {
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
        
        Image
        {
            id: image
            width: flick.contentWidth
            height: flick.contentHeight
            fillMode: Image.PreserveAspectFit
            autoTransform: true
            asynchronous: true
            
            Maui.ProgressIndicator
            {
                width: parent.width
                anchors.bottom: parent.bottom
                visible: image.status === Image.Loading
            }
            
            Maui.Holder
            {
                anchors.fill: parent
                visible: image.status === Image.Error || image.status === Image.Null
                title: i18nd("mauikit", "Oops!")
                body: i18nd("mauikit", "The image could not be loaded.")
                emoji: "qrc:/assets/dialog-information.svg"
            }
            
            MouseArea {
                anchors.fill: parent
                acceptedButtons:  Qt.RightButton | Qt.LeftButton
                onClicked: (mouse) =>
                           {
                               if(!Maui.Handy.isMobile && mouse.button === Qt.RightButton)
                               {
                                   flick.rightClicked()
                               }
                           }
                
                onPressAndHold: flick.pressAndHold()

                onDoubleClicked: (mouse) =>
                                 {
                                     if (flick.interactive)
                                     {
                                         zoomAnim.x = 0;
                                         zoomAnim.y = 0;
                                         zoomAnim.width = flick.width;
                                         zoomAnim.height = flick.height;
                                         zoomAnim.running = true;
                                         flick.interactive = !flick.interactive
                                     } else
                                     {
                                         zoomAnim.x = mouse.x * 2;
                                         zoomAnim.y = mouse.y *2;
                                         zoomAnim.width = flick.width * 3;
                                         zoomAnim.height = flick.height * 3;
                                         zoomAnim.running = true;
                                         flick.interactive = !flick.interactive
                                     }
                                 }

                onWheel: (wheel) =>
                         {
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

                                 if(zoomAnim.width !== flick.contentWidth || zoomAnim.height !== flick.contentHeight)
                                 {
                                     flick.contentX += wheel.pixelDelta.x;
                                     flick.contentY += wheel.pixelDelta.y;
                                 }else
                                 {
                                     wheel.accepted = false
                                 }
                             }
                         }
            }
        }
    }
    
    /**
     * @brief Forces the image to fit in the viewport.
     */
    function fit()
    {
        image.width = image.sourceSize.width
    }
    
    /**
     * @brief Forces the image to fill-in the viewport, this is done horizontally, so the image might be out of view vertically.
     */
    function fill()
    {
        image.width = parent.width
    }
    
    /**
     * @brief Forces the image to be rotated 90 degrees to the left.
     */
    function rotateLeft()
    {
        image.rotation = image.rotation - 90
    }
    
    /**
     * @brief Forces the image to be rotated 90 degrees to the right.
     */
    function rotateRight()
    {
        image.rotation = image.rotation + 90
    }
}
