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

#ifndef TABVIEW_H
#define TABVIEW_H
#include <QObject>
#include <QQmlEngine>

/**
 * @brief The TabViewInfo class
 * representsthe attached properties to handled the application main views following the Maui HIG
 */
class TabViewInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString tabTitle READ tabTitle WRITE setTabTitle NOTIFY tabTitleChanged)
    Q_PROPERTY(QString tabToolTipText READ tabToolTipText WRITE setTabToolTipText NOTIFY tabToolTipTextChanged)

public:
    static TabViewInfo *qmlAttachedProperties(QObject *object)
    {
        Q_UNUSED(object)

        return new TabViewInfo(object);
    }

    /**
     * @brief setTitle
     * @param title
     */
    inline void setTabTitle(const QString &value)
    {
        if (value == m_tabTitle)
            return;

        m_tabTitle = value;
        emit tabTitleChanged();
    }

    /**
     * @brief setTabToolTipText
     * @param iconName
     */
    inline void setTabToolTipText(const QString &value)
    {
        if (value == m_tabToolTipText)
            return;

        m_tabToolTipText = value;
        emit tabToolTipTextChanged();
    }

    /**
     * @brief title
     * @return
     */
    inline const QString tabTitle() const
    {
        return m_tabTitle;
    }

    /**
     * @brief iconName
     * @return
     */
    inline const QString tabToolTipText() const
    {
        return m_tabToolTipText;
    }

private:
    using QObject::QObject;

    QString m_tabTitle;
    QString m_tabToolTipText;

signals:
    void tabTitleChanged();
    void tabToolTipTextChanged();
};

QML_DECLARE_TYPEINFO(TabViewInfo, QML_HAS_ATTACHED_PROPERTIES)

#endif // TABVIEW_H
