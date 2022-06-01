#ifndef FOLDERLOADER_H
#define FOLDERLOADER_H

#include <QObject>
#include <QStringList>
#include <QThread>

class FolderLoader : public QObject
{
    Q_OBJECT
public:
    explicit FolderLoader(QObject *parent = nullptr);
    ~FolderLoader();

    Q_INVOKABLE void readFilesInFolder(const QString& folderPath);

public slots:
    void handleFileLoaded(const QString &folder, const QString &filePath);
    void handleFilesLoaded(const QString &folder, const QStringList &fileList);

signals:
    void initiateFileLoading(const QString &folder);
    void fileLoadedFromFolder(const QString &folder, const QString &filePath);
    void filesLoadedFromFolder(const QString &folder, const QStringList &filePaths);

private:
    QString _folderPath;
    QThread _workerThread;
};

#endif // FOLDERLOADER_H
