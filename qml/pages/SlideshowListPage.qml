import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    Connections {
        target: TranslationHandler
        onTranslateUI: {
            translateUi()
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
            MenuItem {
                id: slideshowListMenuSettings
                text: qsTrId("menu-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                id: slideshowListMenuAddSlideshow
                text: qsTrId("menu-add-slideshow")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("SlideshowPage.qml"))
                    dialog.accepted.connect(function() {
                        slideshowListModel.append({'name': dialog.slideshowName})
                    })
                }
            }
        }

        delegate: ListItem {
            id: delegate

            contentHeight: Theme.itemSizeSmall
            width: parent.width

            onClicked: {

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
                    }
                }
            }
        }
    }

    function translateUi() {
        slideshowListPlaceHolder.text = qsTrId("slideshowlist-no-slideshows")
        slideshowList.headerItem.title = qsTrId("slideshowlist-header")
        slideshowListMenuSettings.text = qsTrId("menu-settings")
        slideshowListMenuAddSlideshow.text = qsTrId("menu-add-slideshow")
    }
}
