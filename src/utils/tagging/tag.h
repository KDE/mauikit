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

#ifndef TAG_H
#define TAG_H

#include <QDebug>
#include <QDirIterator>
#include <QFileInfo>
#include <QImage>
#include <QSettings>
#include <QStandardPaths>
#include <QString>
#include <QTime>
#include <QVariantList>

#include "fmh.h"

namespace TAG
{
enum class TABLE : uint8_t { APP_TAGS, TAGS, TAGS_URLS, APPS, NONE };

static const QMap<TABLE, QString> TABLEMAP = {{TABLE::TAGS, "tags"},
                                              {TABLE::TAGS_URLS, "tags_urls"},
                                              {TABLE::APP_TAGS, "app_tags"},
                                              {TABLE::APPS, "apps"}};
                                              
static const QString TaggingPath = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + "/maui/tagging/";
static const QString DBName = "tagging-v2.db";
}

#endif // TAG_H
