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
 * @brief The MauiModel class
 * The MauiModel is a template model to use with a MauiList, it aims to be a generic and simple data model to quickly model string based models using the FMH::MODEL_LIST and FMH::MODEL_KEY types.
 * The idea is that the sorting and filtering is independent to the data list aka MauiList. Now to get the right items keep in mind: MauiList::get() gets the item at the original list index, while MauiModel::get() will get the item at the model, if it is filtered or sorted, then thats the item you get. If you want to get a item from the source list and the model has been filtered or sorted you will need to use the MauiModel::mappedToSource() to map the index to the right index from the source list. Now, if you have a index from the source list and the model has been filtered or ordered you will use MauiModel::mappedFromSource() to get the right index from the model.
 * This type is exposed to QML to quickly create a modle that can be filtered, sorted and has another usefull functionalities.
 */
class MAUIKIT_EXPORT MauiModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_DISABLE_COPY(MauiModel)
    
    Q_PROPERTY(MauiList *list READ getList WRITE setList NOTIFY listChanged)
    Q_PROPERTY(QString filter READ getFilter WRITE setFilter NOTIFY filterChanged)
    Q_PROPERTY(QStringList filters READ getFilters WRITE setFilters NOTIFY filtersChanged)
    Q_PROPERTY(QString filterRole READ getFilterRoleName WRITE setFilterRoleName NOTIFY filterRoleNameChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ getSortOrder WRITE setSortOrder NOTIFY sortOrderChanged)
    Q_PROPERTY(QString sort READ getSort WRITE setSort NOTIFY sortChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    MauiModel(QObject *parent = nullptr);

    /**
     * @brief getList
     * The list being handled by the model
     * @return
     */
    MauiList *getList() const;

    /**
     * @brief setList
     * For the model to work you need to set a MauiList, by subclassing it and exposing it to the QML engine
     * @param value
     */
    void setList(MauiList *);

    /**
     * @brief getSortOrder
     * The current sort order being applied
     * @return
     */
    Qt::SortOrder getSortOrder() const;

    /**
     * @brief getSort
     * The current sorting key
     * @return
     */
    QString getSort() const;

    /**
     * @brief getFilter
     * The filter being applied to the model
     * @return
     */
    const QString getFilter() const;
    /**
     * @brief getFilter
     * The filter being applied to the model
     * @return
     */
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
    /**
     * @brief setFilter
     * Filter the model using a simple string, to clear the filter just set it to a empty string
     * @param filter
     * Simple filter string
     */
    void setFilter(const QString &filter);
    void setFilters(const QStringList &filters);
    
    /**
     * @brief setSortOrder
     * Set the sort order, asc or dec
     * @param sortOrder
     */
    void setSortOrder(const Qt::SortOrder &sortOrder);

    /**
     * @brief setSort
     * Set the sort key. The sort keys can be found in the FMH::MODEL_KEY keys
     * @param sort
     */
    void setSort(const QString &sort);

    /**
     * @brief get
     * Returns an item in the model/list. This method correctly maps the given index in case the modle has been sorted or filtered
     * @param index
     * Index of the item in the list
     * @return
     */
    QVariantMap get(const int &index) const;

    /**
     * @brief getAll
     * Returns all the items in the list represented as a QVariantList to be able to be used in QML. This operation performs a transformation from FMH::MODEL_LIST to QVariantList
     * @return
     * All the items in the list
     */
    QVariantList getAll() const;

    /**
     * @brief mappedFromSource
     * Maps an index from the base list to the model, incase the modle has been filtered or sorted, this gives you the right mapped index
     * @param index
     * @return
     */
    int mappedFromSource(const int &index) const;

    /**
     * @brief mappedToSource
     * given an index from the filtered or sorted model it return the mapped index to the original list index
     * @param index
     * @return
     */
    int mappedToSource(const int &) const;
    void setFilterRoleName(QString );
    
    bool move(const int &index, const int &to);
    
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
