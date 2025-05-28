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

#include <MauiKit4/Core/mauiapp.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));

    KLocalizedString::setApplicationDomain("mauidemo");

    MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/mauikitapp/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    engine.load(url);

    return app.exec();
}
