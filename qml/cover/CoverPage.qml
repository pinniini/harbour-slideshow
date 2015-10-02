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


