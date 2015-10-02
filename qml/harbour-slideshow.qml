/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow
{
    // Notify main page about application state.
    onApplicationActiveChanged: {
        mainPage.applicationActiveChanged(applicationActive)
    }

    // Main page.
    MainPage {
        id: mainPage

        onSlideImageChanged: {
            cover.setImage(image)
        }
    }

    CoverPage {
        id: cover
    }

    initialPage: mainPage
    cover: cover// Qt.resolvedUrl("cover/CoverPage.qml")
}
