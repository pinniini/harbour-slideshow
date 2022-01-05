import QtQuick 2.5
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import Nemo.Thumbnailer 1.0

import "../js/database.js" as DB
import "../constants.js" as Constants
import fi.pinniini.slideshow 1.0

Dialog {
    id: slideshowDialog

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property bool editMode: false
    property int slideshowId: -1

    property string slideshowName: ""
    property int imageWidth: Math.floor(slideshowDialog.width / 5)
    property var slideshow

    property var playSlideshowPage

    Component.onCompleted: {
        if (editMode && slideshowId > 0) {
            var show = DB.getSlideshow(slideshowId)
            if (show) {
                backgroundMusicModel.clear()
                imageListModel.clear()

                slideshowNameField.text = show.name

                for (var mi = 0; mi < show.music.length; ++mi) {
                    var mus = show.music[mi]
                    backgroundMusicModel.append({'fileName': mus.fileName, 'url': mus.url})
                }

                for (var ii = 0; ii < show.images.length; ++ii) {
                    var img = show.images[ii]
                    imageListModel.append({'fileName': img.fileName, 'url': img.url})
                }
            }

            slideshowNameField.focus = false
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            slideshowName = slideshowNameField.text
            var show = {'id': editMode ? slideshowId : -1, 'name': slideshowName, 'music': [], 'images': []}

            for (var mi = 0; mi < backgroundMusicModel.count; ++mi) {
                var mf = backgroundMusicModel.get(mi)
                var music = {'fileName': mf.fileName, 'url': mf.url, 'slideshowId': editMode ? slideshowId : -1}
                show.music.push(music)
            }

            for (var ii = 0; ii < imageListModel.count; ++ii) {
                var img = imageListModel.get(ii)
                var image = {'fileName': img.fileName, 'url': img.url, 'slideshowId': editMode ? slideshowId : -1}
                show.images.push(image)
            }

            slideshow = show
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

    FolderLoader {
        id: folderLoader
        onFileLoadedFromFolder: {
            imageListModel.append({'fileName': filePath, 'url': filePath})
        }
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
                id: menuMusic
                text: qsTrId("menu-add-music")
                onClicked: pageStack.push(multiMusicPickerDialog)
            }

            MenuItem {
                id: menuFolderPictures
                text: qsTrId("menu-add-files-folder")
                onClicked: pageStack.push(folderPickerDialog)
            }

            MenuItem {
                id: menuFilesystemPictures
                text: qsTrId("menu-add-files-filesystem")
                onClicked: pageStack.push(filesystemImagePickerDialog)
            }

            MenuItem {
                id: menuPictures
                text: qsTrId("menu-add-files")
                onClicked: pageStack.push(multiImagePickerDialog)
            }

            MenuItem {
                id: menuStartSlideshow
                text: qsTrId("menu-start-slideshow")
                onClicked: {
                    console.log("Start slideshow...")
                    playSlideshowPage = pageStack.push(Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': imageListModel, 'musicModel': backgroundMusicModel, 'slideshowOrderArray': getSlideshowOrder()})
                    mainSlideshowConnections.target = playSlideshowPage
                }
            }
        }

        contentHeight: contentColumn.height

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
                    width: parent.width
                    contentHeight: Theme.itemSizeExtraSmall

                    Label {
                        text: model.fileName
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingMedium
                    }

                    menu: ContextMenu {
                        MenuItem {
                            text: qsTrId("slideshow-imagelist-menu-remove")
                            onClicked: {
                                console.log("Remove music from the slideshow...")
                                console.log("Music index:", index)
                                backgroundMusicModel.remove(index)
                            }
                        }
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
                cellWidth: slideshowDialog.imageWidth
                cellHeight: slideshowDialog.imageWidth

                delegate: Item {
                    id: dummy
                    width: slideshowDialog.imageWidth
                    height: thumbnail.isExpanded ? thumbnail.height + gridContextMenu.height : thumbnail.height
                    z: thumbnail.isExpanded ? 1000 : 1

                    Thumbnail {
                        id: thumbnail

                        property bool isExpanded: imageGrid.expandedItem == thumbnail

                        anchors {
                            left: parent.left
                            top: parent.top
                        }

                        source: url
                        width: slideshowDialog.imageWidth
                        height: slideshowDialog.imageWidth
                        sourceSize.width: width
                        sourceSize.height: height

                        MouseArea {
                            anchors.fill: parent
                            onPressAndHold: {
                                imageGrid.expandedItem = thumbnail
                                gridContextMenu.index = index
                                gridContextMenu.open(dummy)
                            }
                            onClicked: {
                                pageStack.push(Qt.resolvedUrl("ImagePage.qml"), {'imageUrl': url})
                            }
                        }
                    }
                }

                ContextMenu {
                    id: gridContextMenu

                    property int index: -1

                    MenuItem {
                        text: qsTrId("slideshow-imagelist-menu-remove")
                        onClicked: {
                            console.log("Remove image from the slideshow...")
                            console.log("Image index:", gridContextMenu.index)
                            imageListModel.remove(gridContextMenu.index)
                            gridContextMenu.index = -1
                        }
                    }
                }
            }
        }
    }

    Component {
        id: multiMusicPickerDialog
        MultiMusicPickerDialog {
            onAccepted: {
                var urls = []
                var index = 0;
                for (var i = 0; i < selectedContent.count; ++i) {
                    var url = selectedContent.get(i).url
                    var fileName = selectedContent.get(i).fileName
                    // Handle selection
                    backgroundMusicModel.append({'fileName': fileName, 'url': url})
                }
            }
        }
    }

    Component {
        id: multiImagePickerDialog
        MultiImagePickerDialog {
            onAccepted: {
                var urls = []
                var index = 0;
                for (var i = 0; i < selectedContent.count; ++i) {
                    var url = selectedContent.get(i).url
                    var fileName = selectedContent.get(i).fileName
                    // Handle selection
                    imageListModel.append({'fileName': fileName, 'url': url})
                }
            }
        }
    }

    Component {
        id: filesystemImagePickerDialog
        MultiFilePickerDialog {
            nameFilters: imageFileFilters
            onAccepted: {
                console.log("File system image picker accepted...")
                var urls = []
                for (var i = 0; i < selectedContent.count; ++i) {
                    var url = selectedContent.get(i).url
                    var fileName = selectedContent.get(i).fileName
                    // Handle selection
                    imageListModel.append({'fileName': fileName, 'url': url})
                }
            }
        }
    }

    Component {
        id: folderPickerDialog
        FolderPickerDialog {
            id: imageFolderDialog
            path: Settings.getBooleanSetting(Constants.selectFolderFromRootKey, false) ? "/" : StandardPaths.home
            title: qsTrId("quick-folderpicker-title")
            onAccepted: {
                console.log("Add pictures from the selected folder:", selectedPath)
                folderLoader.readFilesInFolder(selectedPath)
            }
        }
    }

    function translateUi() {
        menuSettings.text = qsTrId("menu-settings")
        menuMusic.text = qsTrId("menu-add-music")
        menuFolderPictures.text = qsTrId("quick-folderpicker-title")
        menuFilesystemPictures.text = qsTrId("menu-add-files-filesystem")
        menuPictures.text = qsTrId("menu-add-files")
        menuStartSlideshow.text = qsTrId("menu-start-slideshow")
        slideshowNameField.label = qsTrId("slideshow-name-label")
        slideshowNameField.placeholderText = qsTrId("slideshow-name-placeholder")
        slideshowBackgroundMusicLabel.text = qsTrId("slideshow-background-music")
        slideshowImagesLabel.text = qsTrId("slideshow-images")
    }

    function getSlideshowOrder() {
        return Constants.getSlideshowOrder(imageListModel.count, Settings.getBooleanSetting(Constants.randomKey, false))
    }
}
