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
    src/folderitem.cpp \
    src/translationhandler.cpp

OTHER_FILES += qml/harbour-slideshow.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-slideshow.spec \
    rpm/harbour-slideshow.yaml \
    translations/*.ts \
    harbour-slideshow.desktop \
    qml/pages/MainPage.qml \
    qml/pages/SlideshowPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ImagePage.qml \
    rpm/harbour-slideshow.changes

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-slideshow-fi.ts \
    translations/harbour-slideshow-sv.ts \
    translations/harbour-slideshow-en.ts \
    translations/harbour-slideshow-de.ts

VERSION = 1.0.3-1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

HEADERS += \
    src/settings.h \
    src/foldermodel.h \
    src/folderitem.h \
    src/translationhandler.h

icon108.path  = /usr/share/icons/hicolor/108x108/apps
icon108.files = 108x108/harbour-slideshow.png
icon128.path  = /usr/share/icons/hicolor/128x128/apps
icon128.files = 128x128/harbour-slideshow.png
icon256.path  = /usr/share/icons/hicolor/256x256/apps
icon256.files = 256x256/harbour-slideshow.png

INSTALLS = icon108 icon128 icon256
