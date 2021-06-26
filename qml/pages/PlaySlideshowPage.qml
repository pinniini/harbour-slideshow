import QtQuick 2.5
import Sailfish.Silica 1.0
import "../constants.js" as Constants

Page {
    id: playSlideshowPage

    showNavigationIndicator: !slideshowRunning
    backNavigation: !slideshowRunning

    // Properties.
    property string imageSource: ""
    property string imageSource2: ""
    property int imageIndex: -1
    property bool slideshowRunning: true
    property ListModel imageModel
    property bool firstLoaded: false

    // Settings.
    property int slideshowInterval: Settings.getIntSetting(Constants.intervalKey, 5) * 1000
    property bool loop: Settings.getBooleanSetting(Constants.loopKey, true)

    // Signals.
    // Notify cover about image change.
    signal imageChanged(string url)

    // React on status changes.
    onStatusChanged: {
        if(status === PageStatus.Activating)
        {
            console.log("Page activating...")

            if (imageModel.count > 0) {
                imageIndex = 0;
                imageSource = imageModel.get(imageIndex).url
                if (imageModel.count > 1) {
                    imageSource2 = imageModel.get(imageIndex + 1).url
                }
            }

            slideshowRunning = true
        }
        else if(status === PageStatus.Deactivating) // Deactivating, set defaults.
        {
            console.log("Page deactivating...")
            imageIndex = -1;
            imageChanged("")
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
        autoTransform: true
        cache: false
        clip: true
        fillMode: Image.PreserveAspectFit
        sourceSize.width: playSlideshowPage.width
        sourceSize.height: playSlideshowPage.height

        source: imageSource

        visible: true
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation { duration: 1000 } }

        onStatusChanged: {
            if(status == Image.Ready && !firstLoaded)
            {
                console.log("Image ready, start timer...")
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
        autoTransform: true
        cache: false
        clip: true
        fillMode: Image.PreserveAspectFit
        sourceSize.width: playSlideshowPage.width
        sourceSize.height: playSlideshowPage.height

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
        width: 250
        height: 250
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
        width: 40
        height: 200
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -40
        radius: 10
        color: Theme.highlightColor
        opacity: 0.9
        visible: !slideshowRunning
    }
    Rectangle {
        id: rightPause
        width: 40
        height: 200
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 40
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
//                nextPicture()
            }
            else if(dist > minMoveForSwipe && direction > 0) // Swiped right -> previous picture.
            {
                console.log("Swipe right...")
                isSwipe = true
//                previousPicture()
            }
        }

        // Toggle slideshow start/stop.
        onClicked: {
            if(isSwipe)
                return

            console.log("onClicked...")
            toggleSlideshow()
        }
    }

    // Timer to trigger image change.
    Timer {
        id: slideshowTimer
        interval: slideshowInterval
        repeat: true
        running: slideshowRunning

        // Change image when timer triggers.
        onTriggered: {
            console.log("Change picture...")
            nextPicture()
        }
    }

    /*
      Functions.
      */

    function toggleSlideshow() {
        slideshowRunning = !slideshowRunning
    }

    function nextPicture() {
        console.log("nextPicture()")
        ++imageIndex

        if (imageIndex == imageModel.count) {
            imageIndex = 0;
            if (!loop) {
                slideshowRunning = false;
                return;
            }
        }

        imageChanged(imageModel.get(imageIndex).url)

        // Set picture visibilities.
        if(slideshowPicture.visible)
        {
            slideshowPicture.visible = false
            slideshowPicture2.visible = true

            // Load next to first picture.
            if((imageIndex + 1) === imageModel.count)
                imageSource = imageModel.get(0).url
            else
                imageSource = imageModel.get(imageIndex + 1).url
        }
        else
        {
            slideshowPicture.visible = true
            slideshowPicture2.visible = false

            // Load next to first picture.
            if((imageIndex + 1) === imageModel.count)
                imageSource2 = imageModel.get(0).url
            else
                imageSource2 = imageModel.get(imageIndex + 1).url
        }
    }
}
