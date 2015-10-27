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

#include <QDebug>
#include <QGuiApplication>
#include <sailfishapp.h>

#include "translationhandler.h"

TranslationHandler::TranslationHandler(QObject *parent) : QObject(parent)
{
    qDebug() << "Creating translation handler...";
    m_langPath = SailfishApp::pathTo("translations").toLocalFile();
    m_langFilePrefix = "harbour-slideshow-";
    m_defaultLangPrefix = "harbour-slideshow";
    qDebug() << "Language path " + m_langPath;
}

TranslationHandler::~TranslationHandler()
{

}

// Public

void TranslationHandler::loadTranslation(QString language)
{
    qDebug() << "Selected language: " << language;

    // No languge.
    if(language == "")
        return;

    // Remove old translator and load new file.
    qApp->removeTranslator(&m_translator);
    m_translator.load(m_langFilePrefix + language, m_langPath);

    // Try to actually load the translation.
    if(qApp->installTranslator(&m_translator))
    {
        emit translateUI();
    }
}
