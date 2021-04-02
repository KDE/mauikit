#include "fmh.h"

namespace FMH
{
const QVector<int> modelRoles(const FMH::MODEL &model)
{
    const auto keys = model.keys();
    return std::accumulate(keys.begin(), keys.end(), QVector<int>(), [](QVector<int> &res, const FMH::MODEL_KEY &key) {
        res.append(key);
        return res;
    });
}

const QString mapValue(const QVariantMap &map, const FMH::MODEL_KEY &key)
{
    return map[FMH::MODEL_NAME[key]].toString();
}

const QVariantMap toMap(const FMH::MODEL &model)
{
    QVariantMap map;
    for (const auto &key : model.keys())
        map.insert(FMH::MODEL_NAME[key], model[key]);

    return map;
}

const FMH::MODEL toModel(const QVariantMap &map)
{
    FMH::MODEL model;
    for (const auto &key : map.keys())
        model.insert(FMH::MODEL_NAME_KEY[key], map[key].toString());

    return model;
}

const FMH::MODEL_LIST toModelList(const QVariantList &list)
{
    FMH::MODEL_LIST res;
    return std::accumulate(list.constBegin(), list.constEnd(), res, [](FMH::MODEL_LIST &res, const QVariant &item) -> FMH::MODEL_LIST {
        res << FMH::toModel(item.toMap());
        return res;
    });
}

const QVariantList toMapList(const FMH::MODEL_LIST &list)
{
    QVariantList res;
    return std::accumulate(list.constBegin(), list.constEnd(), res, [](QVariantList &res, const FMH::MODEL &item) -> QVariantList {
        res << FMH::toMap(item);
        return res;
    });
}

const FMH::MODEL filterModel(const FMH::MODEL &model, const QVector<FMH::MODEL_KEY> &keys)
{
    FMH::MODEL res;
    return std::accumulate(keys.constBegin(), keys.constEnd(), res, [=](FMH::MODEL &res, const FMH::MODEL_KEY &key) -> FMH::MODEL {
        if (model.contains(key))
            res[key] = model[key];
        return res;
    });
}

const QStringList modelToList(const FMH::MODEL_LIST &list, const FMH::MODEL_KEY &key)
{
    QStringList res;
    return std::accumulate(list.constBegin(), list.constEnd(), res, [key](QStringList &res, const FMH::MODEL &item) -> QStringList {
        if (item.contains(key))
            res << item[key];
        return res;
    });
}

bool isAndroid()
{
#if defined(Q_OS_ANDROID)
    return true;
#else
    return false;
#endif
}

bool isWindows()
{
#if defined(Q_OS_WIN32)
    return true;
#elif defined(Q_OS_WIN64)
    return true;
#else
    return false;
#endif
}

bool isLinux()
{
#if defined Q_OS_LINUX && !defined Q_OS_ANDROID
    return true;
#else
    return false;
#endif
}

bool isMac()
{
#if defined(Q_OS_MACOS)
    return true;
#elif defined(Q_OS_MAC)
    return true;
#else
    return false;
#endif
}

bool isIOS()
{
#if defined(Q_OS_iOS)
    return true;
#else
    return false;
#endif
}

bool fileExists(const QUrl &path)
{
    if (!path.isLocalFile()) {
        qWarning() << "URL recived is not a local file" << path;
        return false;
    }
    return QFileInfo::exists(path.toLocalFile());
}

const QVariantMap dirConf(const QUrl &path)
{
    if (!path.isLocalFile()) {
        qWarning() << "URL recived is not a local file" << path;
        return QVariantMap();
    }

    if (!fileExists(path))
        return QVariantMap();

    QString icon, iconsize, hidden, detailview, showthumbnail, showterminal;

    uint count = 0, sortby = MODEL_KEY::MODIFIED, viewType = 0;

    bool foldersFirst = false;

#if defined Q_OS_ANDROID || defined Q_OS_WIN || defined Q_OS_MACOS || defined Q_OS_IOS
    QSettings file(path.toLocalFile(), QSettings::Format::NativeFormat);
    file.beginGroup(QString("Desktop Entry"));
    icon = file.value("Icon").toString();
    file.endGroup();

    file.beginGroup(QString("Settings"));
    hidden = file.value("HiddenFilesShown").toString();
    file.endGroup();

    file.beginGroup(QString("MAUIFM"));
    iconsize = file.value("IconSize").toString();
    detailview = file.value("DetailView").toString();
    showthumbnail = file.value("ShowThumbnail").toString();
    showterminal = file.value("ShowTerminal").toString();
    count = file.value("Count").toInt();
    sortby = file.value("SortBy").toInt();
    foldersFirst = file.value("FoldersFirst").toBool();
    viewType = file.value("ViewType").toInt();
    file.endGroup();

#else
    KConfig file(path.toLocalFile());
    icon = file.entryMap(QString("Desktop Entry"))["Icon"];
    hidden = file.entryMap(QString("Settings"))["HiddenFilesShown"];
    iconsize = file.entryMap(QString("MAUIFM"))["IconSize"];
    detailview = file.entryMap(QString("MAUIFM"))["DetailView"];
    showthumbnail = file.entryMap(QString("MAUIFM"))["ShowThumbnail"];
    showterminal = file.entryMap(QString("MAUIFM"))["ShowTerminal"];
    count = file.entryMap(QString("MAUIFM"))["Count"].toInt();
    sortby = file.entryMap(QString("MAUIFM"))["SortBy"].toInt();
    foldersFirst = file.entryMap(QString("MAUIFM"))["FoldersFirst"] == "true" ? true : false;
    viewType = file.entryMap(QString("MAUIFM"))["ViewType"].toInt();
#endif

    return QVariantMap({{MODEL_NAME[MODEL_KEY::ICON], icon.isEmpty() ? "folder" : icon},
                        {MODEL_NAME[MODEL_KEY::ICONSIZE], iconsize},
                        {MODEL_NAME[MODEL_KEY::COUNT], count},
                        {MODEL_NAME[MODEL_KEY::SHOWTERMINAL], showterminal.isEmpty() ? "false" : showterminal},
                        {MODEL_NAME[MODEL_KEY::SHOWTHUMBNAIL], showthumbnail.isEmpty() ? "false" : showthumbnail},
                        {MODEL_NAME[MODEL_KEY::DETAILVIEW], detailview.isEmpty() ? "false" : detailview},
                        {MODEL_NAME[MODEL_KEY::HIDDEN], hidden.isEmpty() ? false : (hidden == "true" ? true : false)},
                        {MODEL_NAME[MODEL_KEY::SORTBY], sortby},
                        {MODEL_NAME[MODEL_KEY::FOLDERSFIRST], foldersFirst},
                        {MODEL_NAME[MODEL_KEY::VIEWTYPE], viewType}});
}

void setDirConf(const QUrl &path, const QString &group, const QString &key, const QVariant &value)
{
    if (!path.isLocalFile()) {
        qWarning() << "URL recived is not a local file" << path;
        return;
    }

#if defined Q_OS_ANDROID || defined Q_OS_WIN || defined Q_OS_MACOS || defined Q_OS_IOS
    QSettings file(path.toLocalFile(), QSettings::Format::IniFormat);
    file.beginGroup(group);
    file.setValue(key, value);
    file.endGroup();
    file.sync();
#else
    KConfig file(path.toLocalFile(), KConfig::SimpleConfig);
    auto kgroup = file.group(group);
    kgroup.writeEntry(key, value);
    // 		file.reparseConfiguration();
    file.sync();
#endif
}

const QString getIconName(const QUrl &path)
{
    if (path.isLocalFile() && QFileInfo(path.toLocalFile()).isDir()) {
        if (folderIcon.contains(path.toString()))
            return folderIcon[path.toString()];
        else {
            const auto icon = dirConf(QString(path.toString() + "/%1").arg(".directory"))[MODEL_NAME[MODEL_KEY::ICON]].toString();
            return icon.isEmpty() ? "folder" : icon;
        }

    } else {
#if defined Q_OS_ANDROID || defined Q_OS_MACOS || defined Q_OS_IOS
        QMimeDatabase mime;
        const auto type = mime.mimeTypeForFile(path.toString());
        return type.iconName();
#else
        KFileItem mime(path);
        return mime.iconName();
#endif
    }
}

const QString getMime(const QUrl &path)
{
    if (!path.isLocalFile()) {
        qWarning() << "URL recived is not a local file, getMime" << path;
        return QString();
    }

    const QMimeDatabase mimedb;
    return mimedb.mimeTypeForFile(path.toLocalFile()).name();
}


PATHTYPE_KEY getPathType(const QUrl &url)
{
    return PATHTYPE_SCHEME_NAME[url.scheme()];
}

bool checkFileType(const FMH::FILTER_TYPE &type, const QString &mimeTypeName)
{
    return SUPPORTED_MIMETYPES[type].contains(mimeTypeName);
}

}
