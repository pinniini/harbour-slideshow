import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import Nemo.Thumbnailer 1.0

Dialog {
    id: slideshowDialog

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property string slideshowName: ""
    property string selectedMusicFiles
    property string selectedImageFiles

    onDone: {
        if (result == DialogResult.Accepted) {
            slideshowName = slideshowNameField.text
        }
    }

    canAccept: slideshowNameField.text.trim().length > 0

    ListModel {
        id: backgroundMusicModel
    }

    ListModel {
        id: imageListModel
    }

    SilicaFlickable {
        id: listView
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                id: menuQuickStartSlideshow
                text: qsTrId("menu-quickstart-slideshow")
                onClicked: console.log("Quick Start slideshow, i.e. select folder and play...")
            }

            MenuItem {
                id: menuMusic
                text: qsTrId("menu-add-music")
                onClicked: pageStack.push(multiMusicPickerDialog)
            }

            MenuItem {
                id: menuAbout
                text: qsTrId("menu-add-files")
                onClicked: pageStack.push(multiImagePickerDialog)
            }

            MenuItem {
                id: menuStartSlideshow
                text: qsTrId("menu-start-slideshow")
                onClicked: console.log("Start slideshow...")
            }
        }

        contentHeight: parent.height //contentColumn.height

        DialogHeader {id: header}

        TextField {
            id: slideshowNameField
            focus: true
            label: qsTrId("slideshow-name-label")
            placeholderText: qsTrId("slideshow-name-placeholder")
            text: slideshowName
            Keys.onEnterPressed: {
                focus = false
            }
            Keys.onReturnPressed: {
                focus = false
            }
            width: parent.width - Theme.paddingMedium

            anchors {
                left: parent.left
                top: header.bottom
                right: parent.right
            }
        }

        Label {
            text: qsTrId("slideshow-background-music")
            anchors {
                right: parent.right
                top: slideshowNameField.bottom
            }
        }

        Repeater {
            model: backgroundMusicModel
        }

        Label {
            text: qsTrId("slideshow-images")
            anchors {
                right: parent.right
                bottom: imageGrid.top
            }
        }

        SilicaGridView {
            id: imageGrid

            property Item expandedItem

            width: parent.width
            height: parent.height * 0.4
            model: imageListModel
            clip: true
            anchors {
                left: parent.left
                leftMargin: Theme.paddingSmall
                bottom: parent.bottom
                right: parent.right
            }

            delegate: Image {
                id: dummy
                width: 100
                height: thumbnail.isExpanded ? thumbnail.height + gridContextMenu.height : thumbnail.height
                z: thumbnail.isExpanded ? 1000 : 1

                Thumbnail {
                    id: thumbnail

                    property bool isExpanded: imageGrid.expandedItem === thumbnail

                    anchors {
                        left: parent.left
                        top: parent.top
                    }

                    source: url
                    width: 100
                    height: 100
                    sourceSize.width: width
                    sourceSize.height: height

                    MouseArea {
                        anchors.fill: parent
                        onPressAndHold: {
                            imageGrid.expandedItem = thumbnail
                            gridContextMenu.open(dummy)
                        }
                    }
                }
            }

            ContextMenu {
                id: gridContextMenu
                MenuItem {
                    text: qsTrId("slideshow-imagelist-menu-remove")
                    onClicked: console.log("Remove image from the slideshow...")
                }
            }
        }

//        Column {
//            id: contentColumn

//            width: page.width
//            spacing: Theme.paddingLarge

//            DialogHeader {}

//            TextField {
//                id: slideshowNameField
//                focus: true
//                label: qsTrId("slideshow-name-label")
//                placeholderText: qsTrId("slideshow-name-placeholder")
//                text: slideshowName
//                Keys.onEnterPressed: {
//                    focus = false
//                }
//                width: parent.width - Theme.paddingMedium
//            }

//            SectionHeader {
//                text: qsTrId("slideshow-background-music")
//            }

//            Repeater {
//                model: backgroundMusicModel
//            }

//            SectionHeader {
//                text: qsTrId("slideshow-images")
//            }

//            SilicaGridView {
//                width: parent.width
//                height: width
//                model: imageListModel
//                clip: true

//                delegate: Thumbnail {
//                    source: url
//                    width: 100
//                    height: 100
//                    sourceSize.width: width
//                    sourceSize.height: height
//                }
//            }

////            Repeater {
////                model: imageListModel

////                Column {
////                    width: parent.width - Theme.paddingMedium
////                    x: Theme.paddingMedium
////                    Label {
////                        text: fileName
////                        width: parent.width// - Theme.paddingMedium
////                        //x: Theme.paddingMedium
////                    }
////                    Label {
////                        text: url
////                        width: parent.width //- Theme.paddingMedium
////                        font.pixelSize: Theme.fontSizeExtraSmall
////                        //x: Theme.paddingMedium
////                    }
////                }
////            }
//        }
    }

    Component {
        id: multiMusicPickerDialog
        MultiMusicPickerDialog {
            onAccepted: {
                selectedMusicFiles = ""
                var urls = []
                for (var i = 0; i < selectedContent.count; ++i) {
                    var url = selectedContent.get(i).url
                    // Handle selection
                    urls.push(selectedContent.get(i).url)
                    backgroundMusicModel.append({'fileName': '', 'url': url})
                }
                selectedMusicFiles = urls.join(", ")
            }

            onRejected: selectedMusicFiles = ""
        }
    }

    Component {
        id: multiImagePickerDialog
        MultiImagePickerDialog {
            onAccepted: {
                selectedImageFiles = ""
                var urls = []
                var index = 0;
                while (index < 15)
                {
                    for (var i = 0; i < selectedContent.count; ++i) {
                        var url = selectedContent.get(i).url
                        var fileName = selectedContent.get(i).fileName
                        // Handle selection
                        imageListModel.append({'fileName': fileName, 'url': url})
                    }
                    ++index;
                }
            }

            onRejected: selectedImageFiles = ""
        }
    }
}
