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
    id: mainPage
    allowedOrientations: Orientation.All

    // Property to tell if the slideshow is enabled for the current folder.
    property bool slideshowEnabled: false
    property string head: ""
    property bool firstLoad: true

    // Signals.
    // Notify cover about image change.
    signal slideImageChanged(string image)

    // Define folder model.
    // Used to access folders on the system.
    FolderModel {
        id: folderModel
        folder: StandardPaths.pictures // Start from the default pictures location.

        onFolderChanged: {
            head = folderName
            slideshowEnabled = false

            // Check for pictures.
            for(var i = 0; i < rowCount(); ++i)
            {
                // If item is not a folder, then slideshow is enabled for the folder.
                if(!isFolder(i))
                {
                    slideshowEnabled = true
                    break
                }
            }
        }
    }

    // List view to present folder structure.
    SilicaListView {
        id: listView
        model: folderModel
        anchors.fill: parent

        // Menu to start slideshow in the current folder.
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(settingsPage)
            }

            MenuItem {
                text: qsTr("Start slideshow in current folder")
                onClicked: {
                    slideshowPage.pictureModel = folderModel
                    slideshowPage.slideshowInterval = 1000 * settingsPage.slideSettings.interval
                    slideshowPage.loop = settingsPage.slideSettings.loop
                    pageStack.push(slideshowPage)
                }

                enabled: slideshowEnabled
            }
        }

        // Page header. Shows the name of the current folder.
        header: PageHeader {
            id: pageHeader
            title: head
        }
        delegate: BackgroundItem {
            id: delegate
            visible: fileName != "." // Hide dot, i.e. current folder.
            height: fileName == "." ? 0 : Theme.itemSizeSmall // Hide dot, i.e. current folder.
            x: Theme.paddingSmall
            width: parent.width - Theme.paddingMedium

            // Row to place icon and filename.
            Row {
                id: delegRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5

                // Icon. Image-icon when image, Up-icon when dotdot and Folder-icon when folder.
                Image {
                    id: pictureIcon
                    sourceSize.width: 64
                    source: isFolder == false ? "image://theme/icon-l-image" : (fileName == ".." ? "image://theme/icon-m-up" : "image://theme/icon-m-folder")
                }

                // Filename or Go up -string.
                Label {
                    x: Theme.paddingLarge
                    text: fileName == ".." ? qsTr("Go up") : fileName
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Change folder on click.
            onClicked: {
                // Change current folder.
                if(isFolder)
                {
                    folderModel.folder = filePath
                }
                else // Show image.
                {
                    pageStack.push(Qt.resolvedUrl("ImagePage.qml"), {'imageUrl': filePath})
                }
            }
        }
        VerticalScrollDecorator {}
    }

    // Settings.
    SettingsPage {
        id: settingsPage
    }

    // Actual slideshow.
    SlideshowPage {
        id: slideshowPage

        // Notify cover.
        onImageChanged: slideImageChanged(image)
    }


    /*
      Function definitions.
      */

    // Handler to be called when the application active status changed.
    // Pause slideshow when deactivating, if configured.
    function applicationActiveChanged(active)
    {
        console.log("FirstPage: applicationActiveChanged(active) - " + active)

        // If slideshow page is visible, check for settings.
        if(pageStack.currentPage === slideshowPage)
        {
            console.log("StopSlideshow: " + settingsPage.slideSettings.stopMinimized)

            // If application deactivates and setting is that slideshow should stop, then stop slideshow.
            if(!active && settingsPage.slideSettings.stopMinimized)
                slideshowPage.stopSlideshow()
            else if(active && settingsPage.slideSettings.stopMinimized)  // If application is activating and slideshow is stopped, restart it.
                slideshowPage.startSlideshow()
        }
    }
}
