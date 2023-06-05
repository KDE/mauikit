#include "mauistyleplugin.h"
#include <QQmlContext>
#include <QQmlEngine>

MauiStylePlugin::MauiStylePlugin(QObject *parent) : QQmlExtensionPlugin(parent)
{

}

MauiStylePlugin::~MauiStylePlugin()
{

}

QString MauiStylePlugin::name() const
{
    return QStringLiteral("org.mauikit.style");
}

void MauiStylePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == name());

    // BEGIN org.kde.breeze
//    qmlRegisterModule(uri, 1, 0);
//    qmlRegisterType<PaintedSymbolItem>(uri, 1, 0, "PaintedSymbol");
//    qmlRegisterType<IconLabelLayout>(uri, 1, 0, "IconLabelLayout");
//    qmlRegisterType<BreezeDial>(uri, 1, 0, "BreezeDial");
//    // KColorUtilsSingleton only has invocable functions.
//    // Would this be better off being a SingletonInstance?
//    qmlRegisterSingletonType<KColorUtilsSingleton>(uri, 1, 0, "KColorUtils", [](QQmlEngine *, QJSEngine *) -> QObject * {
//        return new KColorUtilsSingleton;
//    });
    // END

    // Prevent additional types from being added.
    qmlProtectModule(uri, 1);
}
