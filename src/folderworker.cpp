#include "folderworker.h"

#include <QDir>
#include <QImageReader>

FolderWorker::FolderWorker(QObject *parent) : QObject(parent)
{

}

void FolderWorker::doWork(const QString &folderPath)
{
    QStringList fileList;
    QDir dir(folderPath);

    if (dir.exists(folderPath))
    {
        QStringList filters;
        foreach (QByteArray format, QImageReader::supportedImageFormats())
        {
            filters << "*." + QString(format);
        }

        auto fileInfoList = dir.entryInfoList(filters, QDir::Files | QDir::Readable);
        foreach (QFileInfo info, fileInfoList)
        {
            fileList << "file://" + info.absoluteFilePath();
            emit fileLoadedFromFolder(folderPath, "file://" + info.absoluteFilePath());
        }
    }

    emit filesLoadedFromFolder(folderPath, fileList);
}
