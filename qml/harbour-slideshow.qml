import QtQuick 2.2
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    initialPage: Component { SlideshowListPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    ListModel {
        id: slideshowListModel
    }
}
