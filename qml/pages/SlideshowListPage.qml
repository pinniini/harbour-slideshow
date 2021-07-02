import QtQuick 2.5
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

import "../js/database.js" as DB

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property int editIndex: -1

    Component.onCompleted: {
        // Load slideshows
        loadSlideshows();
    }

    Connections {
        target: TranslationHandler
        onTranslateUI: {
            translateUi()
        }
    }

    ListModel {
        id: playingSlideshowImageModel
    }
    ListModel {
        id: playingSlideshowMusicModel
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
            MenuItem {
                id: slideshowListMenuSettings
                text: qsTrId("menu-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                id: menuQuickStartSlideshow
                text: qsTrId("menu-quickstart-slideshow")
                onClicked: {
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
                    //addSlideshow(dialog.slideshow);
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
                    text: qsTrId("menu-start-slideshow")
                    onClicked: {
                        console.log("Start slideshow...")
                        var show = slideshowListModel.get(index)
                        if (generatePlayingModels(show.id)) {
                            pageStack.push(Qt.resolvedUrl("PlaySlideshowPage.qml"), {'imageModel': playingSlideshowImageModel, 'musicModel': playingSlideshowMusicModel})
                        }
                    }
                }
            }
        }
    }

    Component {
        id: quickFolderPickerDialog
        FolderPickerDialog {
            title: qsTrId("quick-folderpicker-title")
            onAccepted: {
                console.log("Run slideshow from selected folder:", selectedPath)
            }
        }
    }

    function translateUi() {
        slideshowListPlaceHolder.text = qsTrId("slideshowlist-no-slideshows")
        slideshowList.headerItem.title = qsTrId("slideshowlist-header")
        slideshowListMenuSettings.text = qsTrId("menu-settings")
        slideshowListMenuAddSlideshow.text = qsTrId("menu-add-slideshow")
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
}
