#include "settings.h"

#include <QSettings>

Settings::Settings(QObject *parent) :
    QObject(parent), m_interval(5), m_loop(true), m_stopMinimized(true)
{
    // Use QSettings for the settings.
    // CONFIG += sailfishapp takes care about organization and application name,
    // so that the path is valid.
    QSettings settings;
    m_interval = settings.value("interval", 5).toInt();
    m_loop = settings.value("loop", true).toBool();
    m_stopMinimized = settings.value("stopMinimized", true).toBool();
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
    settings.setValue("interval", interval);
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
    settings.setValue("loop", loop);
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
    settings.setValue("stopMinimized", stopMinimized);
}
