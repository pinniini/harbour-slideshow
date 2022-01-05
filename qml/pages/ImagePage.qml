import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: imagePage
    allowedOrientations: Orientation.All

    // Properties.
    property string imageUrl: ""

    // Image.
    Image {
        id: mainImage
        anchors.fill: parent
        anchors.centerIn: parent
        autoTransform: true
        asynchronous: true
        source: imageUrl
        fillMode: Image.PreserveAspectFit
        sourceSize.width: imagePage.width
        sourceSize.height: imagePage.height
    }
}
