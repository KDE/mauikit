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

#include "tagging.h"
#include "utils.h"
#include <QCoreApplication>
#include <QMimeDatabase>
#include <QNetworkInterface>

Tagging::Tagging()
    : TAGDB()
{
    this->setApp();
}

const QVariantList Tagging::get(const QString &queryTxt, std::function<bool(QVariantMap &item)> modifier)
{
    QVariantList mapList;

    auto query = this->getQuery(queryTxt);

    if (query.exec()) {
        while (query.next()) {
            QVariantMap data;
            for (const auto &key : FMH::MODEL_NAME.keys()) {
                
                if (query.record().indexOf(FMH::MODEL_NAME[key]) > -1) {
                    data[FMH::MODEL_NAME[key]] = query.value(FMH::MODEL_NAME[key]).toString();
                }
            }

            if (modifier) {
                if (!modifier(data))
                    continue;
            }
            mapList << data;
        }

    } else
    {
        qDebug() << query.lastError() << query.lastQuery();
    }

    return mapList;
}

bool Tagging::tagExists(const QString &tag, const bool &strict)
{
    return !strict ? this->checkExistance(TAG::TABLEMAP[TAG::TABLE::TAGS], FMH::MODEL_NAME[FMH::MODEL_KEY::TAG], tag)
                   : this->checkExistance(QString("select t.tag from APP_TAGS where t.org = '%1' and t.tag = '%2'")
                                              .arg(this->appOrg, tag));
}

bool Tagging::urlTagExists(const QString &url, const QString &tag)
{
  return this->checkExistance(QString("select * from TAGS_URLS where url = '%1' and tag = '%2'").arg(url, tag));
}

void Tagging::setApp()
{
    this->appName = qApp->applicationName();
    this->appComment = QString();
    this->appOrg = qApp->organizationDomain().isEmpty() ? QString("org.maui.%1").arg(this->appName) : qApp->organizationDomain();
    this->app(); // here register the app
}

bool Tagging::tag(const QString &tag, const QString &color, const QString &comment)
{
    if (tag.isEmpty())
        return false;
    
    if(tag.contains(" ") || tag.contains("\n"))
    {
        return false;
    }
    
    QVariantMap tag_map {
        {FMH::MODEL_NAME[FMH::MODEL_KEY::TAG], tag},
        {FMH::MODEL_NAME[FMH::MODEL_KEY::COLOR], color},
        {FMH::MODEL_NAME[FMH::MODEL_KEY::ADDDATE], QDateTime::currentDateTime().toString(Qt::TextDate)},
        {FMH::MODEL_NAME[FMH::MODEL_KEY::COMMENT], comment},
    };
    
    this->insert(TAG::TABLEMAP[TAG::TABLE::TAGS], tag_map);
    
    const QVariantMap appTag_map {
        {FMH::MODEL_NAME[FMH::MODEL_KEY::TAG], tag}, 
        {FMH::MODEL_NAME[FMH::MODEL_KEY::ORG], this->appOrg}, 
        {FMH::MODEL_NAME[FMH::MODEL_KEY::ADDDATE], QDateTime::currentDateTime().toString(Qt::TextDate)}};
        
        if (this->insert(TAG::TABLEMAP[TAG::TABLE::APP_TAGS], appTag_map)) {
            setTagIconName(tag_map);
            emit this->tagged(tag_map);
            return true;
        }
        
        return false;
}

bool Tagging::tagUrl(const QString &url, const QString &tag, const QString &color, const QString &comment)
{
    const auto myTag = tag.trimmed();

    this->tag(myTag, color, comment);

    QMimeDatabase mimedb;

    QVariantMap tag_url_map {{FMH::MODEL_NAME[FMH::MODEL_KEY::URL], url},
                             {FMH::MODEL_NAME[FMH::MODEL_KEY::TAG], myTag},
                             {FMH::MODEL_NAME[FMH::MODEL_KEY::TITLE], QFileInfo(url).baseName()},
                             {FMH::MODEL_NAME[FMH::MODEL_KEY::MIME], mimedb.mimeTypeForFile(url).name()},
                             {FMH::MODEL_NAME[FMH::MODEL_KEY::ADDDATE], QDateTime::currentDateTime()},
                             {FMH::MODEL_NAME[FMH::MODEL_KEY::COMMENT], comment}};

    if(this->insert(TAG::TABLEMAP[TAG::TABLE::TAGS_URLS], tag_url_map))
    {
        qDebug() << "tagging url" << url <<tag;
        emit this->urlTagged(url, myTag);
        return true;
    }
    
    return false;
}

