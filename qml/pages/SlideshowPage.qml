/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.slideshow.FolderModel 1.0

// ScreenBlank can be used to prevent screen from blanking.
// As for now, Sailfish.Media is not allowed import in Harbour.
// This should be removed when submitting to the Harbour.
//import Sailfish.Media 1.0

Page {
    id: slideshowPage
    allowedOrientations: Orientation.All

    // Properties.
    property string imageSource: ""
    property FolderModel pictureModel: null
    property int startIndex: 1
    property int currentPictureIndex: startIndex

    // Settings.
    property int slideshowInterval: 5000
    property bool loop: false

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
                        startIndex = i
                        currentPictureIndex = startIndex
                        break
                    }
                }

                imageSource = pictureModel.getPath(currentPictureIndex)
            }
        }
        else if(status === PageStatus.Deactivating)
        {
            console.log("Page deactivating...")
            stopSlideshow()
            currentPictureIndex = startIndex
            imageSource = ""
            imageChanged(imageSource)
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        // Menu.
        PullDownMenu {
            MenuItem {
                id: startStopMenu
                text: slideshowTimer.running ? qsTr("Stop") : qsTr("Start")

                onClicked: {
                    console.log("Start/Stop pulley triggered...")
                    if(slideshowTimer.running)
                    {
                        console.log("Slideshow running -> stop...")
                        slideshowTimer.stop()
                    }
                    else
                    {
                        console.log("Slideshow stopped -> start...")
                        slideshowTimer.start()
                    }
                }
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
                currentPictureIndex = startIndex

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

    // This can be used to prevent screen from blanking.
    // As for now, Sailfish.Media is not allowed import in Harbour.
    // This should be removed when submitting to the Harbour.
//    ScreenBlank {
//        suspend: slideshowTimer.running
//    }


    /*
      Functions.
      */

    // Stop the slideshow if running.
    function stopSlideshow()
    {
        if(slideshowTimer.running)
            slideshowTimer.stop()
    }

    // Star slideshow. If running, restart.
    function startSlideshow()
    {
        slideshowTimer.restart()
    }
}
