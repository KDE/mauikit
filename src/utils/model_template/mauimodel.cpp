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

#include "mauimodel.h"
#include "mauilist.h"
#include <QDebug>
#include <QDateTime>

MauiModel::MauiModel(QObject *parent)
    : QSortFilterProxyModel(parent)
    , m_model(new PrivateAbstractListModel(this))
{
   
}

QVariantMap MauiModel::get(const int &index) const
{
    QVariantMap res;
    if (index >= this->rowCount() || index < 0)
        return res;

    const auto roleNames = this->roleNames();
    for (const auto &role : roleNames)
        res.insert(role, this->index(index, 0).data(FMH::MODEL_NAME_KEY[role]).toString());

    return res;
}

QVariantList MauiModel::getAll() const
{
    QVariantList res;
    for (auto i = 0; i < this->rowCount(); i++)
        res << this->get(i);

    return res;
}

void MauiModel::setFilter(const QString &filter)
{
    if (this->m_filter == filter)
        return;

    this->m_filter = filter;
    emit this->filterChanged(this->m_filter);
    this->setFilterFixedString(this->m_filter);
}

const QString MauiModel::getFilter() const
{
    return this->m_filter;
}

QString MauiModel::getFilterRoleName() const
{
    return m_filter;
}

void MauiModel::setSortOrder(const Qt::SortOrder &sortOrder)
{
    if (this->m_sortOrder == sortOrder)
        return;

    this->m_sortOrder = sortOrder;
    emit this->sortOrderChanged(this->m_sortOrder);
    this->sort(0, this->m_sortOrder);
}

Qt::SortOrder MauiModel::getSortOrder() const
{
    return this->m_sortOrder;
}

void MauiModel::setSort(const QString &sort)
{
    if (this->m_sort == sort)
        return;

    this->m_sort = sort;
    emit this->sortChanged(this->m_sort);
    this->setSortRole(FMH::MODEL_NAME_KEY[sort]);
    this->sort(0, this->m_sortOrder);
}

QString MauiModel::getSort() const
{
    return this->m_sort;
}

int MauiModel::count() const
{
    return this->rowCount();
}

int MauiModel::mappedFromSource(const int &index) const
{
    return this->mapFromSource(this->m_model->index(index, 0)).row();
}

int MauiModel::mappedToSource(const int &index) const
{
    return this->mapToSource(this->index(index, 0)).row();
}

void MauiModel::setFilterRoleName(QString filter)
{
    if (m_filterRoleName == filter)
        return;

    m_filterRoleName = filter;
    emit filterRoleNameChanged(m_filterRoleName);
    this->setFilterRole(FMH::MODEL_NAME_KEY[m_filterRoleName]);
}

bool MauiModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (this->filterRole() != Qt::DisplayRole) {
        QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
        const auto data = this->sourceModel()->data(index, this->filterRole()).toString();
        return data.contains(this->filterRegExp());
    }

    const auto roleNames = this->sourceModel()->roleNames();
    for (const auto &role : roleNames) {
        QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
        const auto data = this->sourceModel()->data(index, FMH::MODEL_NAME_KEY[role]).toString();
        if (data.contains(this->filterRegExp()))
            return true;
        else
            continue;
    }

    return false;
}

MauiList *MauiModel::getList() const
{
    return this->m_list;
}

void MauiModel::PrivateAbstractListModel::setUpList()
{
    beginResetModel();

    if (m_model->getList())
        m_model->getList()->disconnect(this);

    if (m_model->getList()) {
        connect(
            m_model->getList(),
            &MauiList::preItemAppendedAt,
            this,
            [this](int index) {
                beginInsertRows(QModelIndex(), index, index);
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::preItemAppended,
            this,
            [this]() {
                const int index = m_model->getList()->getCount();
                beginInsertRows(QModelIndex(), index, index);
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::preItemsAppended,
            this,
            [this](uint count) {
                const int index = m_model->getList()->getCount();
                beginInsertRows(QModelIndex(), index, index + count - 1);
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::postItemAppended,
            this,
            [this]() {
                endInsertRows();
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::preItemRemoved,
            this,
            [this](int index) {
                beginRemoveRows(QModelIndex(), index, index);
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::postItemRemoved,
            this,
            [this]() {
                endRemoveRows();
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::updateModel,
            this,
            [this](int index, QVector<int> roles) {
                emit this->dataChanged(this->m_model->index(index, 0), this->m_model->index(index, 0), roles);
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::preListChanged,
            this,
            [this]() {
                beginResetModel();
            },
            Qt::DirectConnection);

        connect(
            m_model->getList(),
            &MauiList::postListChanged,
            this,
            [this]() {
                endResetModel();
            },
            Qt::DirectConnection);
    }

    endResetModel();
}

void MauiModel::setList(MauiList *value)
{
    if(value && value != this->m_list)
    {
        value->modelHooked();
        this->m_list = value;
        this->m_model->setUpList();
        emit this->listChanged();
        
        this->setSourceModel(this->m_model);
        this->setDynamicSortFilter(true);
    }
}

MauiModel::PrivateAbstractListModel::PrivateAbstractListModel(MauiModel *model)
    : QAbstractListModel(model)
    , m_model(model)
{
    connect(
        this,
        &QAbstractListModel::rowsInserted,
        this,
        [this](QModelIndex, int, int) {
            if (m_model->getList()) {
                emit this->m_model->countChanged();
            }
        },
        Qt::DirectConnection);

    connect(
        this,
        &QAbstractListModel::rowsRemoved,
        this,
        [this](QModelIndex, int, int) {
            if (m_model->getList()) {
                emit this->m_model->countChanged();
            }
        },
        Qt::DirectConnection);
}

int MauiModel::PrivateAbstractListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid() || !m_model->getList())
    {        
        return 0;
    }    
        
    return m_model->getList()->getCount();
}
    

QVariant MauiModel::PrivateAbstractListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !m_model->getList())
        return QVariant();

    auto value = m_model->getList()->getItem(index.row()).value(static_cast<FMH::MODEL_KEY>(role));

    if (role == FMH::MODEL_KEY::ADDDATE || role == FMH::MODEL_KEY::DATE || role == FMH::MODEL_KEY::MODIFIED || role == FMH::MODEL_KEY::RELEASEDATE) {
        const auto date = QDateTime::fromString(value, Qt::TextDate);
        if (date.isValid())
            return date;
    }

    return value;
}

bool MauiModel::PrivateAbstractListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Q_UNUSED(index);
    Q_UNUSED(value);
    Q_UNUSED(role);

    return false;
}

Qt::ItemFlags MauiModel::PrivateAbstractListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable; // FIXME: Implement me!
}

QHash<int, QByteArray> MauiModel::PrivateAbstractListModel::roleNames() const
{
    QHash<int, QByteArray> names;
    const auto keys = FMH::MODEL_NAME.keys();

    for (const auto &key : keys)
    {
        names[key] = QString(FMH::MODEL_NAME[key]).toUtf8();
    }

    return names;
}
