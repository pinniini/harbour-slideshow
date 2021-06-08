#include "settings.h"

#include <QSettings>

Settings::Settings(QObject *parent) : QObject(parent)
{
}

void Settings::setSetting(QString key, QVariant value)
{
    QSettings settings;
    settings.setValue(key, value);
}

QString Settings::getStringSetting(QString key, QString defaultValue)
{
    QSettings settings;
    return settings.value(key, defaultValue).toString();
}

bool Settings::getBooleanSetting(QString key, bool defaultValue)
{
    QSettings settings;
    return settings.value(key, defaultValue).toBool();
}

int Settings::getIntSetting(QString key, int defaultValue)
{
    QSettings settings;
    return settings.value(key, defaultValue).toInt();
}
