import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.slideshow.FolderModel 1.0

Page {
    id: testPage
    allowedOrientations: Orientation.All

    property string head: ""

    FolderModel {
        id: fModel
        folder: StandardPaths.pictures // Start from the default pictures location.

        onFolderChanged: {
            head = folderName

            // Check for pictures.
            for(var i = 0; i < rowCount(); ++i)
            {
                // If item is not a folder, then slideshow is enabled for the folder.
                if(!isFolder(i))
                {
                    console.log("Picture found...")
                    break
                }
            }
        }
    }

    // List view to present folder structure.
    SilicaListView {
        id: listView
        model: fModel
        anchors.fill: parent

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
                console.log("Clicked " + index)

                console.log(fileName)
                console.log(filePath)
                console.log(isFolder)

                if(!isFolder)
                    pageStack.push(Qt.resolvedUrl("ImagePage.qml"), {'imageUrl': filePath})
                else
                {
                    head = fileName
                    fModel.folder = filePath
                }

//                // Change current folder.
//                if(folderModel.isFolder(index))
//                {
//                    console.log("Clicked folder...")
//                    console.log(folderModel.get(index, "filePath"))
//                    folderModel.folder = folderModel.get(index, "filePath")
//                }
//                else // Show image.
//                {
//                    console.log("Image: " + folderModel.get(index, "filePath"))
//                    pageStack.push(Qt.resolvedUrl("ImagePage.qml"), {'imageUrl': folderModel.get(index, "filePath")})
//                }
            }
        }
        VerticalScrollDecorator {}
    }
}
