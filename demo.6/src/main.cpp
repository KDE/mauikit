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


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Maui"));
    app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));

    KLocalizedString::setApplicationDomain("mauidemo");

    KAboutData about(QStringLiteral("mauidemo"),
                     i18n("Maui Demo"),
                     "3.0.0",
                     i18n("MauiKit Qt6 Demo."),
                     KAboutLicense::LGPL_V3,
                     i18n("© 2023-%1 Maui Development Team", QString::number(QDate::currentDate().year())), "qt6-2");

    about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/index");
    about.setBugAddress("https://invent.kde.org/maui/index-fm/-/issues");
    about.setOrganizationDomain("org.qt6.tst");
    about.setProgramLogo(app.windowIcon());
    about.addComponent("KIO");

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qt/qml/MauiDemo4/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    engine.load(url);

    return app.exec();
}
