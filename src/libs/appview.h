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
 * @brief The AppView class.
 * Represents the possible attachable properties to be use with the MauiKit AppViews control.
 * 
 * With this properties information can be attached to the AppViews children views, so the AppViews can - for example - place the view port buttons with the indicated icon and text title.
 * @see AppViews
 * @see AppViewLoader
 * 
 * @note This class is exposed as AppView to QML, and is meant to be used as n attached property in the AppViews children views.
 * 
 * @code
 * Item
 * {
 *  Maui.AppView.title: "View1"
 *  Maui.AppView.iconName: "folder"
 * }
 * @endcode
 */
class AppView : public QObject
{
    Q_OBJECT
    
    /**
     * The title of the view
     */
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    
    /**
     * The icon name to be used in the AppViews button port
     */
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)
    
    /**
     * The text to be used as a badge in the AppViews button port.
     * If this is left empty, then not badge will be shown.
     */
    Q_PROPERTY(QString badgeText READ badgeText WRITE setBadgeText NOTIFY badgeTextChanged)
    
public:
    /**
     * @private
     */
    static AppView *qmlAttachedProperties(QObject *object)
    {
        Q_UNUSED(object)
        return new AppView(object);
    }
    
    inline void setTitle(const QString &title)
    {
        if (title == m_title)
            return;

        m_title = title;
        Q_EMIT titleChanged();
    }

    inline void setIconName(const QString &iconName)
    {
        if (iconName == m_iconName)
            return;

        m_iconName = iconName;
        Q_EMIT iconNameChanged();
    }
    
    inline void setBadgeText(const QString &text)
    {
        if (text == m_badgeText)
            return;
        
        m_badgeText = text;
        Q_EMIT badgeTextChanged();
    }

    inline const QString title() const
    {
        return m_title;
    }

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
