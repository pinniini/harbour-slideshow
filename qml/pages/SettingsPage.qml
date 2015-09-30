/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

import QtQuick 2.1
import Sailfish.Silica 1.0

import harbour.slideshow.Settings 1.0

Page {
    id: settingsPage
    allowedOrientations: Orientation.All

    // Properties.
    property alias slideSettings: settings

    // Use these to prevent binding loop.
    property int intrvl: settings.interval
    property bool lp: settings.loop
    property bool stp: settings.stopMinimized

    PageHeader {
        id: pageHeader
        title: qsTr("Settings")
    }

    // Settings.
    SlideSettings {
        id: settings
    }

    // Settings in flickable so that the page is scrollable
    // in cases that all of them does not fit on the screen
    // at the same time.
    SilicaFlickable {
        anchors {
            left: parent.left
            top: pageHeader.bottom
            right: parent.right
            bottom: parent.bottom
        }

        contentHeight: column.height

        Column {
            id: column
            spacing: 10
            width: parent.width

            Slider {
                id: intervalSlider
                width: parent.width
                minimumValue: 1
                maximumValue: 30
                value: intrvl
                stepSize: 1
                valueText: value + " " + qsTr("seconds")
                label: qsTr("Slideshow interval")

                onValueChanged: {
                    settings.interval = value
                }
            }

            TextSwitch {
                id: loopSwitch
                text: qsTr("Loop pictures")
                description: qsTr("Slideshow starts over when reaching the end.")
                checked: lp

                onCheckedChanged: {
                    settings.loop = checked
                }
            }

            TextSwitch {
                id: stopSwitch
                text: qsTr("Stop when minimized")
                description: qsTr("Slideshow will be stopped when pushed minimized.")
                checked: stp

                onCheckedChanged: {
                    settings.stopMinimized = checked
                }
            }
        }
    }
}
