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
 * @brief The TabViewInfo class.
 * Groups the attached properties used for setting the data information for the TabView children views.
 * @see TabView
 * @see TabViewItem
 * 
 * @code
 * Item
 * {
 *  Maui.TabVieInfo.tabTitle: "Tab1"
 *  Maui.TabViewInfo.tabIcon: "folder"
 * }
 * @endcode
 */
class TabViewInfo : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ATTACHED(AppView)
    QML_UNCREATABLE("Cannot be created Controls")
    /**
     * The title for the tab view. Used in the tab button.
     */
    Q_PROPERTY(QString tabTitle READ tabTitle WRITE setTabTitle NOTIFY tabTitleChanged)
    
    /**
     * The text to be shown in the tool-tip when hovering over the tab button representing the view.
     */
    Q_PROPERTY(QString tabToolTipText READ tabToolTipText WRITE setTabToolTipText NOTIFY tabToolTipTextChanged)
    
    /**
     * The color to be used as an indicator in the tab button representing the view.
     */
    Q_PROPERTY(QString tabColor READ tabColor WRITE setTabColor NOTIFY tabColorChanged)
    
    /**
     * The icon to be used in the tab button representing the view.
     */
    Q_PROPERTY(QString tabIcon READ tabIcon WRITE setTabIcon NOTIFY tabIconChanged)
        
public:
    static TabViewInfo *qmlAttachedProperties(QObject *object)
    {
        Q_UNUSED(object)
        
        return new TabViewInfo(object);
    }
    
    inline void setTabTitle(const QString &value)
    {
        if (value == m_tabTitle)
            return;
        
        m_tabTitle = value;
        Q_EMIT tabTitleChanged();
    }
    
    inline void setTabToolTipText(const QString &value)
    {
        if (value == m_tabToolTipText)
            return;
        
        m_tabToolTipText = value;
        Q_EMIT tabToolTipTextChanged();
    }
    
    inline void setTabColor(const QString &value)
    {
        if (value == m_tabColor)
            return;
        
        m_tabColor = value;
        Q_EMIT tabColorChanged();
    }    
    
    inline void setTabIcon(const QString &value)
    {
        if (value == m_tabIcon)
            return;
        
        m_tabIcon = value;
        Q_EMIT tabIconChanged();
    }
    
    inline const QString tabTitle() const
    {
        return m_tabTitle;
    }
    
    inline const QString tabToolTipText() const
    {
        return m_tabToolTipText;
    }
    
    inline const QString tabColor() const
    {
        return m_tabColor;
    }
    
    inline const QString tabIcon() const
    {
        return m_tabIcon;
    }
    
private:
    using QObject::QObject;
    
    QString m_tabTitle;
    QString m_tabToolTipText;
    QString m_tabIcon;
    QString m_tabColor;
    
Q_SIGNALS:
    void tabTitleChanged();
    void tabToolTipTextChanged();
    void tabColorChanged();
    void tabIconChanged();
};

QML_DECLARE_TYPEINFO(TabViewInfo, QML_HAS_ATTACHED_PROPERTIES)

