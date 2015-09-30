#include "folderitem.h"

FolderItem::FolderItem(QObject *parent) :
    QObject(parent)
{
}

FolderItem::FolderItem(QString fileName, QString filePath, bool isFolder, QObject *parent) :
    QObject(parent), m_fileName(fileName), m_filePath(filePath), m_isFolder(isFolder)
{
}

// Property getters/setters.

// Get filename.
QString FolderItem::fileName() const
{
    return m_fileName;
}

// Set filename.
void FolderItem::setFileName(const QString name)
{
    if(name.isEmpty() || m_fileName == name)
        return;

    m_fileName = name;
    emit fileNameChanged(m_fileName);
}

// Get file path.
QString FolderItem::filePath() const
{
    return m_filePath;
}

// Set file path.
void FolderItem::setFilePath(const QString path)
{
    if(path.isEmpty() || m_filePath == path)
        return;

    m_filePath = path;
    emit filePathChanged(m_filePath);
}

// Get is folder.
bool FolderItem::isFolder() const
{
    return m_isFolder;
}

// Set is folder.
void FolderItem::setIsFolder(bool isFolder)
{
    if(m_isFolder == isFolder)
        return;

    m_isFolder = isFolder;
    emit isFolderChanged(m_isFolder);
}
