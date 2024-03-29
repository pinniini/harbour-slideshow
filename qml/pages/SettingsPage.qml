import QtQuick 2.5
import Sailfish.Silica 1.0
import "../constants.js" as Constants

Page {
    id: settingsPage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // Use these to prevent binding loop.
    property int intrvl: Settings.getIntSetting(Constants.intervalKey, 5)
    property bool lp: Settings.getBooleanSetting(Constants.loopKey, true)
    property bool randm: Settings.getBooleanSetting(Constants.randomKey, false)
    property bool stp: Settings.getBooleanSetting(Constants.stopMinimizedKey, true)
    property bool selectFolderFromRoot: Settings.getBooleanSetting(Constants.selectFolderFromRootKey, false)
    property bool loopMusic: Settings.getBooleanSetting(Constants.loopMusicKey, true)
    property bool hiresImages: Settings.getBooleanSetting(Constants.hiresImagesKey, true)

    Component.onCompleted: {
        var language = Settings.getStringSetting(Constants.languageKey, Qt.locale().name.substring(0,2))

        for(var i = 0; i < languageContext.children.length; ++i)
        {
            var child = languageContext.children[i]
            if(child.hasOwnProperty("value"))
            {
                // Current language found.
                if(child.value === language)
                {
                    languageCombo.currentIndex = i
                    break
                }
            }
        }
    }

    Connections {
        target: TranslationHandler
        onTranslateUI: {
            translateUi()
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        clip: true
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: pageHeader
                title: qsTrId("label-settings")
            }

            SectionHeader {
                id: settingsHeaderUI
                text: qsTrId("settings-header-ui")
            }

            ComboBox {
                id: languageCombo
                label: qsTrId("label-language")

                menu: ContextMenu {
                    id: languageContext
                    MenuItem {
                        property string value: "en"
                        text: "English"
                        onClicked: {
                            setLanguage(value)
                        }
                    }
                    MenuItem {
                        property string value: "fi"
                        text: "Suomi"
                        onClicked: {
                            setLanguage(value)
                        }
                    }
                    MenuItem {
                        property string value: "sv"
                        text: "Svenska"
                        onClicked: {
                            setLanguage(value)
                        }
                    }
                }
            }

            SectionHeader {
                id: settingsHeaderSlideshow
                text: qsTrId("settings-header-slideshow")
            }

            Slider {
                id: intervalSlider

                property string second: qsTrId("second")
                property string seconds: qsTrId("seconds")

                width: parent.width
                minimumValue: 1
                maximumValue: 30
                value: intrvl
                stepSize: 1
                valueText: value + " " + (value == 1 ? second : seconds)
                label: qsTrId("settings-slideshow-interval-label")

                onValueChanged: {
                    Settings.setSetting(Constants.intervalKey, value)
                }
            }

            TextSwitch {
                id: loopSwitch
                text: qsTrId("settings-loop")
                description: qsTrId("settings-loop-description")
                checked: lp

                onCheckedChanged: {
                    Settings.setSetting(Constants.loopKey, checked)
                }
            }

            TextSwitch {
                id: randomSwitch
                text: qsTrId("settings-random")
                description: qsTrId("settings-random-description")
                checked: randm

                onCheckedChanged: {
                    Settings.setSetting(Constants.randomKey, checked)
                }
            }

            TextSwitch {
                id: stopSwitch
                text: qsTrId("settings-stop-background")
                description: qsTrId("settings-stop-background-description")
                checked: stp

                onCheckedChanged: {
                    Settings.setSetting(Constants.stopMinimizedKey, checked)
                }
            }

            TextSwitch {
                id: loopMusicSwitch
                text: qsTrId("settings-loop-background-music")
                description: qsTrId("settings-loop-background-music-description")
                checked: loopMusic

                onCheckedChanged: {
                    Settings.setSetting(Constants.loopMusicKey, checked)
                }
            }

            TextSwitch {
                id: selectFolderFromRootSwitch
                text: qsTrId("settings-select-folder-from-root")
                description: qsTrId("settings-select-folder-from-root-description")
                checked: selectFolderFromRoot

                onCheckedChanged: {
                    Settings.setSetting(Constants.selectFolderFromRootKey, checked)
                }
            }

            SectionHeader {
                id: settingsHeaderImageViewer
                text: qsTrId("settings-header-imageViewer")
            }

            TextSwitch {
                id: hiresImagesSwitch
                text: qsTrId("settings-hires-images")
                description: qsTrId("settings-hires-images-description")
                checked: hiresImages

                onCheckedChanged: {
                    Settings.setSetting(Constants.hiresImagesKey, checked)
                }
            }
        }
    }

    function setLanguage(value) {
        Settings.setSetting(Constants.languageKey, value)
        TranslationHandler.loadTranslation(value)
    }

    function translateUi() {
        pageHeader.title = qsTrId("label-settings")

        // Slideshow
        settingsHeaderSlideshow.text = qsTrId("settings-header-slideshow")
        intervalSlider.second = qsTrId("second")
        intervalSlider.seconds = qsTrId("seconds")
        intervalSlider.label = qsTrId("settings-slideshow-interval-label")
        loopSwitch.text = qsTrId("settings-loop")
        loopSwitch.description = qsTrId("settings-loop-description")
        randomSwitch.text = qsTrId("settings-random")
        randomSwitch.description = qsTrId("settings-random-description")
        stopSwitch.text = qsTrId("settings-stop-background")
        stopSwitch.description = qsTrId("settings-stop-background-description")
        selectFolderFromRootSwitch.text = qsTrId("settings-select-folder-from-root")
        selectFolderFromRootSwitch.description = qsTrId("settings-select-folder-from-root-description")
        loopMusicSwitch.text = qsTrId("settings-loop-background-music")
        loopMusicSwitch.description = qsTrId("settings-loop-background-music-description")

        // Image viewe
        settingsHeaderImageViewer.text = qsTrId("settings-header-imageViewer")
        hiresImagesSwitch.text = qsTrId("settings-hires-images")
        hiresImagesSwitch.description = qsTrId("settings-hires-images-description")

        // UI
        settingsHeaderUI.text = qsTrId("settings-header-ui")
        languageCombo.label = qsTrId("label-language")
    }
}
