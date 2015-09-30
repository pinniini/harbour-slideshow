#include "foldermodel.h"

#include <QDir>

FolderModel::FolderModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

FolderModel::~FolderModel()
{
    // Clear items.
    clearItems();
}

// Property getter/setter.

// Get folder.
QString FolderModel::folder() const
{
    return m_folder;
}

// Set folder.
void FolderModel::setFolder(const QString folder)
{
    if(folder.isEmpty() || m_folder == folder)
        return;

    // Read folder.
    m_folder = folder;
    readFolder();

    emit folderChanged(m_folder);
}

// Get folder name.
QString FolderModel::folderName() const
{
    return m_folderName;
}

// Check if item in given index is folder or not.
bool FolderModel::isFolder(const int &index)
{
    // Check index constraints.
    if(index < 0 || index >= m_folderItems.count())
        return false;

    return m_folderItems.at(index)->isFolder();
}

// Get path from the given index.
QString FolderModel::getPath(const int &index)
{
    // Check index constraints.
    if(index < 0 || index >= m_folderItems.count())
        return "";

    return m_folderItems.at(index)->filePath();
}

// Row count.
int FolderModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_folderItems.count();
}

// Data.
QVariant FolderModel::data(const QModelIndex &index, int role) const
{
    // Check index.
    if(!index.isValid())
        return QVariant();

    // Check index range.
    if(index.row() >= m_folderItems.count() || index.row() < 0)
        return QVariant();

    // Check role.
    const FolderItem *item = m_folderItems.at(index.row());
    if(role == NameRole)
    {
        return item->fileName();
    }
    else if(role == PathRole)
    {
        return item->filePath();
    }
    else if(role == IsFolderRole)
    {
        return item->isFolder();
    }
    else
        return QVariant();
}


// Protected part.

// Role names.
QHash<int, QByteArray> FolderModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "fileName";
    roles[PathRole] = "filePath";
    roles[IsFolderRole] = "isFolder";
    return roles;
}


// Private part.

// Read current folder.
void FolderModel::readFolder()
{
    // Check folder existence.
    QDir folder(m_folder);
    if(!folder.exists())
        return;

    // Notify view.
    beginResetModel();

    // Clear current folder items.
    clearItems();

    // Set folder name.
    m_folderName = folder.dirName();
    if(folder.isRoot())
        m_folderName = folder.absolutePath();

    // Set filters, name filters and sorting.
    folder.setFilter(QDir::AllDirs | QDir::Files | QDir::NoDot | QDir::Readable);
    folder.setSorting(QDir::Name | QDir::DirsFirst);
    QStringList filters;
    filters << "*.jpg" << "*.png";
    folder.setNameFilters(filters);

    // Read folder entries.
    QFileInfoList list = folder.entryInfoList();

    // Remove up if root reached.
    if(folder.isRoot())
        list.pop_front();

    // Add entries to the model.
    foreach (QFileInfo info, list)
    {
        // Create item.
        FolderItem *itm = new FolderItem();
        itm->setFileName(info.fileName());
        itm->setFilePath(info.absoluteFilePath());
        itm->setIsFolder(info.isDir());
        m_folderItems.append(itm);
    }

    endResetModel();
}

// Clear items.
void FolderModel::clearItems()
{
    // Free memory.
    for(int i = 0; i < m_folderItems.count(); ++i)
    {
        delete m_folderItems.at(i);
        m_folderItems.replace(i, 0);
    }

    // Clear items list.
    m_folderItems.clear();
}
