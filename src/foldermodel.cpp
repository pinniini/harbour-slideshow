/*
  Copyright (c) 2015, Joni Korhonen (pinniini)
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  * Neither the name of harbour-slideshow nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#include "foldermodel.h"

#include <QDir>

FolderModel::FolderModel(QObject *parent) :
    QAbstractListModel(parent), m_firstNonfolderIndex(-1)
{

}

FolderModel::~FolderModel()
{
    // Clear items.
    clearItems();
}

// ---------------------------------------------------------
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

// Gets first item's, which is not folder, index.
int FolderModel::firstNonfolderIndex() const
{
    return m_firstNonfolderIndex;
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


// ---------------------------------------------------------
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


// ---------------------------------------------------------
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

    bool firstNonfolderFound = false;

    // Add entries to the model.
    foreach (QFileInfo info, list)
    {
        // Create item.
        FolderItem *itm = new FolderItem();
        itm->setFileName(info.fileName());
        itm->setFilePath(info.absoluteFilePath());
        itm->setIsFolder(info.isDir());
        m_folderItems.append(itm);

        // If first non folder not found and current item is not a folder.
        if(!firstNonfolderFound && !info.isDir())
        {
            m_firstNonfolderIndex = (m_folderItems.count() - 1);
            firstNonfolderFound = true;
        }
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

    // Set first nonfolder to default.
    m_firstNonfolderIndex = -1;
}
