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

#ifndef FMH_H
#define FMH_H

#include <QHash>
#include <QVariant>
#include <QString>
#include <QUrl>
#include <QVector>

#include "mauikit_export.h"

/**
 * A set of helpers related to file management and modeling of data
 */
namespace FMH
{
/**
 * @brief isAndroid
 * @return
 */
bool MAUIKIT_EXPORT isAndroid();

/**
 * @brief isWindows
 * @return
 */
bool MAUIKIT_EXPORT isWindows();

/**
 * @brief isLinux
 * @return
 */
bool MAUIKIT_EXPORT isLinux();

/**
 * @brief isMac
 * @return
 */
bool MAUIKIT_EXPORT isMac();

/**
 * @brief isIOS
 * @return
 */
bool MAUIKIT_EXPORT isIOS();

/**
 * @brief The MODEL_KEY enum
 */
enum MODEL_KEY : int {
    ICON,
    LABEL,
    PATH,
    URL,
    TYPE,
    GROUP,
    OWNER,
    SUFFIX,
    NAME,
    DATE,
    SIZE,
    MODIFIED,
    MIME,
    TAG,
    PERMISSIONS,
    THUMBNAIL,
    THUMBNAIL_1,
    THUMBNAIL_2,
    THUMBNAIL_3,
    HIDDEN,
    ICONSIZE,
    DETAILVIEW,
    SHOWTHUMBNAIL,
    SHOWTERMINAL,
    COUNT,
    SORTBY,
    USER,
    PASSWORD,
    SERVER,
    FOLDERSFIRST,
    VIEWTYPE,
    ADDDATE,
    FAV,
    FAVORITE,
    COLOR,
    RATE,
    FORMAT,
    PLACE,
    LOCATION,
    ALBUM,
    ARTIST,
    TRACK,
    DURATION,
    ARTWORK,
    PLAYLIST,
    LYRICS,
    WIKI,
    MOOD,
    SOURCETYPE,
    GENRE,
    NOTE,
    COMMENT,
    CONTEXT,
    SOURCE,
    TITLE,
    ID,
    PARENT_ID,
    RELEASEDATE,
    LICENSE,
    DESCRIPTION,
    BOOKMARK,
    ACCOUNT,
    ACCOUNTTYPE,
    VERSION,
    DOMAIN_M,
    CATEGORY,
    CONTENT,
    PIN,
    IMG,
    PREVIEW,
    LINK,
    STAMP,
    BOOK,
    N,
    PHOTO,
    GENDER,
    ADR,
    ADR_2,
    ADR_3,
    EMAIL,
    EMAIL_2,
    EMAIL_3,
    LANG,
    NICKNAME,
    ORG,
    PROFILE,
    TZ,
    TEL,
    TEL_2,
    TEL_3,
    IM,
    CITY,
    STATE,
    COUNTRY,
    PACKAGE_ARCH,
    PACKAGE_TYPE,
    GPG_FINGERPRINT,
    GPG_SIGNATURE,
    PACKAGE_NAME,
    PRICE,
    REPOSITORY,
    TAGS,
    WAY,
    PIC,
    SMALL_PIC,
    CHANGED,
    COMMENTS,
    CREATED,
    DETAIL_PAGE,
    DETAILS,
    TOTAL_DOWNLOADS,
    GHNS_EXCLUDED,
    LANGUAGE,
    PERSON_ID,
    SCORE,
    SUMMARY,
    TYPE_ID,
    TYPE_NAME,
    XDG_TYPE,
    SYMLINK,
    IS_SYMLINK,
    IS_DIR,
    IS_FILE,
    IS_REMOTE,
    EXECUTABLE,
    READABLE,
    WRITABLE,
    LAST_READ,
    VALUE,
    KEY,
    MAC,
    LOT,
    APP,
    URI,
    DEVICE,
    LASTSYNC,
    UDI
};

static const QHash<MODEL_KEY, QString> MODEL_NAME = {{MODEL_KEY::ICON, "icon"},
                                                     {MODEL_KEY::LABEL, "label"},
                                                     {MODEL_KEY::PATH, "path"},
                                                     {MODEL_KEY::URL, "url"},
                                                     {MODEL_KEY::TYPE, "type"},
                                                     {MODEL_KEY::GROUP, "group"},
                                                     {MODEL_KEY::OWNER, "owner"},
                                                     {MODEL_KEY::SUFFIX, "suffix"},
                                                     {MODEL_KEY::NAME, "name"},
                                                     {MODEL_KEY::DATE, "date"},
                                                     {MODEL_KEY::MODIFIED, "modified"},
                                                     {MODEL_KEY::MIME, "mime"},
                                                     {MODEL_KEY::SIZE, "size"},
                                                     {MODEL_KEY::TAG, "tag"},
                                                     {MODEL_KEY::PERMISSIONS, "permissions"},
                                                     {MODEL_KEY::THUMBNAIL, "thumbnail"},
                                                     {MODEL_KEY::THUMBNAIL_1, "thumbnail_1"},
                                                     {MODEL_KEY::THUMBNAIL_2, "thumbnail_2"},
                                                     {MODEL_KEY::THUMBNAIL_3, "thumbnail_3"},
                                                     {MODEL_KEY::ICONSIZE, "iconsize"},
                                                     {MODEL_KEY::HIDDEN, "hidden"},
                                                     {MODEL_KEY::DETAILVIEW, "detailview"},
                                                     {MODEL_KEY::SHOWTERMINAL, "showterminal"},
                                                     {MODEL_KEY::SHOWTHUMBNAIL, "showthumbnail"},
                                                     {MODEL_KEY::COUNT, "count"},
                                                     {MODEL_KEY::SORTBY, "sortby"},
                                                     {MODEL_KEY::USER, "user"},
                                                     {MODEL_KEY::PASSWORD, "password"},
                                                     {MODEL_KEY::SERVER, "server"},
                                                     {MODEL_KEY::FOLDERSFIRST, "foldersfirst"},
                                                     {MODEL_KEY::VIEWTYPE, "viewtype"},
                                                     {MODEL_KEY::ADDDATE, "adddate"},
                                                     {MODEL_KEY::FAV, "fav"},
                                                     {MODEL_KEY::FAVORITE, "favorite"},
                                                     {MODEL_KEY::COLOR, "color"},
                                                     {MODEL_KEY::RATE, "rate"},
                                                     {MODEL_KEY::FORMAT, "format"},
                                                     {MODEL_KEY::PLACE, "place"},
                                                     {MODEL_KEY::LOCATION, "location"},
                                                     {MODEL_KEY::ALBUM, "album"},
                                                     {MODEL_KEY::DURATION, "duration"},
                                                     {MODEL_KEY::RELEASEDATE, "releasedate"},
                                                     {MODEL_KEY::ARTIST, "artist"},
                                                     {MODEL_KEY::LYRICS, "lyrics"},
                                                     {MODEL_KEY::TRACK, "track"},
                                                     {MODEL_KEY::GENRE, "genre"},
                                                     {MODEL_KEY::WIKI, "wiki"},
                                                     {MODEL_KEY::CONTEXT, "context"},
                                                     {MODEL_KEY::SOURCETYPE, "sourcetype"},
                                                     {MODEL_KEY::ARTWORK, "artwork"},
                                                     {MODEL_KEY::NOTE, "note"},
                                                     {MODEL_KEY::MOOD, "mood"},
                                                     {MODEL_KEY::COMMENT, "comment"},
                                                     {MODEL_KEY::PLAYLIST, "playlist"},
                                                     {MODEL_KEY::SOURCE, "source"},
                                                     {MODEL_KEY::TITLE, "title"},
                                                     {MODEL_KEY::ID, "id"},
                                                     {MODEL_KEY::PERSON_ID, "personid"},
                                                     {MODEL_KEY::PARENT_ID, "parentid"},
                                                     {MODEL_KEY::LICENSE, "license"},
                                                     {MODEL_KEY::DESCRIPTION, "description"},
                                                     {MODEL_KEY::BOOKMARK, "bookmark"},
                                                     {MODEL_KEY::ACCOUNT, "account"},
                                                     {MODEL_KEY::ACCOUNTTYPE, "accounttype"},
                                                     {MODEL_KEY::VERSION, "version"},
                                                     {MODEL_KEY::DOMAIN_M, "domain"},
                                                     {MODEL_KEY::CATEGORY, "category"},
                                                     {MODEL_KEY::CONTENT, "content"},
                                                     {MODEL_KEY::PIN, "pin"},
                                                     {MODEL_KEY::IMG, "img"},
                                                     {MODEL_KEY::PREVIEW, "preview"},
                                                     {MODEL_KEY::LINK, "link"},
                                                     {MODEL_KEY::STAMP, "stamp"},
                                                     {MODEL_KEY::BOOK, "book"},

                                                     /** ccdav keys **/
                                                     {MODEL_KEY::N, "n"},
                                                     {MODEL_KEY::IM, "im"},
                                                     {MODEL_KEY::PHOTO, "photo"},
                                                     {MODEL_KEY::GENDER, "gender"},
                                                     {MODEL_KEY::ADR, "adr"},
                                                     {MODEL_KEY::ADR_2, "adr2"},
                                                     {MODEL_KEY::ADR_3, "adr3"},
                                                     {MODEL_KEY::EMAIL, "email"},
                                                     {MODEL_KEY::EMAIL_2, "email2"},
                                                     {MODEL_KEY::EMAIL_3, "email3"},
                                                     {MODEL_KEY::LANG, "lang"},
                                                     {MODEL_KEY::NICKNAME, "nickname"},
                                                     {MODEL_KEY::ORG, "org"},
                                                     {MODEL_KEY::PROFILE, "profile"},
                                                     {MODEL_KEY::TZ, "tz"},
                                                     {MODEL_KEY::TEL, "tel"},
                                                     {MODEL_KEY::TEL_2, "tel2"},
                                                     {MODEL_KEY::TEL_3, "tel3"},

                                                     {MODEL_KEY::CITY, "city"},
                                                     {MODEL_KEY::STATE, "state"},
                                                     {MODEL_KEY::COUNTRY, "country"},

                                                     // opendesktop keys
                                                     {MODEL_KEY::PACKAGE_ARCH, "packagearch"},
                                                     {MODEL_KEY::PACKAGE_TYPE, "packagetype"},
                                                     {MODEL_KEY::GPG_FINGERPRINT, "gpgfingerprint"},
                                                     {MODEL_KEY::GPG_SIGNATURE, "gpgsignature"},
                                                     {MODEL_KEY::PACKAGE_NAME, "packagename"},
                                                     {MODEL_KEY::PRICE, "price"},
                                                     {MODEL_KEY::REPOSITORY, "repository"},
                                                     {MODEL_KEY::TAGS, "tags"},
                                                     {MODEL_KEY::WAY, "way"},
                                                     {MODEL_KEY::PIC, "pic"},
                                                     {MODEL_KEY::SMALL_PIC, "smallpic"},
                                                     {MODEL_KEY::CHANGED, "changed"},
                                                     {MODEL_KEY::COMMENTS, "comments"},
                                                     {MODEL_KEY::CREATED, "created"},
                                                     {MODEL_KEY::DETAIL_PAGE, "detailpage"},
                                                     {MODEL_KEY::DETAILS, "details"},
                                                     {MODEL_KEY::TOTAL_DOWNLOADS, "totaldownloads"},
                                                     {MODEL_KEY::GHNS_EXCLUDED, "ghnsexcluded"},
                                                     {MODEL_KEY::LANGUAGE, "language"},
                                                     {MODEL_KEY::SCORE, "score"},
                                                     {MODEL_KEY::SUMMARY, "summary"},
                                                     {MODEL_KEY::TYPE_ID, "typeid"},
                                                     {MODEL_KEY::TYPE_NAME, "typename"},
                                                     {MODEL_KEY::XDG_TYPE, "xdgtype"},

                                                     // file props
                                                     {MODEL_KEY::SYMLINK, "symlink"},
                                                     {MODEL_KEY::IS_SYMLINK, "issymlink"},
                                                     {MODEL_KEY::LAST_READ, "lastread"},
                                                     {MODEL_KEY::READABLE, "readable"},
                                                     {MODEL_KEY::WRITABLE, "writeable"},
                                                     {MODEL_KEY::IS_DIR, "isdir"},
                                                     {MODEL_KEY::IS_FILE, "isfile"},
                                                     {MODEL_KEY::IS_REMOTE, "isremote"},
                                                     {MODEL_KEY::EXECUTABLE, "executable"},
                                                     {MODEL_KEY::VALUE, "value"},
                                                     {MODEL_KEY::KEY, "key"},

                                                     {MODEL_KEY::MAC, "mac"},
                                                     {MODEL_KEY::LOT, "lot"},
                                                     {MODEL_KEY::APP, "app"},
                                                     {MODEL_KEY::URI, "uri"},
                                                     {MODEL_KEY::DEVICE, "device"},
                                                     {MODEL_KEY::UDI, "udi"},
                                                     {MODEL_KEY::LASTSYNC, "lastsync"}};

static const QHash<QString, MODEL_KEY> MODEL_NAME_KEY = {{MODEL_NAME[MODEL_KEY::ICON], MODEL_KEY::ICON},
                                                         {MODEL_NAME[MODEL_KEY::LABEL], MODEL_KEY::LABEL},
                                                         {MODEL_NAME[MODEL_KEY::PATH], MODEL_KEY::PATH},
                                                         {MODEL_NAME[MODEL_KEY::URL], MODEL_KEY::URL},
                                                         {MODEL_NAME[MODEL_KEY::TYPE], MODEL_KEY::TYPE},
                                                         {MODEL_NAME[MODEL_KEY::GROUP], MODEL_KEY::GROUP},
                                                         {MODEL_NAME[MODEL_KEY::OWNER], MODEL_KEY::OWNER},
                                                         {MODEL_NAME[MODEL_KEY::SUFFIX], MODEL_KEY::SUFFIX},
                                                         {MODEL_NAME[MODEL_KEY::NAME], MODEL_KEY::NAME},
                                                         {MODEL_NAME[MODEL_KEY::DATE], MODEL_KEY::DATE},
                                                         {MODEL_NAME[MODEL_KEY::MODIFIED], MODEL_KEY::MODIFIED},
                                                         {MODEL_NAME[MODEL_KEY::MIME], MODEL_KEY::MIME},
                                                         {
                                                             MODEL_NAME[MODEL_KEY::SIZE],
                                                             MODEL_KEY::SIZE,
                                                         },
                                                         {MODEL_NAME[MODEL_KEY::TAG], MODEL_KEY::TAG},
                                                         {MODEL_NAME[MODEL_KEY::PERMISSIONS], MODEL_KEY::PERMISSIONS},
                                                         {MODEL_NAME[MODEL_KEY::THUMBNAIL], MODEL_KEY::THUMBNAIL},
                                                         {MODEL_NAME[MODEL_KEY::THUMBNAIL_1], MODEL_KEY::THUMBNAIL_1},
                                                         {MODEL_NAME[MODEL_KEY::THUMBNAIL_2], MODEL_KEY::THUMBNAIL_2},
                                                         {MODEL_NAME[MODEL_KEY::THUMBNAIL_3], MODEL_KEY::THUMBNAIL_3},
                                                         {MODEL_NAME[MODEL_KEY::ICONSIZE], MODEL_KEY::ICONSIZE},
                                                         {MODEL_NAME[MODEL_KEY::HIDDEN], MODEL_KEY::HIDDEN},
                                                         {MODEL_NAME[MODEL_KEY::DETAILVIEW], MODEL_KEY::DETAILVIEW},
                                                         {MODEL_NAME[MODEL_KEY::SHOWTERMINAL], MODEL_KEY::SHOWTERMINAL},
                                                         {MODEL_NAME[MODEL_KEY::SHOWTHUMBNAIL], MODEL_KEY::SHOWTHUMBNAIL},
                                                         {MODEL_NAME[MODEL_KEY::COUNT], MODEL_KEY::COUNT},
                                                         {MODEL_NAME[MODEL_KEY::SORTBY], MODEL_KEY::SORTBY},
                                                         {MODEL_NAME[MODEL_KEY::USER], MODEL_KEY::USER},
                                                         {MODEL_NAME[MODEL_KEY::PASSWORD], MODEL_KEY::PASSWORD},
                                                         {MODEL_NAME[MODEL_KEY::SERVER], MODEL_KEY::SERVER},
                                                         {MODEL_NAME[MODEL_KEY::VIEWTYPE], MODEL_KEY::VIEWTYPE},
                                                         {MODEL_NAME[MODEL_KEY::ADDDATE], MODEL_KEY::ADDDATE},
                                                         {MODEL_NAME[MODEL_KEY::FAV], MODEL_KEY::FAV},
                                                         {MODEL_NAME[MODEL_KEY::FAVORITE], MODEL_KEY::FAVORITE},
                                                         {MODEL_NAME[MODEL_KEY::COLOR], MODEL_KEY::COLOR},
                                                         {MODEL_NAME[MODEL_KEY::RATE], MODEL_KEY::RATE},
                                                         {MODEL_NAME[MODEL_KEY::FORMAT], MODEL_KEY::FORMAT},
                                                         {MODEL_NAME[MODEL_KEY::PLACE], MODEL_KEY::PLACE},
                                                         {MODEL_NAME[MODEL_KEY::LOCATION], MODEL_KEY::LOCATION},
                                                         {MODEL_NAME[MODEL_KEY::ALBUM], MODEL_KEY::ALBUM},
                                                         {MODEL_NAME[MODEL_KEY::ARTIST], MODEL_KEY::ARTIST},
                                                         {MODEL_NAME[MODEL_KEY::DURATION], MODEL_KEY::DURATION},
                                                         {MODEL_NAME[MODEL_KEY::TRACK], MODEL_KEY::TRACK},
                                                         {MODEL_NAME[MODEL_KEY::GENRE], MODEL_KEY::GENRE},
                                                         {MODEL_NAME[MODEL_KEY::LYRICS], MODEL_KEY::LYRICS},
                                                         {MODEL_NAME[MODEL_KEY::RELEASEDATE], MODEL_KEY::RELEASEDATE},
                                                         {MODEL_NAME[MODEL_KEY::FORMAT], MODEL_KEY::FORMAT},
                                                         {MODEL_NAME[MODEL_KEY::WIKI], MODEL_KEY::WIKI},
                                                         {MODEL_NAME[MODEL_KEY::SOURCETYPE], MODEL_KEY::SOURCETYPE},
                                                         {MODEL_NAME[MODEL_KEY::ARTWORK], MODEL_KEY::ARTWORK},
                                                         {MODEL_NAME[MODEL_KEY::NOTE], MODEL_KEY::NOTE},
                                                         {MODEL_NAME[MODEL_KEY::MOOD], MODEL_KEY::MOOD},
                                                         {MODEL_NAME[MODEL_KEY::COMMENT], MODEL_KEY::COMMENT},
                                                         {MODEL_NAME[MODEL_KEY::CONTEXT], MODEL_KEY::CONTEXT},
                                                         {MODEL_NAME[MODEL_KEY::SOURCE], MODEL_KEY::SOURCE},
                                                         {MODEL_NAME[MODEL_KEY::PLAYLIST], MODEL_KEY::PLAYLIST},
                                                         {MODEL_NAME[MODEL_KEY::TITLE], MODEL_KEY::TITLE},
                                                         {MODEL_NAME[MODEL_KEY::ID], MODEL_KEY::ID},
                                                         {MODEL_NAME[MODEL_KEY::PARENT_ID], MODEL_KEY::PARENT_ID},
                                                         {MODEL_NAME[MODEL_KEY::LICENSE], MODEL_KEY::LICENSE},
                                                         {MODEL_NAME[MODEL_KEY::DESCRIPTION], MODEL_KEY::DESCRIPTION},
                                                         {MODEL_NAME[MODEL_KEY::BOOKMARK], MODEL_KEY::BOOKMARK},
                                                         {MODEL_NAME[MODEL_KEY::ACCOUNT], MODEL_KEY::ACCOUNT},
                                                         {MODEL_NAME[MODEL_KEY::ACCOUNTTYPE], MODEL_KEY::ACCOUNTTYPE},
                                                         {MODEL_NAME[MODEL_KEY::VERSION], MODEL_KEY::VERSION},
                                                         {MODEL_NAME[MODEL_KEY::DOMAIN_M], MODEL_KEY::DOMAIN_M},
                                                         {MODEL_NAME[MODEL_KEY::CATEGORY], MODEL_KEY::CATEGORY},
                                                         {MODEL_NAME[MODEL_KEY::CONTENT], MODEL_KEY::CONTENT},
                                                         {MODEL_NAME[MODEL_KEY::PIN], MODEL_KEY::PIN},
                                                         {MODEL_NAME[MODEL_KEY::IMG], MODEL_KEY::IMG},
                                                         {MODEL_NAME[MODEL_KEY::PREVIEW], MODEL_KEY::PREVIEW},
                                                         {MODEL_NAME[MODEL_KEY::LINK], MODEL_KEY::LINK},
                                                         {MODEL_NAME[MODEL_KEY::STAMP], MODEL_KEY::STAMP},
                                                         {MODEL_NAME[MODEL_KEY::BOOK], MODEL_KEY::BOOK},

                                                         /** ccdav keys **/
                                                         {MODEL_NAME[MODEL_KEY::N], MODEL_KEY::N},
                                                         {MODEL_NAME[MODEL_KEY::IM], MODEL_KEY::IM},
                                                         {MODEL_NAME[MODEL_KEY::PHOTO], MODEL_KEY::PHOTO},
                                                         {MODEL_NAME[MODEL_KEY::GENDER], MODEL_KEY::GENDER},
                                                         {MODEL_NAME[MODEL_KEY::ADR], MODEL_KEY::ADR},
                                                         {MODEL_NAME[MODEL_KEY::ADR_2], MODEL_KEY::ADR_2},
                                                         {MODEL_NAME[MODEL_KEY::ADR_3], MODEL_KEY::ADR_3},
                                                         {MODEL_NAME[MODEL_KEY::EMAIL], MODEL_KEY::EMAIL},
                                                         {MODEL_NAME[MODEL_KEY::EMAIL_2], MODEL_KEY::EMAIL_2},
                                                         {MODEL_NAME[MODEL_KEY::EMAIL_3], MODEL_KEY::EMAIL_3},
                                                         {MODEL_NAME[MODEL_KEY::LANG], MODEL_KEY::LANG},
                                                         {MODEL_NAME[MODEL_KEY::NICKNAME], MODEL_KEY::NICKNAME},
                                                         {MODEL_NAME[MODEL_KEY::ORG], MODEL_KEY::ORG},
                                                         {MODEL_NAME[MODEL_KEY::PROFILE], MODEL_KEY::PROFILE},
                                                         {MODEL_NAME[MODEL_KEY::TZ], MODEL_KEY::TZ},
                                                         {MODEL_NAME[MODEL_KEY::TEL], MODEL_KEY::TEL},
                                                         {MODEL_NAME[MODEL_KEY::TEL_2], MODEL_KEY::TEL_2},
                                                         {MODEL_NAME[MODEL_KEY::TEL_3], MODEL_KEY::TEL_3},

                                                         {MODEL_NAME[MODEL_KEY::CITY], MODEL_KEY::CITY},
                                                         {MODEL_NAME[MODEL_KEY::STATE], MODEL_KEY::STATE},
                                                         {MODEL_NAME[MODEL_KEY::COUNTRY], MODEL_KEY::COUNTRY},

                                                         // opendesktop store keys
                                                         {MODEL_NAME[MODEL_KEY::PACKAGE_ARCH], MODEL_KEY::PACKAGE_ARCH},
                                                         {MODEL_NAME[MODEL_KEY::PACKAGE_TYPE], MODEL_KEY::PACKAGE_TYPE},
                                                         {MODEL_NAME[MODEL_KEY::GPG_FINGERPRINT], MODEL_KEY::GPG_FINGERPRINT},
                                                         {MODEL_NAME[MODEL_KEY::GPG_SIGNATURE], MODEL_KEY::GPG_SIGNATURE},
                                                         {MODEL_NAME[MODEL_KEY::PACKAGE_NAME], MODEL_KEY::PACKAGE_NAME},
                                                         {MODEL_NAME[MODEL_KEY::PRICE], MODEL_KEY::PRICE},
                                                         {MODEL_NAME[MODEL_KEY::REPOSITORY], MODEL_KEY::REPOSITORY},
                                                         {MODEL_NAME[MODEL_KEY::TAGS], MODEL_KEY::TAGS},
                                                         {MODEL_NAME[MODEL_KEY::WAY], MODEL_KEY::WAY},
                                                         {MODEL_NAME[MODEL_KEY::PIC], MODEL_KEY::PIC},
                                                         {MODEL_NAME[MODEL_KEY::SMALL_PIC], MODEL_KEY::SMALL_PIC},
                                                         {MODEL_NAME[MODEL_KEY::CHANGED], MODEL_KEY::CHANGED},
                                                         {MODEL_NAME[MODEL_KEY::COMMENTS], MODEL_KEY::COMMENTS},
                                                         {MODEL_NAME[MODEL_KEY::CREATED], MODEL_KEY::CREATED},
                                                         {MODEL_NAME[MODEL_KEY::DETAIL_PAGE], MODEL_KEY::DETAIL_PAGE},
                                                         {MODEL_NAME[MODEL_KEY::DETAILS], MODEL_KEY::DETAILS},
                                                         {MODEL_NAME[MODEL_KEY::TOTAL_DOWNLOADS], MODEL_KEY::TOTAL_DOWNLOADS},
                                                         {MODEL_NAME[MODEL_KEY::GHNS_EXCLUDED], MODEL_KEY::GHNS_EXCLUDED},
                                                         {MODEL_NAME[MODEL_KEY::LANGUAGE], MODEL_KEY::LANGUAGE},
                                                         {MODEL_NAME[MODEL_KEY::PERSON_ID], MODEL_KEY::PERSON_ID},
                                                         {MODEL_NAME[MODEL_KEY::SCORE], MODEL_KEY::SCORE},
                                                         {MODEL_NAME[MODEL_KEY::SUMMARY], MODEL_KEY::SUMMARY},
                                                         {MODEL_NAME[MODEL_KEY::TYPE_ID], MODEL_KEY::TYPE_ID},
                                                         {MODEL_NAME[MODEL_KEY::TYPE_NAME], MODEL_KEY::TYPE_NAME},
                                                         {MODEL_NAME[MODEL_KEY::XDG_TYPE], MODEL_KEY::XDG_TYPE},

                                                         // file props
                                                         {MODEL_NAME[MODEL_KEY::SYMLINK], MODEL_KEY::SYMLINK},
                                                         {MODEL_NAME[MODEL_KEY::IS_SYMLINK], MODEL_KEY::IS_SYMLINK},
                                                         {MODEL_NAME[MODEL_KEY::LAST_READ], MODEL_KEY::LAST_READ},
                                                         {MODEL_NAME[MODEL_KEY::READABLE], MODEL_KEY::READABLE},
                                                         {MODEL_NAME[MODEL_KEY::WRITABLE], MODEL_KEY::WRITABLE},
                                                         {MODEL_NAME[MODEL_KEY::IS_DIR], MODEL_KEY::IS_DIR},
                                                         {MODEL_NAME[MODEL_KEY::IS_FILE], MODEL_KEY::IS_FILE},
                                                         {MODEL_NAME[MODEL_KEY::IS_REMOTE], MODEL_KEY::IS_REMOTE},
                                                         {MODEL_NAME[MODEL_KEY::EXECUTABLE], MODEL_KEY::EXECUTABLE},
                                                         {MODEL_NAME[MODEL_KEY::VALUE], MODEL_KEY::VALUE},
                                                         {MODEL_NAME[MODEL_KEY::KEY], MODEL_KEY::KEY},

                                                         {MODEL_NAME[MODEL_KEY::MAC], MODEL_KEY::MAC},
                                                         {MODEL_NAME[MODEL_KEY::LOT], MODEL_KEY::LOT},
                                                         {MODEL_NAME[MODEL_KEY::APP], MODEL_KEY::APP},
                                                         {MODEL_NAME[MODEL_KEY::URI], MODEL_KEY::URI},
                                                         {MODEL_NAME[MODEL_KEY::DEVICE], MODEL_KEY::DEVICE},
                                                         {MODEL_NAME[MODEL_KEY::UDI], MODEL_KEY::UDI},
                                                         {MODEL_NAME[MODEL_KEY::LASTSYNC], MODEL_KEY::LASTSYNC}};
/**
 * @brief MODEL
 */
typedef QHash<MODEL_KEY, QString> MODEL;

/**
 * @brief MODEL_LIST
 */
typedef QVector<MODEL> MODEL_LIST;

/**
 * @brief modelRoles
 * @param model
 * @return
 */
const QVector<int> MAUIKIT_EXPORT modelRoles(const MODEL &model);

/**
 * @brief mapValue
 * @param map
 * @param key
 * @return
 */
const QString MAUIKIT_EXPORT mapValue(const QVariantMap &map, const MODEL_KEY &key);

/**
 * @brief toMap
 * @param model
 * @return
 */
const QVariantMap MAUIKIT_EXPORT toMap(const MODEL &model);

/**
 * @brief toModel
 * @param map
 * @return
 */
const MODEL MAUIKIT_EXPORT toModel(const QVariantMap &map);

/**
 * Creates a MODEL_LIST from a QVariantList
 * */
/**
 * @brief toModelList
 * @param list
 * @return
 */
const MODEL_LIST MAUIKIT_EXPORT toModelList(const QVariantList &list);

/**
 * Creates a QVariantList from a MODEL_LIST
 * */
/**
 * @brief toMapList
 * @param list
 * @return
 */
const QVariantList MAUIKIT_EXPORT toMapList(const MODEL_LIST &list);

/**
 * Creates a new MODEL from another filtered by the given array of MODEL_KEY
 * */
/**
 * @brief filterModel
 * @param model
 * @param keys
 * @return
 */
const MODEL MAUIKIT_EXPORT filterModel(const MODEL &model, const QVector<MODEL_KEY> &keys);

/**
 * Extracts from a MODEL_LIST the values from a given MODEL::KEY into a QStringList
 * */

/**
 * @brief modelToList
 * @param list
 * @param key
 * @return
 */
const QStringList MAUIKIT_EXPORT modelToList(const MODEL_LIST &list, const MODEL_KEY &key);



/**
 * Checks if a local file exists.
 * The URL must represent a local file path, by using the scheme file://
 **/
/**
 * @brief fileExists
 * @param path
 * @return
 */
bool MAUIKIT_EXPORT fileExists(const QUrl &path);


}

#endif // FMH_H