bool Tagging::updateUrlTags(const QString &url, const QStringList &tags, const bool &strict)
{
    this->removeUrlTags(url, strict);    
   
    for (const auto &tag : qAsConst(tags))
    {
        this->tagUrl(url, tag);
    }

    return true;
}

bool Tagging::updateUrl(const QString &url, const QString &newUrl)
{
    return this->update(TAG::TABLEMAP[TAG::TABLE::TAGS_URLS], {{FMH::MODEL_KEY::URL, newUrl}}, {{FMH::MODEL_NAME[FMH::MODEL_KEY::URL], url}});
}

QVariantList Tagging::getUrlsTags(const bool &strict) //all used tags, meaning, all tags that are used with an url in tags_url table
{
    const auto query = !strict ? QString("select distinct t.* from TAGS t inner join TAGS_URLS turl where t.tag = turl.tag") :
    QString("select distinct t.* from TAGS t inner join APP_TAGS at on at.tag = t.tag inner join TAGS_URLS turl on t.tag = turl.tag where at.org = '%1'").arg(this->appOrg);    

    return this->get(query, &setTagIconName);
}

bool Tagging::setTagIconName(QVariantMap &item)
{
    item.insert("icon", item.value("tag").toString() == "fav" ? "love" : "tag");
    return true;
}

QVariantList Tagging::getAllTags(const bool &strict)
{
    return !strict ? this->get("select * from tags", &setTagIconName)
                   : this->get(QString("select t.* from TAGS t inner join APP_TAGS at on t.tag = at.tag where at.org = '%1'").arg(this->appOrg),
                               &setTagIconName);
}

QVariantList Tagging::getUrls(const QString &tag, const bool &strict, const int &limit, const QString &mimeType, std::function<bool(QVariantMap &item)> modifier)
{
    return !strict ? this->get(QString("select distinct * from TAGS_URLS where tag = '%1' and mime like '%2%' limit %3").arg(tag, mimeType, QString::number(limit)), modifier)
                   : this->get(QString("select distinct turl.*, t.color, t.comment as tagComment from TAGS t "
                                       "inner join APP_TAGS at on t.tag = at.tag "
                                       "inner join TAGS_URLS turl on turl.tag = t.tag "
                                       "where at.org = '%1' and turl.mime like '%4%' "
                                       "and t.tag = '%2' limit %3")
                                   .arg(this->appOrg, tag, QString::number(limit), mimeType),
                               modifier);
}

QVariantList Tagging::getUrlTags(const QString &url, const bool &strict)
{
    return !strict ? this->get(QString("select distinct turl.*, t.color, t.comment as tagComment from tags t inner join TAGS_URLS turl on turl.tag = t.tag where turl.url  = '%1'").arg(url))
                   : this->get(QString("select distinct t.* from TAGS t inner join APP_TAGS at on t.tag = at.tag inner join TAGS_URLS turl on turl.tag = t.tag "
                                       "where at.org = '%1' and turl.url = '%2'")
                                   .arg(this->appOrg, url));
}

bool Tagging::removeUrlTags(const QString &url, const bool &strict) // same as removing the url from the tags_urls
{
    Q_UNUSED(strict)
    return this->removeUrl(url);
}

bool Tagging::removeUrlTag(const QString &url, const QString &tag)
{
    qDebug() << "Remove url tag" << url << tag;
    FMH::MODEL data {{FMH::MODEL_KEY::URL, url}, {FMH::MODEL_KEY::TAG, tag}};
    return this->remove(TAG::TABLEMAP[TAG::TABLE::TAGS_URLS], data);
}

bool Tagging::removeUrl(const QString &url)
{
    return this->remove(TAG::TABLEMAP[TAG::TABLE::TAGS_URLS], {{FMH::MODEL_KEY::URL, url}});
}

bool Tagging::app()
{
    qDebug() << "REGISTER APP" << this->appName << this->appOrg << this->appComment;
    const QVariantMap app_map {
        {FMH::MODEL_NAME[FMH::MODEL_KEY::NAME], this->appName},
        {FMH::MODEL_NAME[FMH::MODEL_KEY::ORG], this->appOrg},
        {FMH::MODEL_NAME[FMH::MODEL_KEY::ADDDATE], QDateTime::currentDateTime()},
        {FMH::MODEL_NAME[FMH::MODEL_KEY::COMMENT], this->appComment},
    };

   return this->insert(TAG::TABLEMAP[TAG::TABLE::APPS], app_map);
}


