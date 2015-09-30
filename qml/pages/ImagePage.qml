/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

import QtQuick 2.1
import Sailfish.Silica 1.0

// Page to show selected image.
Page {
    id: imagePage
    allowedOrientations: Orientation.All

    // Properties.
    property string imageUrl: ""

    // Image.
    Image {
        id: mainImage
        anchors.centerIn: parent
        asynchronous: true
        source: imageUrl
        fillMode: Image.PreserveAspectFit
        sourceSize.width: imagePage.width
        sourceSize.height: imagePage.height
    }
}
