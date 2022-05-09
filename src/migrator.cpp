#include "migrator.h"

#include <QCoreApplication>
#include <QDebug>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDir>
#include <QFile>

Migrator::Migrator()
    : _lastError("")
{
}

bool Migrator::migrate()
{
    bool retValue = true;

    // Old paths.
    QString oldAppDataPath = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + "/harbour-slideshow/harbour-slideshow";
    QString oldCachePath = "";
    QString oldConfigPath = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/harbour-slideshow/harbour-slideshow.conf";

    qDebug() << "Old config path:" << oldConfigPath;
    qDebug() << "Old data path:" << oldAppDataPath;

    // Current paths.
    QString currentAppDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString currentCachePath = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
    QString currentConfigPath = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation) + "/" + QCoreApplication::applicationName() + ".conf";

    qDebug() << "Current config path:" << currentConfigPath;
    qDebug() << "Current data path:" << currentAppDataPath;

    if ((!QFileInfo(currentConfigPath).exists() && !QDir(currentConfigPath).exists()) &&
            (QFileInfo(oldConfigPath).exists() && !QDir(oldConfigPath).exists()))
    {
//        retValue = QDir::mkpath(currentConfigPath);

        qDebug() << "Renaming/moving old config file to new location...";
        QFile oldConfig(oldConfigPath);
        retValue = oldConfig.copy(currentConfigPath);
        if (!retValue)
        {
            _lastError = oldConfig.errorString();
//            _lastError = "Could not copy old config file as new one...";
        }
    }

    return retValue;
}

QString Migrator::lastError()
{
    return _lastError;
}
