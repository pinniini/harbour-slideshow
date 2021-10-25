#ifndef FOLDERWORKER_H
#define FOLDERWORKER_H

#include <QObject>

class FolderWorker : public QObject
{
    Q_OBJECT
public:
    explicit FolderWorker(QObject *parent = nullptr);

public slots:
    void doWork(const QString &folderPath);

signals:
    void fileLoadedFromFolder(const QString &folderPath, const QString &filePath);
    void filesLoadedFromFolder(const QString &folderPath, const QStringList &filePaths);
};

#endif // FOLDERWORKER_H
