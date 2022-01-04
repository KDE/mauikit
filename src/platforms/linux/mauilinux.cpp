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

#include "mauilinux.h"

#include <QDebug>

MAUIKDE *MAUIKDE::qmlAttachedProperties(QObject *object)
{
    Q_UNUSED(object)
    return MAUIKDE::instance();
}

MAUIKDE::MAUIKDE(QObject *parent)
    : AbstractPlatform(parent)
{
}


void MAUIKDE::setColorScheme(const QString &schemeName)
{
   Q_UNUSED(schemeName)
}

bool MAUIKDE::hasKeyboard()
{
    return true;
}

bool MAUIKDE::hasMouse()
{
    return true;
}

void MAUIKDE::shareFiles(const QList<QUrl> &urls)
{
    emit this->shareFilesRequest(QUrl::toStringList(urls));
}

void MAUIKDE::shareText(const QString &)
{
}


bool MAUIKDE::darkModeEnabled()
{
    return false;
}
