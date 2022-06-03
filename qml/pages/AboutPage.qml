import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // React on status changes.
//    onStatusChanged: {
    Component.onCompleted: {
        issueLabel.text = Theme.highlightText(qsTrId("about-issues"), "github", Theme.highlightColor)
        swedishTranslationLabel.text = Theme.highlightText(qsTrId("about-swedish-translations"), "eson57", Theme.highlightColor)
    }

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
                title: qsTrId("about")
            }

            SectionHeader {
                text: qsTrId("about-info-header")
            }

            Label {
                text: qsTrId("about-info")
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
            }

            Label {
                text: qsTrId("version").arg(appVersion)
                x: Theme.paddingMedium
            }

            SectionHeader {
                text: qsTrId("about-by-who-header")
            }

            Label {
                text: "pinniini (Joni Korhonen)"
                x: Theme.paddingMedium
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
            }

            SectionHeader {
                text: qsTrId("about-licence-header")
            }

            Label {
                text: "BSD"
                font.underline: true
                x: Theme.paddingMedium
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://choosealicense.com/licenses/bsd-3-clause/")
                }
            }

            SectionHeader {
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
                text: qsTrId("about-credits")
            }

            Label {
                id: swedishTranslationLabel
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                text: qsTrId("about-swedish-translations")
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://github.com/eson57")
                }
            }

            SectionHeader {
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
