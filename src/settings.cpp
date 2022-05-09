#include "settings.h"
#include "migrator.h"

#include <QCoreApplication>
#include <QSettings>
#include <QDebug>
#include <QStandardPaths>

Settings::Settings(QObject *parent) : QObject(parent)
{
    Migrator migrator;
    bool migrationStatus = migrator.migrate();
    QString migrationError = "";
    if (!migrationStatus)
    {
        migrationError = migrator.lastError();
        qDebug() << "Error occured while migrating configurations to comply with SailJail." << migrationError;
    }

    _settings = new QSettings(
            QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation) + "/" + QCoreApplication::applicationName() + ".conf",
            QSettings::IniFormat);
}

void Settings::setSetting(QString key, QVariant value)
{
//    QSettings settings;
    _settings->setValue(key, value);
}

QString Settings::getStringSetting(QString key, QString defaultValue)
{
//    QSettings settings;
    return _settings->value(key, defaultValue).toString();
}

bool Settings::getBooleanSetting(QString key, bool defaultValue)
{
//    QSettings settings;
    return _settings->value(key, defaultValue).toBool();
}

int Settings::getIntSetting(QString key, int defaultValue)
{
//    QSettings settings;
    return _settings->value(key, defaultValue).toInt();
}
