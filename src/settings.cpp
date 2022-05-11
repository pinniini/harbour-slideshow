#include "settings.h"
#include "migrator.h"

#include <QCoreApplication>
#include <QSettings>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

Settings::Settings(QObject *parent) : QObject(parent)
{
    Migrator migrator("harbour-slideshow");
    bool migrationStatus = migrator.migrate();
    QString migrationError = "";
    if (!migrationStatus)
    {
        migrationError = migrator.lastError();
        qDebug() << "Error occured while migrating configurations to comply with SailJail." << migrationError;
    }

    _settings = new QSettings(
            migrator.configFile(),
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
