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
    UDI,
    LATITUDE,
    LONGITUDE,
    MESSAGE,
    AUTHOR,
    BRANCH,
    UPDATABLE
};

static const QHash<MODEL_KEY, QString> MODEL_NAME = {{MODEL_KEY::ICON, QStringLiteral("icon")},
                                                     {MODEL_KEY::LABEL, QStringLiteral("label")},
                                                     {MODEL_KEY::PATH, QStringLiteral("path")},
                                                     {MODEL_KEY::URL, QStringLiteral("url")},
                                                     {MODEL_KEY::TYPE, QStringLiteral("type")},
                                                     {MODEL_KEY::GROUP, QStringLiteral("group")},
                                                     {MODEL_KEY::OWNER, QStringLiteral("owner")},
                                                     {MODEL_KEY::SUFFIX, QStringLiteral("suffix")},
                                                     {MODEL_KEY::NAME, QStringLiteral("name")},
                                                     {MODEL_KEY::DATE, QStringLiteral("date")},
                                                     {MODEL_KEY::MODIFIED, QStringLiteral("modified")},
                                                     {MODEL_KEY::MIME, QStringLiteral("mime")},
                                                     {MODEL_KEY::SIZE, QStringLiteral("size")},
                                                     {MODEL_KEY::TAG, QStringLiteral("tag")},
                                                     {MODEL_KEY::PERMISSIONS, QStringLiteral("permissions")},
                                                     {MODEL_KEY::THUMBNAIL, QStringLiteral("thumbnail")},
                                                     {MODEL_KEY::THUMBNAIL_1, QStringLiteral("thumbnail_1")},
                                                     {MODEL_KEY::THUMBNAIL_2, QStringLiteral("thumbnail_2")},
                                                     {MODEL_KEY::THUMBNAIL_3, QStringLiteral("thumbnail_3")},
                                                     {MODEL_KEY::ICONSIZE, QStringLiteral("iconsize")},
                                                     {MODEL_KEY::HIDDEN, QStringLiteral("hidden")},
                                                     {MODEL_KEY::DETAILVIEW, QStringLiteral("detailview")},
                                                     {MODEL_KEY::SHOWTERMINAL, QStringLiteral("showterminal")},
                                                     {MODEL_KEY::SHOWTHUMBNAIL, QStringLiteral("showthumbnail")},
                                                     {MODEL_KEY::COUNT, QStringLiteral("count")},
                                                     {MODEL_KEY::SORTBY, QStringLiteral("sortby")},
                                                     {MODEL_KEY::USER, QStringLiteral("user")},
                                                     {MODEL_KEY::PASSWORD, QStringLiteral("password")},
                                                     {MODEL_KEY::SERVER, QStringLiteral("server")},
                                                     {MODEL_KEY::FOLDERSFIRST, QStringLiteral("foldersfirst")},
                                                     {MODEL_KEY::VIEWTYPE, QStringLiteral("viewtype")},
                                                     {MODEL_KEY::ADDDATE, QStringLiteral("adddate")},
                                                     {MODEL_KEY::FAV, QStringLiteral("fav")},
                                                     {MODEL_KEY::FAVORITE, QStringLiteral("favorite")},
                                                     {MODEL_KEY::COLOR, QStringLiteral("color")},
                                                     {MODEL_KEY::RATE, QStringLiteral("rate")},
                                                     {MODEL_KEY::FORMAT, QStringLiteral("format")},
                                                     {MODEL_KEY::PLACE, QStringLiteral("place")},
                                                     {MODEL_KEY::LOCATION, QStringLiteral("location")},
                                                     {MODEL_KEY::ALBUM, QStringLiteral("album")},
                                                     {MODEL_KEY::DURATION, QStringLiteral("duration")},
                                                     {MODEL_KEY::RELEASEDATE, QStringLiteral("releasedate")},
                                                     {MODEL_KEY::ARTIST, QStringLiteral("artist")},
                                                     {MODEL_KEY::LYRICS, QStringLiteral("lyrics")},
                                                     {MODEL_KEY::TRACK, QStringLiteral("track")},
                                                     {MODEL_KEY::GENRE, QStringLiteral("genre")},
                                                     {MODEL_KEY::WIKI, QStringLiteral("wiki")},
                                                     {MODEL_KEY::CONTEXT, QStringLiteral("context")},
                                                     {MODEL_KEY::SOURCETYPE, QStringLiteral("sourcetype")},
                                                     {MODEL_KEY::ARTWORK, QStringLiteral("artwork")},
                                                     {MODEL_KEY::NOTE, QStringLiteral("note")},
                                                     {MODEL_KEY::MOOD, QStringLiteral("mood")},
                                                     {MODEL_KEY::COMMENT, QStringLiteral("comment")},
                                                     {MODEL_KEY::PLAYLIST, QStringLiteral("playlist")},
                                                     {MODEL_KEY::SOURCE, QStringLiteral("source")},
                                                     {MODEL_KEY::TITLE, QStringLiteral("title")},
                                                     {MODEL_KEY::ID, QStringLiteral("id")},
                                                     {MODEL_KEY::PERSON_ID, QStringLiteral("personid")},
                                                     {MODEL_KEY::PARENT_ID, QStringLiteral("parentid")},
                                                     {MODEL_KEY::LICENSE, QStringLiteral("license")},
                                                     {MODEL_KEY::DESCRIPTION, QStringLiteral("description")},
                                                     {MODEL_KEY::BOOKMARK, QStringLiteral("bookmark")},
                                                     {MODEL_KEY::ACCOUNT, QStringLiteral("account")},
                                                     {MODEL_KEY::ACCOUNTTYPE, QStringLiteral("accounttype")},
                                                     {MODEL_KEY::VERSION, QStringLiteral("version")},
                                                     {MODEL_KEY::DOMAIN_M, QStringLiteral("domain")},
                                                     {MODEL_KEY::CATEGORY, QStringLiteral("category")},
                                                     {MODEL_KEY::CONTENT, QStringLiteral("content")},
                                                     {MODEL_KEY::PIN, QStringLiteral("pin")},
                                                     {MODEL_KEY::IMG, QStringLiteral("img")},
                                                     {MODEL_KEY::PREVIEW, QStringLiteral("preview")},
                                                     {MODEL_KEY::LINK, QStringLiteral("link")},
                                                     {MODEL_KEY::STAMP, QStringLiteral("stamp")},
                                                     {MODEL_KEY::BOOK, QStringLiteral("book")},

                                                     /** ccdav keys **/
                                                     {MODEL_KEY::N, QStringLiteral("n")},
                                                     {MODEL_KEY::IM, QStringLiteral("im")},
                                                     {MODEL_KEY::PHOTO, QStringLiteral("photo")},
                                                     {MODEL_KEY::GENDER, QStringLiteral("gender")},
                                                     {MODEL_KEY::ADR, QStringLiteral("adr")},
                                                     {MODEL_KEY::ADR_2, QStringLiteral("adr2")},
                                                     {MODEL_KEY::ADR_3, QStringLiteral("adr3")},
                                                     {MODEL_KEY::EMAIL, QStringLiteral("email")},
                                                     {MODEL_KEY::EMAIL_2, QStringLiteral("email2")},
                                                     {MODEL_KEY::EMAIL_3, QStringLiteral("email3")},
                                                     {MODEL_KEY::LANG, QStringLiteral("lang")},
                                                     {MODEL_KEY::NICKNAME, QStringLiteral("nickname")},
                                                     {MODEL_KEY::ORG, QStringLiteral("org")},
                                                     {MODEL_KEY::PROFILE, QStringLiteral("profile")},
                                                     {MODEL_KEY::TZ, QStringLiteral("tz")},
                                                     {MODEL_KEY::TEL, QStringLiteral("tel")},
                                                     {MODEL_KEY::TEL_2, QStringLiteral("tel2")},
                                                     {MODEL_KEY::TEL_3, QStringLiteral("tel3")},

                                                     {MODEL_KEY::CITY, QStringLiteral("city")},
                                                     {MODEL_KEY::STATE, QStringLiteral("state")},
                                                     {MODEL_KEY::COUNTRY, QStringLiteral("country")},

                                                     // opendesktop keys
                                                     {MODEL_KEY::PACKAGE_ARCH, QStringLiteral("packagearch")},
                                                     {MODEL_KEY::PACKAGE_TYPE, QStringLiteral("packagetype")},
                                                     {MODEL_KEY::GPG_FINGERPRINT, QStringLiteral("gpgfingerprint")},
                                                     {MODEL_KEY::GPG_SIGNATURE, QStringLiteral("gpgsignature")},
                                                     {MODEL_KEY::PACKAGE_NAME, QStringLiteral("packagename")},
                                                     {MODEL_KEY::PRICE, QStringLiteral("price")},
                                                     {MODEL_KEY::REPOSITORY, QStringLiteral("repository")},
                                                     {MODEL_KEY::TAGS, QStringLiteral("tags")},
                                                     {MODEL_KEY::WAY, QStringLiteral("way")},
                                                     {MODEL_KEY::PIC, QStringLiteral("pic")},
                                                     {MODEL_KEY::SMALL_PIC, QStringLiteral("smallpic")},
                                                     {MODEL_KEY::CHANGED, QStringLiteral("changed")},
                                                     {MODEL_KEY::COMMENTS, QStringLiteral("comments")},
                                                     {MODEL_KEY::CREATED, QStringLiteral("created")},
                                                     {MODEL_KEY::DETAIL_PAGE, QStringLiteral("detailpage")},
                                                     {MODEL_KEY::DETAILS, QStringLiteral("details")},
                                                     {MODEL_KEY::TOTAL_DOWNLOADS, QStringLiteral("totaldownloads")},
                                                     {MODEL_KEY::GHNS_EXCLUDED, QStringLiteral("ghnsexcluded")},
                                                     {MODEL_KEY::LANGUAGE, QStringLiteral("language")},
                                                     {MODEL_KEY::SCORE, QStringLiteral("score")},
                                                     {MODEL_KEY::SUMMARY, QStringLiteral("summary")},
                                                     {MODEL_KEY::TYPE_ID, QStringLiteral("typeid")},
                                                     {MODEL_KEY::TYPE_NAME, QStringLiteral("typename")},
                                                     {MODEL_KEY::XDG_TYPE, QStringLiteral("xdgtype")},

                                                     // file props
                                                     {MODEL_KEY::SYMLINK, QStringLiteral("symlink")},
                                                     {MODEL_KEY::IS_SYMLINK, QStringLiteral("issymlink")},
                                                     {MODEL_KEY::LAST_READ, QStringLiteral("lastread")},
                                                     {MODEL_KEY::READABLE, QStringLiteral("readable")},
                                                     {MODEL_KEY::WRITABLE, QStringLiteral("writeable")},
                                                     {MODEL_KEY::IS_DIR, QStringLiteral("isdir")},
                                                     {MODEL_KEY::IS_FILE, QStringLiteral("isfile")},
                                                     {MODEL_KEY::IS_REMOTE, QStringLiteral("isremote")},
                                                     {MODEL_KEY::EXECUTABLE, QStringLiteral("executable")},
                                                     {MODEL_KEY::VALUE, QStringLiteral("value")},
                                                     {MODEL_KEY::KEY, QStringLiteral("key")},

                                                     {MODEL_KEY::MAC, QStringLiteral("mac")},
                                                     {MODEL_KEY::LOT, QStringLiteral("lot")},
                                                     {MODEL_KEY::APP, QStringLiteral("app")},
                                                     {MODEL_KEY::URI, QStringLiteral("uri")},
                                                     {MODEL_KEY::DEVICE, QStringLiteral("device")},
                                                     {MODEL_KEY::UDI, QStringLiteral("udi")},
                                                     {MODEL_KEY::LASTSYNC, QStringLiteral("lastsync")},
                                                     {MODEL_KEY::LATITUDE, QStringLiteral("latitude")},
                                                     {MODEL_KEY::BRANCH, QStringLiteral("branch")},
                                                     {MODEL_KEY::MESSAGE, QStringLiteral("message")},
                                                     {MODEL_KEY::AUTHOR, QStringLiteral("author")},
                                                     {MODEL_KEY::UPDATABLE, QStringLiteral("updatable")},
                                                     {MODEL_KEY::LONGITUDE, QStringLiteral("lastsync")}};
                                                     
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
                                                         {MODEL_NAME[MODEL_KEY::SIZE], MODEL_KEY::SIZE},
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
                                                         {MODEL_NAME[MODEL_KEY::LASTSYNC], MODEL_KEY::LASTSYNC},
                                                         {MODEL_NAME[MODEL_KEY::LATITUDE], MODEL_KEY::LATITUDE},
                                                         {MODEL_NAME[MODEL_KEY::LONGITUDE], MODEL_KEY::LONGITUDE},
                                                         {MODEL_NAME[MODEL_KEY::MESSAGE], MODEL_KEY::MESSAGE},
                                                         {MODEL_NAME[MODEL_KEY::AUTHOR], MODEL_KEY::AUTHOR},
                                                         {MODEL_NAME[MODEL_KEY::UPDATABLE], MODEL_KEY::UPDATABLE},
                                                         {MODEL_NAME[MODEL_KEY::BRANCH], MODEL_KEY::BRANCH}};
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
