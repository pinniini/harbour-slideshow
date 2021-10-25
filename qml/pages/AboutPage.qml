import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // Content in flickable. Enables scroll if
    // content gets too long.
    SilicaFlickable {
        id: aboutFlick
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: 30

            PageHeader {
                id: header
//                title: qsTr("About Slideshow")
                title: qsTrId("about")
            }

            SectionHeader {
//                text: qsTr("Info")
                text: qsTrId("about-info-header")
            }

            Label {
//                text: qsTr("Slideshow is an application to automatically view your awesome pictures. It works folder-based, i.e. you select a folder which contains pictures and start the slideshow from the pulley menu. Simple!")
                text: qsTrId("about-info")
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
            }

            Label {
//                text: qsTr("Version ") + appVersion
                text: qsTrId("version").arg(appVersion)
                x: Theme.paddingMedium
            }

            SectionHeader {
//                text: qsTr("By who")
                text: qsTrId("about-by-who-header")
            }

            Label {
//                text: qsTr("Joni Korhonen, also known as pinniini")
                text: "pinniini (Joni Korhonen)"
                x: Theme.paddingMedium
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
            }

            SectionHeader {
//                text: qsTr("License")
                text: qsTrId("about-licence-header")
            }

            Label {
                text: "GNU GPLv2"
                font.underline: true
                x: Theme.paddingMedium
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://choosealicense.com/licenses/gpl-2.0/")
                }
            }

            SectionHeader {
//                text: qsTr("Code")
                text: qsTrId("about-code-header")
            }

            Label {
                text: "https://github.com/pinniini/harbour-slideshow"
                font.underline: true
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://github.com/pinniini/harbour-slideshow")
                }
            }

            SectionHeader {
//                text: qsTr("Ideas/Issues/Want to help")
                text: qsTrId("about-contributing-header")
            }

            Label {
                id: issueLabel
                textFormat: Text.AutoText
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                text: qsTrId("about-issues")

                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://github.com/pinniini/harbour-slideshow/issues")
                }
            }
        }
    }
}
