import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        anchors.fill: parent

        model: slideshowListModel
        ViewPlaceholder {
            text: qsTrId("slideshowlist-no-slideshows")
            enabled: slideshowListModel.count == 0
        }

        header: PageHeader {
            title: qsTrId("slideshowlist-header")
        }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
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
        }
    }
}
