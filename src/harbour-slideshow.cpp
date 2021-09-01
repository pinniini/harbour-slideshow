//#ifdef QT_QML_DEBUG
#include <QtQuick>
//#endif
#include <QDebug>
#include <QImageReader>
#include <QStringList>
#include <QByteArray>

#include <sailfishapp.h>

#include "translationhandler.h"
#include "settings.h"
#include "folderloader.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> a(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QTranslator translator;
    Settings setts;
    QString sysLocale = QLocale::system().name();
    sysLocale.resize(2);
    bool translationsLoaded = true;
    QString locale = setts.getStringSetting("language", sysLocale);
    if(!translator.load("harbour-slideshow-" + locale, SailfishApp::pathTo("translations").toLocalFile()))
    {
        qDebug() << "Could not load locale: " + locale;
        translationsLoaded = false;
    }

    // Just for safety.
    if (!translationsLoaded)
    {
        locale = "en";
        if(!translator.load("harbour-slideshow-" + locale, SailfishApp::pathTo("translations").toLocalFile()))
        {
            qDebug() << "Could not load locale: " + locale;
        }
    }

    a->installTranslator(&translator);

    // Settings
    Settings *settings = new Settings(nullptr);

    // Translator
    TranslationHandler *handler = new TranslationHandler(nullptr);

    // Supported image formats
    QStringList filters;
    foreach (QByteArray format, QImageReader::supportedImageFormats())
    {
        filters << "*." + QString(format);
    }
    qDebug() << "Supported image formats (as filters):" << filters;

    // Folder loader
    FolderLoader *folderLoader = new FolderLoader(nullptr);

    QString appVersion = "2.0.0";
    view->rootContext()->setContextProperty("Settings", settings);
    view->rootContext()->setContextProperty("TranslationHandler", handler);
    view->rootContext()->setContextProperty("appVersion", appVersion);
    view->rootContext()->setContextProperty("imageFileFilters", filters);
    view->rootContext()->setContextProperty("FolderLoader", folderLoader);
    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return a->exec();
}
