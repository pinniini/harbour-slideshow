#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT

    // Exposed properties.
    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
    Q_PROPERTY(bool loop READ loop WRITE setLoop NOTIFY loopChanged)
    Q_PROPERTY(bool stopMinimized READ stopMinimized WRITE setStopMinimized NOTIFY stopMinimizedChanged)

public:
    explicit Settings(QObject *parent = 0);

    // Property getters/setters.
    int interval() const;
    void setInterval(int interval);
    bool loop() const;
    void setLoop(bool loop);
    bool stopMinimized() const;
    void setStopMinimized(bool stopMinimized);

    // Signals.
signals:
    void intervalChanged(int interval);
    void loopChanged(bool loop);
    void stopMinimizedChanged(bool stopMinimized);

public slots:

private:
    int m_interval;
    bool m_loop;
    bool m_stopMinimized;
};

#endif // SETTINGS_H
