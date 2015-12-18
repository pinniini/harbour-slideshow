/*
  Copyright (c) 2015, Joni Korhonen (pinniini)
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  * Neither the name of harbour-slideshow nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.slideshow.FolderModel 1.0

Page {
    id: slideshowPage
    allowedOrientations: Orientation.All
    showNavigationIndicator: !slideshowRunning
    backNavigation: false

    // Properties.
    property string imageSource: ""
    property string imageSource2: ""
    property int firstIndex: 0
    property int currentPictureIndex: firstIndex
    property int startIndex: -1
    property bool slideshowRunning: true

    // Picture array.
    property var pictureArray: []

    property ListModel pictureModel: null

    // Settings.
    property int slideshowInterval: 5000
    property bool loop: false

    // Picture change stuff.
    property bool firstLoaded: false
    property bool picture1Visible: false

    // Signals.
    // Notify cover about image change.
    signal imageChanged(string image)

    // React on status changes.
    onStatusChanged: {
        if(status === PageStatus.Activating)
        {
            console.log("Page activating...")
            console.log("StartIndex: " + startIndex)
            firstIndex = 0

            if(startIndex <= -1)
            {
                currentPictureIndex = firstIndex
                imageSource = pictureArray[firstIndex]
            }
            else // User selected first picture when not randomized.
            {
                currentPictureIndex = startIndex
                imageSource = pictureArray[startIndex]
            }

            // Set second image if available.
            if(pictureArray.length > 1 && startIndex <= -1)
            {
                imageSource2 = pictureArray[firstIndex + 1]
            }
            else if(pictureArray.length > 1 && startIndex > -1)
            {
                // User selected last picture as first picture.
                if((startIndex + 1) >= pictureArray.length)
                    imageSource2 = pictureArray[firstIndex]
                else
                    imageSource2 = pictureArray[startIndex + 1]
            }

            slideshowRunning = true
            backNavigation = false
        }
        else if(status === PageStatus.Deactivating) // Deactivating, set defaults.
        {
            console.log("Page deactivating...")
            stopSlideshow()
            currentPictureIndex = firstIndex
            imageSource = ""
            imageSource2 = ""
            firstLoaded = false
            picture1Visible = false
            slideshowPicture.visible = true
            slideshowPicture2.visible = false
            imageChanged(imageSource)
        }
    }

    PageHeader {
        id: header
        title: ""
        visible: !slideshowRunning
    }

    // Image.
    Image {
        id: slideshowPicture
        anchors.fill: parent
        asynchronous: true
        cache: false
        clip: true
        fillMode: Image.PreserveAspectFit
        sourceSize.width: slideshowPage.width
        sourceSize.height: slideshowPage.height

        source: imageSource

        visible: true
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation { duration: 1000 } }

        onStatusChanged: {
            if(status == Image.Ready && !firstLoaded)
            {
                console.log("Image ready, start timer...")
                picture1Visible = true
                firstLoaded = true
                imageChanged(imageSource)
                slideshowTimer.start()
            }
        }
    }

    // Second image.
    Image {
        id: slideshowPicture2
        anchors.fill: parent
        asynchronous: true
        cache: false
        clip: true
        fillMode: Image.PreserveAspectFit
        sourceSize.width: slideshowPage.width
        sourceSize.height: slideshowPage.height

        source: imageSource2

        visible: false
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation { duration: 1000 } }
    }

    /*
      Pause indicators.
      */

    Rectangle {
        id: circlePause
        width: 160
        height: 160
        radius: width/2
        anchors.centerIn: parent
        border.color: Theme.highlightColor
        border.width: 5
        opacity: 0.6
        color: "transparent"
        visible: !slideshowRunning
    }
    Rectangle {
        id: leftPause
        width: 20
        height: 100
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -25
        radius: 10
        color: Theme.highlightColor
        opacity: 0.9
        visible: !slideshowRunning
    }
    Rectangle {
        id: rightPause
        width: 20
        height: 100
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 25
        radius: 10
        color: Theme.highlightColor
        opacity: 0.9
        visible: !slideshowRunning
    }

    // -------------------------------------------

    // Handle start/stop by click.
    MouseArea {
        id: slideshowToggleArea
        anchors.fill: parent

        property int minMoveForSwipe: 10
        property int mousePressStartX: 0
        property bool isSwipe: false

        onPressed: {
            console.log("onPressed...")
            mousePressStartX = mouse.x
            isSwipe = false
        }

        onReleased: {
            console.log("onReleased...")
            var direction = mouse.x - mousePressStartX
            var dist = Math.abs(direction)

            // Swiped left -> next picture.
            if(dist > minMoveForSwipe && direction < 0)
            {
                console.log("Swipe left...")
                isSwipe = true
                nextPicture()
            }
            else if(dist > minMoveForSwipe && direction > 0) // Swiped right -> previous picture.
            {
                console.log("Swipe right...")
                isSwipe = true
                previousPicture()
            }
        }

        // Toggle slideshow start/stop.
        onClicked: {
            if(isSwipe)
                return

            console.log("onClicked...")
            if(slideshowRunning)
                stopSlideshow()
            else
                startSlideshow()
        }
    }

    // Timer to trigger image change.
    Timer {
        id: slideshowTimer
        interval: slideshowInterval
        repeat: true

        // Change image when timer triggers.
        onTriggered: {
            console.log("Change picture...")

            nextPicture()
//            ++currentPictureIndex

//            // Reached the end of the model.
//            if(currentPictureIndex === pictureArray.length)
//            {
//                currentPictureIndex = firstIndex
//                // If loop is off.
//                if(!loop)
//                {
//                    stop()
//                    return
//                }
//            }

//            // Notify cover about picture change.
//            imageChanged(pictureArray[currentPictureIndex])

//            // Set picture visibilities.
//            if(picture1Visible)
//            {
//                slideshowPicture.visible = false
//                slideshowPicture2.visible = true
//                picture1Visible = false

//                // Load next to first picture.
//                if((currentPictureIndex + 1) === pictureArray.length)
//                    imageSource = pictureArray[firstIndex]
//                else
//                    imageSource = pictureArray[currentPictureIndex + 1]
//            }
//            else
//            {
//                slideshowPicture.visible = true
//                slideshowPicture2.visible = false
//                picture1Visible = true

//                // Load next to first picture.
//                if((currentPictureIndex + 1) === pictureArray.length)
//                    imageSource2 = pictureArray[firstIndex]
//                else
//                    imageSource2 = pictureArray[currentPictureIndex + 1]
//            }
        }
    }


    /*
      Functions.
      */

    // Stop the slideshow if running.
    function stopSlideshow()
    {
        // If running, stop.
        if(slideshowTimer.running)
        {
            slideshowPage.backNavigation = true
            slideshowRunning = false
            slideshowTimer.stop()
        }
    }

    // Star slideshow.
    function startSlideshow()
    {
        slideshowPage.backNavigation = false
        slideshowRunning = true
        slideshowTimer.restart()
    }

    // Change to next picture.
    function nextPicture()
    {
        console.log("nextPicture()")

        ++currentPictureIndex

        // Reached the end of the model.
        if(currentPictureIndex === pictureArray.length)
        {
            currentPictureIndex = firstIndex
            // If loop is off.
            if(!loop)
            {
                slideshowTimer.stop()
                return
            }
        }

        // Notify cover about picture change.
        imageChanged(pictureArray[currentPictureIndex])

        // Set picture visibilities.
        if(picture1Visible)
        {
            slideshowPicture.visible = false
            slideshowPicture2.visible = true
            picture1Visible = false

            // Load next to first picture.
            if((currentPictureIndex + 1) === pictureArray.length)
                imageSource = pictureArray[firstIndex]
            else
                imageSource = pictureArray[currentPictureIndex + 1]
        }
        else
        {
            slideshowPicture.visible = true
            slideshowPicture2.visible = false
            picture1Visible = true

            // Load next to first picture.
            if((currentPictureIndex + 1) === pictureArray.length)
                imageSource2 = pictureArray[firstIndex]
            else
                imageSource2 = pictureArray[currentPictureIndex + 1]
        }

        if(slideshowRunning)
            slideshowTimer.restart()
    }

    // Change to previous picture.
    function previousPicture()
    {
        console.log("previousPicture()")

        --currentPictureIndex

        // Reached the start of the model.
        if(currentPictureIndex === -1)
        {
            currentPictureIndex = pictureArray.length - 1
            // If loop is off.
            if(!loop)
            {
                currentPictureIndex = 0
                return
            }
        }

        // Notify cover about picture change.
        imageChanged(pictureArray[currentPictureIndex])

        // Set picture visibilities.
        if(picture1Visible)
        {
            slideshowPicture.visible = false
            slideshowPicture2.visible = true
            picture1Visible = false

            // Load next to first picture.
            if((currentPictureIndex + 1) === pictureArray.length)
                imageSource = pictureArray[firstIndex]
            else
                imageSource = pictureArray[currentPictureIndex + 1]
        }
        else
        {
            slideshowPicture.visible = true
            slideshowPicture2.visible = false
            picture1Visible = true

            // Load next to first picture.
            if((currentPictureIndex + 1) === pictureArray.length)
                imageSource2 = pictureArray[firstIndex]
            else
                imageSource2 = pictureArray[currentPictureIndex + 1]
        }

        if(slideshowRunning)
            slideshowTimer.restart()
    }
}
