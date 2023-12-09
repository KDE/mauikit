Quick start tutorial {#quickstart}
===================

## Setup 

For this guide we will create an image tagging editor, for this purpose will be using most of the MauiKit File Browsing controls and some of the classes.

Our project file structure consists for now of only three file: `main.cpp`, `main.qml` and `CMakeLists.txt`

The starting point is to setup the CMakeLists file by linking to `MauiKitFileBrowsing4` library and its dependencies.

First, to find the needed files for the package one could use the line `find_package(MauiKitFileBrowsing4)`, but given we will also be using MauiKit4 core controls, instead we will use the following components syntax `find_package(MauiKit4 REQUIRED COMPONENT FileBrowsing)`, so both packages can be found and linked- the CMake file would look something like this:

    cmake_minimum_required(VERSION 3.14)

    project(MuTag VERSION 0.1 LANGUAGES CXX)

    set(CMAKE_AUTOMOC ON)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)

    find_package(ECM NO_MODULE)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

    find_package(Qt6 REQUIRED COMPONENTS Quick Qml)
    find_package(KF6 COMPONENTS I18n CoreAddons)
    find_package(MauiKit4 REQUIRED COMPONENTS FileBrowsing)

    qt_add_executable(${PROJECT_NAME}App
        main.cpp)

    qt_add_qml_module(${PROJECT_NAME}App
        URI ${PROJECT_NAME}
        VERSION 1.0
        QML_FILES main.qml)

    target_link_libraries(${PROJECT_NAME}App
        PRIVATE
        Qt6::Quick
        Qt6::Qml
        MauiKit4
        MauiKit4::FileBrowsing
        KF6::I18n
        KF6::CoreAddons)

    install(TARGETS ${PROJECT_NAME}App
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})


The next step is to setup the main entry point with the information about the application. Take a look at the `main.cpp` source file:

    #include <QQmlApplicationEngine>
    #include <QQmlContext>

    #include <QGuiApplication>
    #include <QIcon>

    #include <KLocalizedString>
    #include <KAboutData>

    #include <MauiKit3/Core/mauiapp.h>

    int main(int argc, char *argv[])
    {
        QGuiApplication app(argc, argv);

        app.setOrganizationName(QStringLiteral("Maui"));
        app.setWindowIcon(QIcon(":/assets/mauidemo.svg"));

        KLocalizedString::setApplicationDomain("MuTag");
        KAboutData about(QStringLiteral("MuTag"),
                        i18n("MuTag"),
                        "3.0.0",
                        i18n("Music Files Tagging."),
                        KAboutLicense::LGPL_V3); //here you can set information about the application, which will be fetched by the about dialog.

        about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
        about.setHomepage("https://mauikit.org");
        about.setProductName("maui/mutag");
        about.setBugAddress("https://invent.kde.org/camiloh/mutag/-/issues");
        about.setOrganizationDomain("org.mutag.app");
        about.setProgramLogo(app.windowIcon());
        about.addComponent("MauiKit File Browsing");

        KAboutData::setApplicationData(about);
        
        MauiApp::instance()->setIconName("qrc:/assets/mauidemo.svg"); // this not only sets the path to the icon file asset, but also takes care of initializing the MauiApp singleton instance.

        QQmlApplicationEngine engine;
        const QUrl url(u"qrc:/MuTag/main.qml"_qs);
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
            &app, [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);

        engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

        engine.load(url);

        return app.exec();
    }

In the code snippet above the information about the application is done using the KDE framework KCoreAddons module `KAboutData`. And another important part is to initialize the MauiKit Application instance, so the styling and other parts work correctly, this is done by calling the `MauiApp::instance()` singleton instance with `MauiApp::instance()->setIconName()`.

The next steps will take care of loading our main QML file `main.qml`:

    import org.mauikit.controls as Maui

    Maui.ApplicationWindow
    {
        id: root

        Maui.Page
        {
            anchors.fill: parent
            Maui.Controls.showCSD: true
        }
    }

## The App Requirements 
Next step will be to stablish what is the application roles and what building blocks it needs top achieve its main tasks.

The requirements for this demo app are:
- Add, edit and remove tags to any image file selected
- List all the tags
- List all the images associated to a selected tag

To achieve these, the main page of our application will look something like the following image. Where the user can select an existing tag to list all the image files associated to it, or to click on a button to launch a `FileDialog` to select a new image to edit or add new tags to it. So far, the application will have to pages, one for tag browsing an another for the image tags editing.

 
