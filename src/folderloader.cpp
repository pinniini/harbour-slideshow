#include "folderloader.h"
#include "folderworker.h"

#include <QDir>
#include <QImageReader>

FolderLoader::FolderLoader(QObject *parent) : QObject(parent), _folderPath("")
{
    FolderWorker *worker = new FolderWorker();
    worker->moveToThread(&_workerThread);

    connect(&_workerThread, &QThread::finished, worker, &QObject::deleteLater);
    connect(this, &FolderLoader::initiateFileLoading, worker, &FolderWorker::doWork);
    connect(worker, &FolderWorker::fileLoadedFromFolder, this, &FolderLoader::handleFileLoaded);
    connect(worker, &FolderWorker::filesLoadedFromFolder, this, &FolderLoader::handleFilesLoaded);

    _workerThread.start();
}

FolderLoader::~FolderLoader()
{
    _workerThread.quit();
    _workerThread.wait();
}

void FolderLoader::readFilesInFolder(const QString &folderPath)
{
    emit initiateFileLoading(folderPath);
//    _folderPath = folderPath;

//    QStringList fileList;
//    QDir dir(_folderPath);

//    if (dir.exists(_folderPath))
//    {
//        QStringList filters;
//        foreach (QByteArray format, QImageReader::supportedImageFormats())
//        {
//            filters << "*." + QString(format);
//        }

//        auto fileInfoList = dir.entryInfoList(filters, QDir::Files | QDir::Readable);
//        foreach (QFileInfo info, fileInfoList)
//        {
//            fileList << "file://" + info.absoluteFilePath();
//        }
//    }

    //    return fileList;
}

void FolderLoader::handleFileLoaded(const QString &folder, const QString &filePath)
{
    emit fileLoadedFromFolder(folder, filePath);
}

void FolderLoader::handleFilesLoaded(const QString &folder, const QStringList &fileList)
{
    emit filesLoadedFromFolder(folder, fileList);
}
