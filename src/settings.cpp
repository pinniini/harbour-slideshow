#include "settings.h"
#include "migrator.h"

#include <QCoreApplication>
#include <QSettings>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

Settings::Settings(QString configFile, QObject *parent)
    : QObject(parent), _configFile(configFile)
{
    _settings = new QSettings(
            _configFile,
            QSettings::IniFormat);
}

void Settings::setSetting(QString key, QVariant value)
{
    _settings->setValue(key, value);
}

QString Settings::getStringSetting(QString key, QString defaultValue)
{
    return _settings->value(key, defaultValue).toString();
}

bool Settings::getBooleanSetting(QString key, bool defaultValue)
{
    return _settings->value(key, defaultValue).toBool();
}

int Settings::getIntSetting(QString key, int defaultValue)
{
    return _settings->value(key, defaultValue).toInt();
}
