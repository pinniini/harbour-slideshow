#include "folderloader.h"
#include <QDir>
#include <QImageReader>

FolderLoader::FolderLoader(QObject *parent) : QObject(parent)
{

}

QStringList FolderLoader::readFilesInFolder(const QString &folderPath)
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
        }
    }

    return fileList;
}
