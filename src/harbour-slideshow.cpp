/*
  Copyright (c) 2015, Joni Korhonen (pinniini)
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  * Neither the name of harbour-slideshow nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#include <QtQuick>
#include <QtQml>
#include <sailfishapp.h>
#include <QTranslator>

#include "settings.h"
#include "foldermodel.h"
#include "translationhandler.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Settings>("harbour.slideshow.Settings", 1, 0, "SlideSettings");
    qmlRegisterType<FolderModel>("harbour.slideshow.FolderModel", 1, 0, "FolderModel");
    qmlRegisterType<TranslationHandler>("harbour.slideshow.TranslationHandler", 1, 0, "TranslationHandler");

    QGuiApplication *a = SailfishApp::application(argc, argv);

    // Translations.
    Settings settings;
    QString locale = settings.language();
    QTranslator translator;
    if(locale != "en" && !translator.load("harbour-slideshow-" + locale, SailfishApp::pathTo("translations").toLocalFile()))
    {
        qDebug() << "Could not load locale: " + locale;

        locale = QLocale::system().name();
        if(!translator.load("harbour-slideshow-" + locale, SailfishApp::pathTo("translations").toLocalFile()))
        {
            qDebug() << "Could not load locale: " + locale;
        }
    }
    a->installTranslator(&translator);

    QQuickView *view = SailfishApp::createView();
    view->rootContext()->setContextProperty("appVersion", APP_VERSION);
    view->setSource(SailfishApp::pathTo("qml/harbour-slideshow.qml"));
    view->show();
    return a->exec();
}
