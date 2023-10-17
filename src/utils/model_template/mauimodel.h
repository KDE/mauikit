/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2019  camilo <chiguitar@unal.edu.co>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once
#include <QAbstractListModel>
#include <QObject>
#include <QSortFilterProxyModel>

#include "mauikit_export.h"

class MauiList;

/**
 * @brief The MauiModel class.
 * 
 * The MauiModel is a template model to be uses with MauiList, it aims to be a simple data model to quickly setup string based models using the FMH::MODEL_LIST and FMH::MODEL_KEY types.
 * 
 * @note This class is exposed as the type `BaseModel` to the QML engine.
 * 
 * @code
 * Maui.BaseModel
 * {
 *  
 * }
 * @endcode
 * 
 * The idea is that the sorting and filtering is independent to the data list - MauiList.
 * Now, to get the right items keep in mind: MauiList::get() gets the item at the original list index, while MauiModel::get() will get the item at the model index, if it is filtered or sorted, then that's the item you'd get. 
 * 
 * If you want to get a item from the source list and the model has been filtered or sorted you will need to use the MauiModel::mappedToSource() to map the index to the right index from the source list. 
 * 
 * Now, if you have a index from the source list and the model has been filtered or ordered you will use MauiModel::mappedFromSource() to get the right index from the model.
 * 
 * <a href="https://invent.kde.org/maui/mauikit/-/blob/qt6-2/examples/mauilist/">You can find a more complete example at this link.</a>
*/
class MAUIKIT_EXPORT MauiModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_DISABLE_COPY(MauiModel)
    
    /*
     * The data list to be consumed by the model. All the operations and features of this class depend on having an actual MauiList to act upon.
     * @see MauiList
     */
    Q_PROPERTY(MauiList *list READ getList WRITE setList NOTIFY listChanged)
    
    /*
     * A single filter string. To clear the filter just set it to a empty string or invoke the `clearFilters()`method.
     * @see clearFilters
     */
    Q_PROPERTY(QString filter READ getFilter WRITE setFilter NOTIFY filterChanged)
    
    /*
     * Multiple filtering strings.
     * @see clearFilters
     */
    Q_PROPERTY(QStringList filters READ getFilters WRITE setFilters NOTIFY filtersChanged)
    
    /*
     * The key to be used for filtering. The sort keys can be found in the FMH::MODEL_NAME map of keys.
     * For example, to filter by `FMH::MODEL_KEY::TITLE`, use `"title"`. 
     */
    Q_PROPERTY(QString filterRole READ getFilterRoleName WRITE setFilterRoleName NOTIFY filterRoleNameChanged)
    
    /*
     * The sorting order.
     * By default the list is unsorted.
     * @see Qt::SortOrder
     */
    Q_PROPERTY(Qt::SortOrder sortOrder READ getSortOrder WRITE setSortOrder NOTIFY sortOrderChanged)
    
    /*
     * The sorting key value. The sort keys can be found in the FMH::MODEL_NAME map of keys.
     */
    Q_PROPERTY(QString sort READ getSort WRITE setSort NOTIFY sortChanged)
    
    /*
     * The total amount fo elements in the model.
     */
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    MauiModel(QObject *parent = nullptr);

    MauiList *getList() const;

    void setList(MauiList *);
    
    Qt::SortOrder getSortOrder() const;
    QString getSort() const;

    const QString getFilter() const;    
    const QStringList getFilters() const;

    QString getFilterRoleName() const;
    
    int count() const;
    
    bool moveRows(const QModelIndex &sourceParent, int sourceRow, int count, const QModelIndex &destinationParent, int destinationChild) override;
    bool moveRow(const QModelIndex &sourceParent, int sourceRow, const QModelIndex &destinationParent, int destinationChild);

protected:
    bool filterAcceptsRow(int, const QModelIndex &) const override;

private:
    class PrivateAbstractListModel;
    PrivateAbstractListModel *m_model;
    MauiList *m_list;
    
    QString m_filter;
    QStringList m_filters;
    QString m_filterRoleName;
    Qt::SortOrder m_sortOrder;
    QString m_sort;

public Q_SLOTS:
    
    void setFilter(const QString &filter);
    void setFilters(const QStringList &filters);
    
    void setSortOrder(const Qt::SortOrder &sortOrder);

    void setSort(const QString &sort);

    /**
     * @brief Returns an item in the model. This method correctly maps the given index in case the model has been sorted or filtered.
     * @param index the position index of the item in the list
     * @return a convenient QVariantMap that can be parsed on QML easily
     */
    QVariantMap get(const int &index) const;

    /**
     * @brief Returns all the items in the list represented as a QVariantList to be able to be used in QML. This operation performs a transformation from FMH::MODEL_LIST to QVariantList
     * @return all the items in the list
     */
    QVariantList getAll() const;

    /**
     * @brief Maps a given index from the base list to the model, in case the model has been filtered or sorted, this gives you the right mapped index
     * @param index the original position index in the list
     * @return the mapped index in the model
     */
    int mappedFromSource(const int &index) const;

    /**
     * @brief Given an index from the filtered or sorted model it returns the mapped index to the original list index.
     * @param index the model index
     * @return the original position index in the list
     */
    int mappedToSource(const int &) const;
    
    void setFilterRoleName(QString );    
    bool move(const int &index, const int &to);
    
    /**
     * @brief Restores the model if filtered, and clears all the filters set with the `filter` and `filters` properties.
     */
    void clearFilters();

Q_SIGNALS:
    void listChanged();
    void filterChanged(QString);
    void filtersChanged(QStringList);
    void sortOrderChanged(Qt::SortOrder);
    void sortChanged(QString);
    void filterRoleNameChanged(QString);
    void countChanged();
};

/**
 * @private
 */
class MauiModel::PrivateAbstractListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_DISABLE_COPY(PrivateAbstractListModel)
    
public:
    PrivateAbstractListModel(MauiModel *);
    int rowCount(const QModelIndex & = QModelIndex()) const override;

    QVariant data(const QModelIndex &, int = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &, const QVariant &, int = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex &) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    void setUpList();

    void reset();
private:
    MauiModel *m_model;
};
