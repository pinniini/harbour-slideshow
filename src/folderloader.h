#ifndef FOLDERLOADER_H
#define FOLDERLOADER_H

#include <QObject>
#include <QStringList>

class FolderLoader : public QObject
{
    Q_OBJECT
public:
    explicit FolderLoader(QObject *parent = nullptr);

    Q_INVOKABLE QStringList readFilesInFolder(const QString& folderPath);

signals:

};

#endif // FOLDERLOADER_H
