import QtQuick 2.2
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

    Connections {
        target: TranslationHandler
        onTranslateUI: {
            translateUi()
        }
    }

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
                id: menuSettings
                text: qsTrId("menu-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

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
                id: menuPictures
                text: qsTrId("menu-add-files")
                onClicked: pageStack.push(multiImagePickerDialog)
            }

            MenuItem {
                id: menuStartSlideshow
                text: qsTrId("menu-start-slideshow")
                onClicked: console.log("Start slideshow...")
            }
        }

        contentHeight: contentColumn.height //parent.height


        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingSmall

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
        }

        SectionHeader {
            id: slideshowBackgroundMusicLabel
            text: qsTrId("slideshow-background-music")
        }

        SilicaListView {
            id: musicList
            width: parent.width
            height: slideshowDialog.height * 0.2
            model: backgroundMusicModel
            clip: true

            delegate: ListItem {
                id: musicDelegate
                contentHeight: Theme.itemSizeSmall
                width: parent.width

                Label {
                    text: model.fileName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingMedium
                }
            }
        }

        SectionHeader {
            id: slideshowImagesLabel
            text: qsTrId("slideshow-images")
        }

        SilicaGridView {
            id: imageGrid

            property Item expandedItem

            width: parent.width
            height: slideshowDialog.height * 0.4
            model: imageListModel
            clip: true

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
        }
    }

    Component {
        id: multiMusicPickerDialog
        MultiMusicPickerDialog {
            onAccepted: {
                selectedMusicFiles = ""
                var urls = []
                var index = 0;
                while (index < 15)
                {
                    for (var i = 0; i < selectedContent.count; ++i) {
                        var url = selectedContent.get(i).url
                        var fileName = selectedContent.get(i).fileName
                        // Handle selection
                        //urls.push(selectedContent.get(i).url)
                        backgroundMusicModel.append({'fileName': fileName, 'url': url})
                    }
                    ++index;
                }
                //selectedMusicFiles = urls.join(", ")
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

    function translateUi() {
        menuSettings.text = qsTrId("menu-settings")
        menuQuickStartSlideshow.text = qsTrId("menu-quickstart-slideshow")
        menuMusic.text = qsTrId("menu-add-music")
        menuPictures.text = qsTrId("menu-add-files")
        menuStartSlideshow.text = qsTrId("menu-start-slideshow")
        slideshowNameField.label = qsTrId("slideshow-name-label")
        slideshowNameField.placeholderText = qsTrId("slideshow-name-placeholder")
        slideshowBackgroundMusicLabel.text = qsTrId("slideshow-background-music")
        slideshowImagesLabel.text = qsTrId("slideshow-images")
    }
}
