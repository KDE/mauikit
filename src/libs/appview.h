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
#include <QObject>
#include <QQmlEngine>

/**
 * @brief The AppView class
 * representsthe attached properties to handled the application main views following the Maui HIG
 */
class AppView : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)
    Q_PROPERTY(QString badgeText READ badgeText WRITE setBadgeText NOTIFY badgeTextChanged)
    
public:
    static AppView *qmlAttachedProperties(QObject *object)
    {
        Q_UNUSED(object)

        return new AppView(object);
    }

    /**
     * @brief setTitle
     * @param title
     */
    inline void setTitle(const QString &title)
    {
        if (title == m_title)
            return;

        m_title = title;
        Q_EMIT titleChanged();
    }

    /**
     * @brief setIconName
     * @param iconName
     */
    inline void setIconName(const QString &iconName)
    {
        if (iconName == m_iconName)
            return;

        m_iconName = iconName;
        Q_EMIT iconNameChanged();
    }
    
    /**
     * @brief setIconName
     * @param iconName
     */
    inline void setBadgeText(const QString &text)
    {
        if (text == m_badgeText)
            return;
        
        m_badgeText = text;
        Q_EMIT badgeTextChanged();
    }

    /**
     * @brief title
     * @return
     */
    inline const QString title() const
    {
        return m_title;
    }

    /**
     * @brief iconName
     * @return
     */
    inline const QString iconName() const
    {
        return m_iconName;
    }
    
    inline const QString badgeText() const
    {
        return m_badgeText;
    }
    

private:
    using QObject::QObject;

    QString m_title;
    QString m_iconName;
    QString m_badgeText;

Q_SIGNALS:
    void titleChanged();
    void iconNameChanged();
    void badgeTextChanged();
};

QML_DECLARE_TYPEINFO(AppView, QML_HAS_ATTACHED_PROPERTIES)
