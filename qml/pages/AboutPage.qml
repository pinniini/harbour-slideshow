/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: aboutPage
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
                title: "About Slideshow"
            }

            Label {
                text: "Slideshow application to automatically view your beautiful photos."
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                color: Theme.highlightColor
            }

            Label {
                text: "Version " + appVersion
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                color: Theme.highlightColor
            }

            Label {
                text: "Copyright: Joni Korhonen, also known as pinniini"
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingMedium
                x: Theme.paddingMedium
                color: Theme.highlightColor
            }
        }
    }
}
