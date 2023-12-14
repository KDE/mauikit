/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QVariantList>

#include "fmh.h"

#include "abstractplatform.h"

/**
 * @brief The MAUIKDE class
 */
class MAUIKDE : public AbstractPlatform
{
    Q_OBJECT
QML_NAMED_ELEMENT(KDE)
    QML_SINGLETON
    QML_UNCREATABLE("Cannot be created Style")
    
public:
    static MAUIKDE *qmlAttachedProperties(QObject *object);
    static MAUIKDE *instance()
    {
        static MAUIKDE kde;
        return &kde;
    }

    MAUIKDE(const MAUIKDE &) = delete;
    MAUIKDE &operator=(const MAUIKDE &) = delete;
    MAUIKDE(MAUIKDE &&) = delete;
    MAUIKDE &operator=(MAUIKDE &&) = delete;
   
private:
    MAUIKDE(QObject *parent = nullptr);

public Q_SLOTS:
    /**
     * @brief setColorScheme
     * @param schemeName
     * @param bg
     * @param fg
     */
    static void setColorScheme(const QString &schemeName);
    
    void shareFiles(const QList<QUrl> &urls) override final;
    void shareText(const QString &text) override final;
    bool hasKeyboard() override final;
    bool hasMouse() override final;

    // AbstractPlatform interface
public Q_SLOTS:
    bool darkModeEnabled() override final;
};

