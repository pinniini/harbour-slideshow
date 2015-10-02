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

#ifndef FOLDERMODEL_H
#define FOLDERMODEL_H

#include <QAbstractListModel>

#include "folderitem.h"

class FolderModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum FileRoles {
        NameRole = Qt::UserRole + 1,
        PathRole,
        IsFolderRole
    };

    explicit FolderModel(QObject *parent = 0);
    ~FolderModel();

    Q_PROPERTY(QString folder READ folder WRITE setFolder NOTIFY folderChanged)
    Q_PROPERTY(QString folderName READ folderName NOTIFY folderNameChanged)

    // Folder getter/setter.
    QString folder() const;
    void setFolder(const QString folder);

    // Folder name getter.
    QString folderName() const;

    // Check if item in given index is folder or not.
    Q_INVOKABLE bool isFolder(const int &index);

    // Get path from the given index.
    Q_INVOKABLE QString getPath(const int &index);

    // Must reimplement for the model to work.
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

signals:
    void folderChanged(const QString folder);
    void folderNameChanged(const QString folderName);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    // Functions.
    void readFolder();
    void clearItems();

    QList<FolderItem *> m_folderItems;
    QString m_folder;
    QString m_folderName;
};

#endif // FOLDERMODEL_H
