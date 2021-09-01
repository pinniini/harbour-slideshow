import QtQuick 2.5
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow
{
    initialPage: Component { SlideshowListPage { } }
    cover: coverPage //Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    CoverPage {
        id: coverPage
    }

    ListModel {
        id: slideshowListModel
    }

    Connections {
        id: mainSlideshowConnections
        target: null
        onImageChanged: {
            console.log("Image changed, current image:", url)
            coverPage.setImage(url)
        }
        onSlideshowRunningToggled: {
            console.log("Slideshow running:", runningStatus)
            coverPage.toggleSlideshowRunning(runningStatus)
        }
    }
}
