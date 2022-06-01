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
    src/folderloader.cpp \
    src/folderworker.cpp \
    src/migrator.cpp \
    src/settings.cpp \
    src/translationhandler.cpp

DISTFILES += qml/harbour-slideshow.qml \
    qml/components/CollapsingHeader.qml \
    qml/constants.js \
    qml/cover/CoverPage.qml \
    qml/js/database.js \
    qml/pages/AboutPage.qml \
    qml/pages/ImagePage.qml \
    qml/pages/PlaySlideshowPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/SlideshowListPage.qml \
    qml/pages/SlideshowPage.qml \
    rpm/harbour-slideshow.changes.in \
    rpm/harbour-slideshow.changes.run.in \
    rpm/harbour-slideshow.spec \
    rpm/harbour-slideshow.yaml \
    translations/*.ts \
    harbour-slideshow.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
CONFIG += sailfishapp_i18n_idbased

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-slideshow-en.ts \
    translations/harbour-slideshow-fi.ts
    translations/harbour-slideshow-sv.ts

HEADERS += \
    src/folderloader.h \
    src/folderworker.h \
    src/migrator.h \
    src/settings.h \
    src/translationhandler.h
