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

import harbour.slideshow.Settings 1.0

Page {
    id: settingsPage
    allowedOrientations: Orientation.All

    // Properties.
    property alias slideSettings: settings

    // Use these to prevent binding loop.
    property int intrvl: settings.interval
    property bool lp: settings.loop
    property bool stp: settings.stopMinimized

    PageHeader {
        id: pageHeader
        title: qsTr("Settings")
    }

    // Settings.
    SlideSettings {
        id: settings
    }

    // Settings in flickable so that the page is scrollable
    // in cases that all of them does not fit on the screen
    // at the same time.
    SilicaFlickable {
        anchors {
            left: parent.left
            top: pageHeader.bottom
            right: parent.right
            bottom: parent.bottom
        }

        contentHeight: column.height

        Column {
            id: column
            spacing: 10
            width: parent.width

            Slider {
                id: intervalSlider
                width: parent.width
                minimumValue: 1
                maximumValue: 30
                value: intrvl
                stepSize: 1
                valueText: value + " " + qsTr("seconds")
                label: qsTr("Slideshow interval")

                onValueChanged: {
                    settings.interval = value
                }
            }

            TextSwitch {
                id: loopSwitch
                text: qsTr("Loop pictures")
                description: qsTr("Slideshow starts over when reaching the end.")
                checked: lp

                onCheckedChanged: {
                    settings.loop = checked
                }
            }

            TextSwitch {
                id: stopSwitch
                text: qsTr("Stop when minimized")
                description: qsTr("Slideshow will be stopped when pushed minimized.")
                checked: stp

                onCheckedChanged: {
                    settings.stopMinimized = checked
                }
            }
        }
    }
}
