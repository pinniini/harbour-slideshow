/*
  Copyright (C) 2015 Joni Korhonen
  Contact: Joni Korhonen <>
  All rights reserved.


*/

#include <QtQuick>
#include <QtQml>
#include <sailfishapp.h>

#include "settings.h"
#include "foldermodel.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Settings>("harbour.slideshow.Settings", 1, 0, "SlideSettings");
    qmlRegisterType<FolderModel>("harbour.slideshow.FolderModel", 1, 0, "FolderModel");

    QGuiApplication *a = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();
    view->rootContext()->setContextProperty("appVersion", APP_VERSION);
    view->setSource(SailfishApp::pathTo("qml/harbour-slideshow.qml"));
    view->show();
    return a->exec();
}
