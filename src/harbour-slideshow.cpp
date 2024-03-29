//#ifdef QT_QML_DEBUG
#include <QtQuick>
//#endif
#include <QDebug>
#include <QImageReader>
#include <QStringList>
#include <QByteArray>

#include <sailfishapp.h>

#include "migrator.h"
#include "translationhandler.h"
#include "settings.h"
#include "folderloader.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> a(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    a->setOrganizationDomain("pinniini.fi");
    a->setOrganizationName("fi.pinniini"); // needed for Sailjail
    a->setApplicationName("Slideshow");

    // Migrate configs and data.
    Migrator migrator("harbour-slideshow");
    bool migrationStatus = migrator.migrate();
    QString migrationError = "";
    if (!migrationStatus)
    {
        migrationError = migrator.lastError();
        qDebug() << "Error occured while migrating configurations to comply with SailJail." << migrationError;
    }

    // Settings
    Settings *settings = new Settings(migrator.configFile(), nullptr);

    QTranslator translator;
    QString sysLocale = QLocale::system().name();
    sysLocale.resize(2);
    bool translationsLoaded = true;
    QString locale = settings->getStringSetting("language", sysLocale);
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

    // Translator
    TranslationHandler *handler = new TranslationHandler(nullptr);

    // Supported image formats
    QStringList filters;
    foreach (QByteArray format, QImageReader::supportedImageFormats())
    {
        filters << "*." + QString(format);
    }
    qDebug() << "Supported image formats (as filters):" << filters;

    qmlRegisterType<FolderLoader>("fi.pinniini.slideshow", 1, 0, "FolderLoader");

    QString appVersion = "2.0.1";
    view->rootContext()->setContextProperty("Settings", settings);
    view->rootContext()->setContextProperty("TranslationHandler", handler);
    view->rootContext()->setContextProperty("appVersion", appVersion);
    view->rootContext()->setContextProperty("imageFileFilters", filters);
//    view->rootContext()->setContextProperty("MigrationStatus", migrationStatus);
//    view->rootContext()->setContextProperty("MigrationError", migrationError);

    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return a->exec();
}
