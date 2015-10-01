/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


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
