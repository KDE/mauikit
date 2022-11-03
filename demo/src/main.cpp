#include <QQmlApplicationEngine>

#include <QCommandLineParser>
#include <QFileInfo>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QIcon>
#else
#include <QApplication>
#endif

#include <MauiKit/Core/mauiapp.h>


Q_DECL_EXPORT int main(int argc, char *argv[])
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    
#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    //    QGuiApplication::styleHints()->setMousePressAndHoldInterval(2000); // in [ms]
#else
    QApplication app(argc, argv);
#endif

    app.setApplicationName("MauiDemo");
    app.setApplicationVersion("1.0.0");
    app.setApplicationDisplayName("Maui Demo");
    app.setWindowIcon(QIcon(":/../assets/mauidemo.svg"));

        MauiApp::instance()->setIconName("qrc:/../assets/mauidemo.svg");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
