import QtQuick 2.5
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

import "../js/database.js" as DB
import "../constants.js" as Constants
import fi.pinniini.slideshow 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property int editIndex: -1
    property bool quickStartSlideshow: false
    property string quickStartSlideshowFolderPath: ""

    // NOTE: used to translate slideshows context menu items.
    property bool translationToggle: false

    Component.onCompleted: {
        // Load slideshows
        loadSlideshows();
    }

    onStatusChanged: {
        if (status === PageStatus.Active && quickStartSlideshow && quickStartSlideshowFolderPath.length > 0
                && playingSlideshowImageModel.count > 0) {
            quickStartSlideshow = false
            quickStartSlideshowFolderPath = ""
            quickSlideshowBusyIndicator.running = false
            mainPullDownMenu.enabled = true
            mainPullDownMenu.busy = false
            mainSlideshowConnections.target = pageStack.push(Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': playingSlideshowImageModel, 'musicModel': playingSlideshowMusicModel, 'slideshowOrderArray': getSlideshowOrder()})
        }
    }

    Connections {
        target: TranslationHandler
        onTranslateUI: {
            translateUi()
            page.translationToggle = !page.translationToggle
        }
    }

    ListModel {
        id: playingSlideshowImageModel
    }
    ListModel {
        id: playingSlideshowMusicModel
    }

    FolderLoader {
        id: folderLoader
        onFilesLoadedFromFolder: {
            console.log("Files loaded from folder...")
            console.log("File count: " + filePaths.length)

            if (filePaths && filePaths.length > 0) {
                for (var i = 0; i < filePaths.length; ++i) {
                    playingSlideshowImageModel.append({'fileName': filePaths[i], 'url': filePaths[i]})
                }

                if (page.status === PageStatus.Active) {
                    quickStartSlideshow = false
                    quickStartSlideshowFolderPath = ""
                    quickSlideshowBusyIndicator.running = false
                    mainPullDownMenu.enabled = true
                    mainPullDownMenu.busy = false
//                    if (pageStack.nextPage(page) === null) {
//                        console.log("Empty next page...")
                        mainSlideshowConnections.target = pageStack.push(Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': playingSlideshowImageModel, 'musicModel': playingSlideshowMusicModel, 'slideshowOrderArray': getSlideshowOrder()})
//                    } else {
//                        console.log("Replace above...")
//                        pageStack.replaceAbove(page, Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': playingSlideshowImageModel, 'musicModel': playingSlideshowMusicModel})
//                    }
                }
            } else {
                quickStartSlideshow = false
                quickStartSlideshowFolderPath = ""
                quickSlideshowBusyIndicator.running = false
                mainPullDownMenu.enabled = true
                mainPullDownMenu.busy = false
                console.log("No supported image files in selected folder...");
            }
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: slideshowList
        anchors.fill: parent

        model: slideshowListModel
        ViewPlaceholder {
            id: slideshowListPlaceHolder
            text: qsTrId("slideshowlist-no-slideshows")
            enabled: slideshowListModel.count == 0
        }

        header: PageHeader {
            title: qsTrId("slideshowlist-header")
        }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            id: mainPullDownMenu

            MenuItem {
                id: slideshowListMenuAbout
                text: qsTrId("about")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                id: slideshowListMenuSettings
                text: qsTrId("menu-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                id: slideshowListMenuQuickStartSlideshow
                text: qsTrId("menu-quickstart-slideshow")
                onClicked: {
                    quickStartSlideshow = false
                    quickStartSlideshowFolderPath = ""
                    console.log("Quick Start slideshow, i.e. select folder and play...")
                    pageStack.push(quickFolderPickerDialog)
                }
            }

            MenuItem {
                id: slideshowListMenuAddSlideshow
                text: qsTrId("menu-add-slideshow")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("SlideshowPage.qml"))
                    dialog.accepted.connect(function() {
                        addSlideshow(dialog.slideshow);
                    })
                }
            }
        }

        delegate: ListItem {
            id: delegate

            contentHeight: Theme.itemSizeSmall
            width: parent.width

            onClicked: {
                editIndex = index
                var show = slideshowListModel.get(index)
                var dialog = pageStack.push(Qt.resolvedUrl("SlideshowPage.qml"), {'editMode': true, 'slideshowId': show.id})
                dialog.accepted.connect(function() {
                    updateSlideshow(dialog.slideshow);
                })
            }

            Label {
                text: model.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
            }

            menu: ContextMenu {
                MenuItem {
                    property bool translationToggle: page.translationToggle

                    text: qsTrId("menu-start-slideshow")
                    onClicked: {
                        console.log("Start slideshow...")
                        var show = slideshowListModel.get(index)
                        if (generatePlayingModels(show.id)) {
                            mainSlideshowConnections.target = pageStack.push(Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': playingSlideshowImageModel, 'musicModel': playingSlideshowMusicModel, 'slideshowOrderArray': getSlideshowOrder()})
                        }
                    }

                    onTranslationToggleChanged: {
                        text = qsTrId("menu-start-slideshow")
                    }
                }
            }
        }
    }

    BusyIndicator {
        id: quickSlideshowBusyIndicator
        running: false
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
    }

    Component {
        id: quickFolderPickerDialog
        FolderPickerDialog {
            id: folderPickerDialog
            path: Settings.getBooleanSetting(Constants.selectFolderFromRootKey, false) ? "/" : StandardPaths.home
            title: qsTrId("quick-folderpicker-title")
            onAccepted: {
                console.log("Run slideshow from selected folder:", selectedPath)
                //if (generateQuickPlayModels(selectedPath)) {
                quickStartSlideshow = true;
                quickStartSlideshowFolderPath = selectedPath
                generateQuickPlayModels(selectedPath);
                    //pageStack.replaceAbove(page, Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': playingSlideshowImageModel, 'musicModel': playingSlideshowMusicModel})
                //}
            }
        }
    }

    function translateUi() {
        slideshowListPlaceHolder.text = qsTrId("slideshowlist-no-slideshows")
        slideshowList.headerItem.title = qsTrId("slideshowlist-header")
        slideshowListMenuAbout.text = qsTrId("about")
        slideshowListMenuSettings.text = qsTrId("menu-settings")
        slideshowListMenuQuickStartSlideshow.text = qsTrId("menu-quickstart-slideshow")
        slideshowListMenuAddSlideshow.text = qsTrId("menu-add-slideshow")
        //folderPickerDialog.title = qsTrId("quick-folderpicker-title")
    }

    function loadSlideshows() {
        slideshowListModel.clear()

        var shows = DB.getSlideshowNames()
        if (shows && shows.length > 0) {
            var count = shows.length;
            for (var i = 0; i < count; ++i) {
                var show = shows[i];
                var sho = {'id': show.id, 'name': show.name};
                slideshowListModel.append(sho);
            }
        }
    }

    function addSlideshow(slideshow) {
        console.log("Adding slideshow:", slideshow.name);
        var slideId = DB.writeSlideshow(slideshow);
        console.log("Id for slideshow:", slideId);

        if (slideId > 0) {
            slideshowListModel.append({'id': slideId, 'name': slideshow.name})
        }
    }

    function updateSlideshow(slideshow) {
        console.log("Updating slideshow:", slideshow.id, slideshow.name)
        if (DB.updateSlideshow(slideshow)) {
            console.log("Updating slideshow succeeded...");
            slideshowListModel.setProperty(editIndex, 'name', slideshow.name)
        } else {
            console.log("Updating slideshow failed...");
        }
    }

    function generatePlayingModels(slideshowId) {
        var show = DB.getSlideshow(slideshowId)
        if (show) {
            playingSlideshowImageModel.clear()
            playingSlideshowMusicModel.clear()

            for (var mi = 0; mi < show.music.length; ++mi) {
                var mus = show.music[mi]
                playingSlideshowMusicModel.append({'fileName': mus.fileName, 'url': mus.url})
            }

            for (var ii = 0; ii < show.images.length; ++ii) {
                var img = show.images[ii]
                playingSlideshowImageModel.append({'fileName': img.fileName, 'url': img.url})
            }

            return true;
        }

        return false;
    }

    function generateQuickPlayModels(folderPath) {
        playingSlideshowImageModel.clear()
        playingSlideshowMusicModel.clear()
        quickSlideshowBusyIndicator.running = true
        mainPullDownMenu.enabled = false
        mainPullDownMenu.busy = true

        console.log("Start reading files from folder...")
        folderLoader.readFilesInFolder(folderPath)

//        var files = FolderLoader.readFilesInFolder(folderPath)
//        if (files && files.length > 0) {
//            for (var i = 0; i < files.length; ++i) {
//                playingSlideshowImageModel.append({'fileName': files[i], 'url': files[i]})
//            }

//            return true;
//        } else {
//            console.log("No supported image files in selected folder...");
//            return false;
//        }
    }

    function getSlideshowOrder() {
        return Constants.getSlideshowOrder(playingSlideshowImageModel.count, Settings.getBooleanSetting(Constants.randomKey, false))
    }
}
