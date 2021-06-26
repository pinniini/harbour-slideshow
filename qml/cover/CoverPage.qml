import QtQuick 2.5
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage
    property string imageSource: ""

    // Default cover when slideshow is not running.
    Column {
        id: content
        anchors.centerIn: parent
        spacing: Theme.paddingSmall
        visible: imageSource == ""

        // Icon.
        Image {
            id: iconImage
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../graphics/harbour-slideshow.png"
        }

        // App name.
        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Slideshow"
        }
    }

    // Slideshow image.
    Image {
        id: slideshowImage
        anchors.fill: parent
        anchors.margins: 5
        source: imageSource
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        sourceSize.width: coverPage.width
        sourceSize.height: coverPage.height
    }

    // Cover actions.
    CoverActionList {
        id: coverActions
        enabled: false //imageSource != "" ? (!mainPage.stopOnMinimize) : false

        // Toggle slideshow.
//        CoverAction {
//            iconSource: mainPage.slideshowPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
//            onTriggered: {
//                mainPage.coverToggleSlideshow()
//            }
//        }
    }

//    Connections {
//        target: playSlideshowPage
//        onImageChanged: {
//            imageSource = url
//        }
//    }

    // Set current image.
    function setImage(source)
    {
        imageSource = source
    }
}
