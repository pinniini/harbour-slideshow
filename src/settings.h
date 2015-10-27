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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT

    // Exposed properties.
    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
    Q_PROPERTY(bool loop READ loop WRITE setLoop NOTIFY loopChanged)
    Q_PROPERTY(bool random READ random WRITE setRandom NOTIFY randomChanged)
    Q_PROPERTY(bool stopMinimized READ stopMinimized WRITE setStopMinimized NOTIFY stopMinimizedChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)

public:
    explicit Settings(QObject *parent = 0);

    // Property getters/setters.
    int interval() const;
    void setInterval(int interval);
    bool loop() const;
    void setLoop(bool loop);
    bool random() const;
    void setRandom(bool random);
    bool stopMinimized() const;
    void setStopMinimized(bool stopMinimized);
    QString language() const;
    void setLanguage(const QString &language);

    // Signals.
signals:
    void intervalChanged(int interval);
    void loopChanged(bool loop);
    void randomChanged(bool random);
    void stopMinimizedChanged(bool stopMinimized);
    void languageChanged(const QString &language);

public slots:

private:
    int m_interval;
    bool m_loop;
    bool m_random;
    bool m_stopMinimized;
    QString m_language;
};

#endif // SETTINGS_H
