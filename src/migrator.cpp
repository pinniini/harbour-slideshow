#include "migrator.h"

#include <QDebug>
#include <QStandardPaths>

Migrator::Migrator()
    : _lastError("")
{
}

bool Migrator::migrate()
{
    bool retValue = true;

    qDebug() << QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    qDebug() << QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
    qDebug() << QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
    qDebug() << QStandardPaths::standardLocations(QStandardPaths::ConfigLocation);
    qDebug() << QStandardPaths::standardLocations(QStandardPaths::AppConfigLocation);

    // Old paths.
    QString oldAppDataPath = "";
    QString oldCachePath = "";
    QString oldConfigPath = "";

    // Current paths.
    QString currentAppDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString currentCachePath = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
    QString currentConfigPath = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);

    return retValue;
}

QString Migrator::lastError()
{
    return _lastError;
}
