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

#include "settings.h"

#include <QSettings>

Settings::Settings(QObject *parent) :
    QObject(parent), m_interval(5), m_loop(true), m_random(false), m_stopMinimized(true), m_language("en")
{
    // Use QSettings for the settings.
    // CONFIG += sailfishapp takes care about organization and application name,
    // so that the path is valid.
    QSettings settings;
    m_interval = settings.value("interval", 5).toInt();
    m_loop = settings.value("loop", true).toBool();
    m_random = settings.value("random", false).toBool();
    m_stopMinimized = settings.value("stopMinimized", true).toBool();
    m_language = settings.value("language", "").toString();
}

/*
 * Property getters and setters.
 */

// Get interval.
int Settings::interval() const
{
    return m_interval;
}

// Set interval.
void Settings::setInterval(int interval)
{
    m_interval = interval;
    emit intervalChanged(m_interval);

    QSettings settings;
    settings.setValue("interval", m_interval);
}

// Get loop.
bool Settings::loop() const
{
    return m_loop;
}

// Set loop.
void Settings::setLoop(bool loop)
{
    m_loop = loop;
    emit loopChanged(m_loop);

    QSettings settings;
    settings.setValue("loop", m_loop);
}

// Get random.
bool Settings::random() const
{
    return m_random;
}

// Set random.
void Settings::setRandom(bool random)
{
    m_random = random;
    emit randomChanged(m_random);

    QSettings settings;
    settings.setValue("random", m_random);
}

// Get stopMinimized.
bool Settings::stopMinimized() const
{
    return m_stopMinimized;
}

// Set stopMinimized.
void Settings::setStopMinimized(bool stopMinimized)
{
    m_stopMinimized = stopMinimized;
    emit stopMinimizedChanged(m_stopMinimized);

    QSettings settings;
    settings.setValue("stopMinimized", m_stopMinimized);
}

// Get language.
QString Settings::language() const
{
    return m_language;
}

// Set language.
void Settings::setLanguage(const QString &language)
{
    // Language changes.
    if(m_language != language)
    {
        m_language = language;
        emit languageChanged(m_language);

        QSettings settings;
        settings.setValue("language", m_language);
    }
}
