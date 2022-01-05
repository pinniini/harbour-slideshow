import QtQuick 2.5
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage
    property string imageSource: ""
    property bool slideshowRunning: false

    // Background
    Image {
        id: iconImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../graphics/cover_background.png"
        visible: imageSource == ""
    }

    // Slideshow image.
    Image {
        id: slideshowImage
        anchors.fill: parent
        anchors.margins: 5
        source: imageSource
        asynchronous: true
        autoTransform: true
        cache: false
        clip: true
        fillMode: Image.PreserveAspectFit
        sourceSize.width: coverPage.width
        sourceSize.height: coverPage.height
    }

    // Cover actions.
    CoverActionList {
        id: coverActions
        enabled: imageSource != "" //? (!mainPage.stopOnMinimize) : false

        // Toggle slideshow.
        CoverAction {
            iconSource: slideshowRunning ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: {
                toggleSlideshow()
            }
        }
    }

    // Slot to set current image.
    function setImage(source)
    {
        if (imageSource !== source) {
            imageSource = source
        }
        slideshowRunning = imageSource !== ""
    }

    // Slot to follow slideshow running status
    function toggleSlideshowRunning(runningStatus) {
        slideshowRunning = runningStatus
    }

    function toggleSlideshow() {
        mainSlideshowConnections.target.toggleSlideshow()
    }
}
