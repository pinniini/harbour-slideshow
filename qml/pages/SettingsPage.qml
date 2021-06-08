import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: settingsPage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // Use these to prevent binding loop.
    property int intrvl: Settings.getIntSetting("Interval", 5)

    Component.onCompleted: {
        var language = Settings.getStringSetting("Language", Qt.locale().name.substring(0,2))
//        if (language === "en") {
//            languageCombo.currentIndex = 0;
//        } else if (language === "fi") {
//            languageCombo.currentIndex = 1;
//        }

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
                id: settingsHeaderGeneral
                text: qsTrId("settings-header-general")
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
                valueText: qsTrId("settings-interval-valueText", value) //value + " " + (value == 1 ? second : seconds)
                label: qsTrId("settings-slideshow-interval-label")

                onValueChanged: {
                    Settings.setSetting("Interval", value)
                }
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
                }
            }
        }
    }

    function setLanguage(value) {
        Settings.setSetting("Language", value)
        TranslationHandler.loadTranslation(value)
    }

    function translateUi() {
        pageHeader.title = qsTrId("label-settings")
        languageCombo.label = qsTrId("label-language")
    }
}
