#include "fmh.h"

#include <QDebug>
#include <QFileInfo>

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
    const auto keys = model.keys();
    for (const auto &key : keys)
    {
        map.insert(FMH::MODEL_NAME[key], model[key]);
    }

    return map;
}

const FMH::MODEL toModel(const QVariantMap &map)
{
    FMH::MODEL model;
    const auto keys = map.keys();
    for (const auto &key : keys)
    {
        model.insert(FMH::MODEL_NAME_KEY[key], map[key].toString());
    }

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


}
