#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include "translationhandler.h"
#include "settings.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-slideshow.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).

//    return SailfishApp::main(argc, argv);

    QScopedPointer<QGuiApplication> a(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QTranslator translator;
    Settings setts;
    QString sysLocale = QLocale::system().name();
    sysLocale.resize(2);
    bool translationsLoaded = true;
    QString locale = setts.getStringSetting("Language", sysLocale);
    if(!translator.load("harbour-slideshow-" + locale, SailfishApp::pathTo("translations").toLocalFile()))
    {
        qDebug() << "Could not load locale: " + locale;
        translationsLoaded = false;

//        locale = QLocale::system().name();
//        if(!translator.load("harbour-slideshow-" + locale, SailfishApp::pathTo("translations").toLocalFile()))
//        {
//            qDebug() << "Could not load locale: " + locale;
//        }
//        else
//        {
//            translationsLoaded = true;
//        }
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

    QString appVersion = "2.0.0";
    view->rootContext()->setContextProperty("Settings", settings);
    view->rootContext()->setContextProperty("TranslationHandler", handler);
    view->rootContext()->setContextProperty("appVersion", appVersion);
    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return a->exec();
}
