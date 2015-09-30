#ifndef FOLDERITEM_H
#define FOLDERITEM_H

#include <QObject>

class FolderItem : public QObject
{
    Q_OBJECT
public:
    explicit FolderItem(QObject *parent = 0);
    FolderItem(QString fileName, QString filePath, bool isFolder, QObject *parent = 0);

    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
    Q_PROPERTY(bool isFolder READ isFolder WRITE setIsFolder NOTIFY isFolderChanged)

    // Property getters/setters.
    QString fileName() const;
    void setFileName(const QString name);
    QString filePath() const;
    void setFilePath(const QString path);
    bool isFolder() const;
    void setIsFolder(bool isFolder);

signals:
    void fileNameChanged(const QString fileName);
    void filePathChanged(const QString filePath);
    void isFolderChanged(const bool isFolder);

private:
    QString m_fileName;
    QString m_filePath;
    bool m_isFolder;

};

#endif // FOLDERITEM_H
