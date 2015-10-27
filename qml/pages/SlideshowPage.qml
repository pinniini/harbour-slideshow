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

    // Properties.
    property string imageSource: ""
    property FolderModel pictureModel: null
    property int firstIndex: 1
    property int currentPictureIndex: firstIndex
    property bool slideshowRunning: true
    property int startIndex: -1

    // Settings.
    property int slideshowInterval: 5000
    property bool loop: false
    property bool random: false

    // Signals.
    // Notify cover about image change.
    signal imageChanged(string image)

    // React on status changes.
    onStatusChanged: {
        if(status === PageStatus.Activating)
        {
            console.log("Page activating...")
            if(pictureModel.rowCount() > 1)
            {
                console.log("Pictures in the model...")

                // Loop throug items in the folder.
                for(var i = 0; i < pictureModel.rowCount(); ++i)
                {
                    // If item is not a folder, then it is the first picture in the folder.
                    if(!pictureModel.isFolder(i))
                    {
                        console.log("Found picture in index " + i)
                        firstIndex = i
                        currentPictureIndex = firstIndex
                        break
                    }
                }

                // Check if slideshow should be started from the user selected picture.
                if(startIndex != -1)
                    currentPictureIndex = startIndex

                imageSource = pictureModel.getPath(currentPictureIndex)
                slideshowRunning = true
            }
        }
        else if(status === PageStatus.Deactivating) // Deactivating, set defaults.
        {
            console.log("Page deactivating...")
            stopSlideshow()
            currentPictureIndex = firstIndex
            firstIndex = 1
            startIndex = -1
            imageSource = ""
            imageChanged(imageSource)
        }
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

        onStatusChanged: {
            if(status == Image.Ready)
            {
                console.log("Image ready, start timer...")
                imageChanged(imageSource)
                slideshowTimer.start()
            }
        }
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

        // Toggle slideshow start/stop.
        onClicked: {
            if(slideshowRunning)
                stopSlideshow()
            else
                startSlideshow()
        }
    }

    // Busy indicator to be shown while the image is still loading.
    BusyIndicator {
        id: busyInd
        anchors.centerIn: parent
        running: slideshowPicture.status !== Image.Ready ? (slideshowPicture.status === Image.Loading ? true : false) : false
    }

    // Timer to trigger image change.
    Timer {
        id: slideshowTimer
        interval: slideshowInterval
        repeat: false

        // Change image when timer triggers.
        onTriggered: {
            console.log("Change picture...")

            ++currentPictureIndex

            // Reached the end of the model.
            if(currentPictureIndex === pictureModel.rowCount())
            {
                currentPictureIndex = firstIndex

                // If loop is off.
                if(!loop)
                {
                    stop()
                    console.log("Loop is off, so stop...")
                    return
                }
            }

            imageSource = pictureModel.getPath(currentPictureIndex)
            console.log("Picture changed...")
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
            slideshowRunning = false
            slideshowTimer.stop()
        }
    }

    // Star slideshow.
    function startSlideshow()
    {
        slideshowRunning = true
        slideshowTimer.restart()
    }

    // Random number in given range.
    // Got from:
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    function getRandomNumber(min, max)
    {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
}
