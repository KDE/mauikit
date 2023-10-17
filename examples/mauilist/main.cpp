#include <QQmlApplicationEngine>

#include <QCommandLineParser>
#include <QFileInfo>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QGuiApplication>
#include <QIcon>

#include <KLocalizedString>
#include <KAboutData>

#include <MauiKit3/Core/mauiapp.h>
#include "plantslist.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));

    KLocalizedString::setApplicationDomain("mauidemo");

    MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/untitled1-6/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    qmlRegisterType<PlantsList>("org.maui.demo", 1, 0, "PlantsList");

    engine.load(url);

    return app.exec();
}
