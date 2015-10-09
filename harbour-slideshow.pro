# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-slideshow

CONFIG += sailfishapp

SOURCES += src/harbour-slideshow.cpp \
    src/settings.cpp \
    src/foldermodel.cpp \
    src/folderitem.cpp

OTHER_FILES += qml/harbour-slideshow.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-slideshow.changes.in \
    rpm/harbour-slideshow.spec \
    rpm/harbour-slideshow.yaml \
    translations/*.ts \
    harbour-slideshow.desktop \
    qml/pages/MainPage.qml \
    qml/pages/SlideshowPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ImagePage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-slideshow-fi.ts \
    translations/harbour-slideshow-sv.ts \
    translations/harbour-slideshow-de.ts

VERSION = 0.7-1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

HEADERS += \
    src/settings.h \
    src/foldermodel.h \
    src/folderitem.h
