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
