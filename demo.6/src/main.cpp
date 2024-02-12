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

#include "utils/mauiapp.h"
#include "utils/moduleinfo.h"


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));

    KLocalizedString::setApplicationDomain("mauidemo");

    KAboutData about(QStringLiteral("mauidemo"),
                     QStringLiteral("MauiKit Demo"),
                     MauiKitCore::versionString(),
                     i18n("Demo fo MauiKit controls and elements."),
                     KAboutLicense::LGPL_V3,
                     QStringLiteral(APP_COPYRIGHT_NOTICE),
                     QStringLiteral(GIT_BRANCH) + "/" + QStringLiteral(GIT_COMMIT_HASH));

    about.addAuthor(QStringLiteral("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/mauidemo");
    about.setBugAddress("https://invent.kde.org/maui/mauikit/-/issues");
    about.setOrganizationDomain("org.mauikit.demo");
    about.setProgramLogo(app.windowIcon());

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qt/qml/MauiDemo4Module/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    engine.load(url);

    return app.exec();
}
