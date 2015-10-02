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
