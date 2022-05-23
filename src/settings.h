#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QVariant>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QString configFile, QObject *parent = nullptr);

    Q_INVOKABLE void setSetting(QString key, QVariant value);
    Q_INVOKABLE QString getStringSetting(QString key, QString defaultValue);
    Q_INVOKABLE bool getBooleanSetting(QString key, bool defaultValue);
    Q_INVOKABLE int getIntSetting(QString key, int defaultValue);

private:
    QString _configFile;
    QSettings *_settings;
};

#endif // SETTINGS_H
