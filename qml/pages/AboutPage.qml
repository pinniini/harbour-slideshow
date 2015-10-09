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

Page {
    id: aboutPage
    allowedOrientations: Orientation.All

    property string issuesText: qsTr("Found bugs? Got some great improvement ideas? Please report them to github and I am happy to look them through :)")

    // React on status changes.
    onStatusChanged: {
        if(status === PageStatus.Activating)
        {
            issueLabel.text = Theme.highlightText(issuesText, "github", Theme.highlightColor)
        }
    }

    // Content in flickable. Enables scroll if
    // content gets too long.
    SilicaFlickable {
        id: aboutFlick
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: 30

            PageHeader {
                id: header
                title: qsTr("About Slideshow")
            }

            SectionHeader {
                text: qsTr("Info")
            }

            Label {
                text: qsTr("Slideshow is an application to automatically view your awesome pictures. It works folder-based, i.e. you select a folder which contains pictures and start the slideshow from the pulley menu. Simple!")
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
            }

            Label {
                text: qsTr("Version ") + appVersion
                x: Theme.paddingMedium
            }

            SectionHeader {
                text: qsTr("By who")
            }

            Label {
                text: qsTr("Joni Korhonen, also known as pinniini")
                x: Theme.paddingMedium
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingMedium
            }

            SectionHeader {
                text: qsTr("License")
            }

            Label {
                text: "BSD"
                font.underline: true
                x: Theme.paddingMedium
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("http://choosealicense.com/licenses/bsd-3-clause/")
                }
            }

            SectionHeader {
                text: qsTr("Code")
            }

            Label {
                text: "https://github.com/pinniini/harbour-slideshow"
                font.underline: true
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://github.com/pinniini/harbour-slideshow")
                }
            }

            SectionHeader {
                text: qsTr("Ideas/Issues")
            }

            Label {
                id: issueLabel
                textFormat: Text.AutoText
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                //text: Theme.highlightText(qsTr("Found bugs? Got some great improvement ideas? Please report them to github and I am happy to look them through :)"), "github", Theme.highlightColor)
                //text: qsTr("Found bugs? Got some great improvement ideas? Please report them to <a style=\"color: inherit; text-decoration: underline;\" href=\"https://github.com/pinniini/harbour-slideshow\">github</a> and I am happy to look them through :)")
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://github.com/pinniini/harbour-slideshow/issues")
                }
            }
        }
    }
}
