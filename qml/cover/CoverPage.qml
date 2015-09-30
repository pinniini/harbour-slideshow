/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

import QtQuick 2.1
import Sailfish.Silica 1.0

CoverBackground {
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
            text: qsTr("Slideshow")
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
    }

    // TODO: Cover actions to continue or pause slideshow.
//    CoverActionList {
//        id: coverActions

//        CoverAction {
//            iconSource: "image://theme/icon-m-pause"
//            onTriggered: {

//            }
//        }
//    }

    // Set current image.
    function setImage(source)
    {
        imageSource = source
    }
}


